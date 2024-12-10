# Firebase AI Chat App

This is a real-time chat application built with Flutter, integrated with Firebase services and ChatGPT API. The app provides a seamless chat experience with AI-powered responses, user authentication, and cloud-based data storage.

## Features

- Firebase Authentication: Secure and simple user authentication using Firebase.
- Cloud Firestore: Real-time message synchronization with efficient data storage and retrieval.
- Firebase Storage: Allows users to upload profile picture.
- ChatGPT API Integration: AI-powered chat functionality for intelligent and dynamic responses.

## Preview

![](/preview/screenshots.png)

## Getting Started

### Setup & Installation

1. Install dependencies:  
   ```sh
   flutter pub get
   ```
2. Set up Firebase:  
- Create a Firebase project in the [Firebase Console](https://console.firebase.google.com/) and enable the following services in your Firebase project:  
   - **Authentication**  
   - **Firestore Database**  
   - **Storage**
- Configure Firebase with FlutterFire CLI:  
   ```sh
   flutterfire configure
   ```
3. Obtain an API key from [OpenAI](https://openai.com/api/) and enter it in `constant.dart`.
   ```js
   const apiKey = 'ENTER YOUR API';
   ```
4. Run the app:  
   ```sh
   flutter run
    ```

## License

This project is licensed under the MIT License. See the `LICENSE.md` file for details.
