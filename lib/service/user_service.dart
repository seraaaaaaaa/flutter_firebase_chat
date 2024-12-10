import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_firebase/model/user_model.dart';
import 'package:image_picker/image_picker.dart';

class UserService {
  final _firebaseFirestore = FirebaseFirestore.instance;
  final _firebaseAuth = FirebaseAuth.instance;
  final _firebaseStorage = FirebaseStorage.instance;

  Future<bool> isNewEmail(String email) async {
    QuerySnapshot querySnapshot = await _firebaseFirestore
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    return querySnapshot.size == 0;
  }

  Future<String> createAccount(
      String email, String password, String name) async {
    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((onValue) async {
        var newUser = UserModel(
          email: email,
          createdAt: DateTime.now(),
        );

        //create doc in cloud firestore with user details
        await _firebaseFirestore
            .collection('users')
            .doc(onValue.user!.uid)
            .set(newUser.toJson());

        await onValue.user!.updateDisplayName(name);
      });

      return "";
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<String> login(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return "";
    } on FirebaseAuthException catch (e) {
      return e.message ?? e.toString();
    }
  }

  Future<String> loginWithLink(String email) async {
    try {
      await _firebaseAuth.sendSignInLinkToEmail(
          email: email, actionCodeSettings: ActionCodeSettings(url: ''));

      return "Login link has been sent to your email";
    } on FirebaseAuthException catch (e) {
      return e.message ?? e.toString();
    }
  }

  Future loginAsGuest() async {
    await _firebaseAuth.signInAnonymously();
  }

  Future logout() async {
    if (_firebaseAuth.currentUser!.isAnonymous) {
      deleteAccount(_firebaseAuth.currentUser!.uid);
    }
    await _firebaseAuth.signOut();
  }

  Future<User?> getUser() async {
    return _firebaseAuth.currentUser;
  }

  Future<void> updateName(String name) async {
    await _firebaseAuth.currentUser?.updateDisplayName(name);

    await _firebaseAuth.currentUser?.reload();
  }

  Future<String> changePassword(
      String newPassowrd, String confirmPassword) async {
    try {
      if (newPassowrd != confirmPassword) {
        return 'Passwords do not match';
      }

      await _firebaseAuth.currentUser?.updatePassword(newPassowrd);

      return "";
    } on FirebaseAuthException catch (e) {
      return e.message ?? e.toString();
    }
  }

  Future<User?> uploadProfilePhoto(XFile imgFile, String userId) async {
    File? file = File(imgFile.path);

    try {
      String fileName = file.path.split('/').last;
      Reference reference =
          _firebaseStorage.ref().child('profileImg/$userId/$fileName');
      UploadTask uploadTask = reference.putFile(file);

      TaskSnapshot snapshot = await uploadTask;
      String imageUrl = await snapshot.ref.getDownloadURL();

      await _firebaseAuth.currentUser?.updatePhotoURL(imageUrl);

      await _firebaseAuth.currentUser?.reload();

      return _firebaseAuth.currentUser;
    } catch (e) {
      //print(e);
    }

    return null;
  }

  Future<User?> removeProfilePhoto(String imageUrl) async {
    try {
      if (imageUrl.isNotEmpty) {
        Reference reference = _firebaseStorage.refFromURL(imageUrl);
        await reference.delete();
      }

      await _firebaseAuth.currentUser?.updatePhotoURL(null);

      await _firebaseAuth.currentUser?.reload();

      return _firebaseAuth.currentUser;
    } catch (e) {
      // print(e);
    }

    return null;
  }

  Future<void> deleteAccount(String userId) async {
    try {
      await deleteUserChat(userId);

      await _firebaseAuth.currentUser?.delete();
    } catch (e) {
      // print(e);
    }
  }

  Future<void> deleteUserChat(String userId) async {
    final userDocRef = _firebaseFirestore.collection('users').doc(userId);

    final userChatsCollection = userDocRef.collection('chats');

    // Fetch all documents in the subcollection
    final snapshot = await userChatsCollection.get();

    // Iterate through each document and delete
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }

    await userDocRef.delete();
  }
}
