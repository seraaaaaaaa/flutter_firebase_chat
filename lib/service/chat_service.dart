import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_firebase/model/message_model.dart';
import 'package:flutter_firebase/themes/constant.dart';
import 'package:http/http.dart' as http;

class ChatService {
  final FirebaseFirestore _firebase = FirebaseFirestore.instance;

  final String apiUrl = 'https://api.openai.com/v1/chat/completions';

  /// Sends a chat message and handles bot reply.
  Future<String> sendChat({
    required String userId,
    required String messageContent,
  }) async {
    try {
      // Reference to user's chat collection
      final CollectionReference msgCollection =
          _firebase.collection('users').doc(userId).collection('chats');

      // Create the user's message
      final message = Message(
        userid: userId,
        message: messageContent,
        createdAt: DateTime.now(),
      );

      // Add the user's message to Firestore
      await msgCollection.doc().set(message.toJson());

      // Get the reply from the ChatGPT service
      String reply = await generateResponseMessage(messageContent);

      // Create the bot's reply message
      final replyMessage = Message(
        userid: '0', //  '0' is the bot's ID
        message: reply,
        createdAt: DateTime.now(),
      );

      // Add the bot's reply to Firestore
      await msgCollection.doc().set(replyMessage.toJson());

      return "";
    } on FirebaseException catch (e) {
      return e.message ?? e.toString();
    }
  }

  Future<String> generateResponseMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'gpt-3.5-turbo', // Change to 'gpt-4' if you have access.
          'messages': [
            {'role': 'system', 'content': 'You are a helpful assistant.'},
            {'role': 'user', 'content': message},
          ],
        }),
      );
      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data['choices'][0]['message']['content'] ?? 'No response';
      } else {
        return data['error']['message'] ?? 'Failed to get a response';
      }
    } catch (e) {
      //print('Exception: $e');
      return 'Bot is sleeping. Please try again later.';
    }
  }

  Future<String> deleteMessage(String userId, String messageId) async {
    try {
      await _firebase
          .collection('users')
          .doc(userId)
          .collection('chats')
          .doc(messageId)
          .delete();

      return "";
    } on FirebaseException catch (e) {
      return e.message ?? e.toString();
    }
  }
}
