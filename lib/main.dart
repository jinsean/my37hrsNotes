import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/firebase_options.dart';

void main() async {
  //Firebase need initialization before other calls to Firebase
  //Flutter need to enable widget binding before Firebase.initializeApp
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const HomePage(),
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
        ),
        body: FutureBuilder(
            //The future function will run first before widget is build
            future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  //Change user verified
                  final user = FirebaseAuth.instance.currentUser;
                  if (user?.emailVerified ?? false) {
                    //If the email verify take the output (user.emailVerified) else return false
                    print('You are a verified user');
                  } else {
                    print('You are not a verified user, Please verify your email');
                  }
                  return const Text('Firebase Initialized');
                default:
                  return const Text('Loading...');
              }
            }));
  }
}
