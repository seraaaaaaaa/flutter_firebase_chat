import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/components/prompt_dialog.dart';
import 'package:flutter_firebase/screen/auth/widgets/screen_title.dart';
import 'package:flutter_firebase/screen/auth/widgets/input.dart';
import 'package:flutter_firebase/screen/auth/change_password.dart';
import 'package:flutter_firebase/service/user_service.dart';
import 'package:flutter_firebase/service/utils.dart';
import 'package:flutter_firebase/themes/constant.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? _user;
  String _name = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _userService = UserService();

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();

    _getUser();
  }

  Future _getUser() async {
    User? user = await _userService.getUser();
    setState(() {
      _user = user;
    });
  }

  Future _uploadFile(XFile? imgFile) async {
    if (imgFile != null) {
      showProgressDialog(context);

      User? user = await _userService.uploadProfilePhoto(imgFile, _user!.uid);
      if (user != null) {
        setState(() {
          _user = user;
        });
      } else {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Failed to remove profile picture'),
        ));
      }

      if (!mounted) return;
      Navigator.pop(context); //pop progress dialog
    }
  }

  Future _removeProfilePhoto(String imageUrl) async {
    showProgressDialog(context);

    User? user = await _userService.removeProfilePhoto(imageUrl);
    if (user != null) {
      setState(() {
        _user = user;
      });
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Failed to remove profile picture'),
      ));
    }

    if (!mounted) return;
    Navigator.pop(context); //pop progress dialog
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhiteColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(kPadding),
            child: _user == null
                ? const ScreenTitle(
                    icon: Icons.person_outlined,
                    title: 'User Not Found',
                    desc: '',
                  )
                : Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const ScreenTitle(),
                        Container(
                          margin: const EdgeInsets.only(top: kPadding),
                          child: CircleAvatar(
                            radius: 45,
                            backgroundColor: kGreyColor.shade200,
                            backgroundImage: _user!.photoURL == null
                                ? null
                                : NetworkImage(_user!.photoURL!),
                            child: InkWell(
                              onTap: () async {
                                _editProfilePicture();
                              },
                              child: _user!.photoURL == null
                                  ? const Icon(
                                      Icons.person,
                                      size: 35,
                                      color: kSecondaryColor,
                                    )
                                  : Container(),
                            ),
                          ),
                        ),
                        Input(
                          labelText: 'Name',
                          initialValue: _user!.displayName ?? '',
                          onChanged: (val) async {
                            setState(() {
                              _name = val;
                            });
                          },
                        ),
                        Input(
                          labelText: 'Email',
                          initialValue: _user!.email ?? '',
                          readonly: true,
                        ),
                        Input(
                          labelText: 'Password',
                          initialValue: '123456',
                          readonly: true,
                          obscureText: true,
                          inputType: 'password',
                          suffixIcon: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ChangePasswordScreen(
                                          user: _user!,
                                        )));
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(kPadding),
                                child: Text(
                                  'Change',
                                  style: TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.w500),
                                ),
                              )),
                        ),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(kPadding),
                          child: ElevatedButton(
                            onPressed: () async {
                              FocusScope.of(context).unfocus();

                              if (_formKey.currentState!.validate() &&
                                  _name.isNotEmpty) {
                                showProgressDialog(context);

                                await _userService.updateName(_name);

                                if (!context.mounted) return;
                                Navigator.pop(context); //pop progress dialog
                                Navigator.pop(context); //back to chat page
                              }
                            },
                            child: const Text('Save'),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(kPadding),
                          width: double.infinity,
                          child: TextButton(
                            style: TextButton.styleFrom(
                                foregroundColor: kRedColor),
                            onPressed: () async {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return PromptDialog(
                                      icon: Icons.delete_forever,
                                      title: "Delete Account",
                                      content:
                                          "Are you sure you want to delete your account? This action cannot be undone.",
                                      onConfirm: () async {
                                        Navigator.pop(context);
                                        Navigator.pop(context);

                                        await _userService
                                            .deleteAccount(_user!.uid);
                                      },
                                      onCancel: () {
                                        Navigator.pop(context);
                                      },
                                    );
                                  });
                            },
                            child: const Text('Delete Account'),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void _editProfilePicture() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: Icon(
                        Icons.photo_camera,
                        color: kBlackColor.withOpacity(0.7),
                      ),
                      title: const Text(
                        'Take a Photo',
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                        final XFile? photo =
                            await _picker.pickImage(source: ImageSource.camera);
                        _uploadFile(photo);
                      }),
                  ListTile(
                      leading: Icon(
                        Icons.collections,
                        color: kBlackColor.withOpacity(0.7),
                      ),
                      title: const Text(
                        'Choose from Gallery',
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                        final XFile? photo = await _picker.pickImage(
                            source: ImageSource.gallery);
                        _uploadFile(photo);
                      }),
                  _user!.photoURL != null
                      ? ListTile(
                          leading: Icon(
                            Icons.delete,
                            color: kBlackColor.withOpacity(0.7),
                          ),
                          title: const Text(
                            'Remove Photo',
                          ),
                          onTap: () async {
                            Navigator.pop(context);
                            _removeProfilePhoto(_user!.photoURL!);
                          },
                        )
                      : Container(),
                ],
              ),
            ),
          );
        });
  }
}
