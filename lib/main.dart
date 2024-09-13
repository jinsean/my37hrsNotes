import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/view/login_view.dart';
import 'package:myapp/view/register_view.dart';
import 'package:myapp/view/verify_email_view.dart';

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
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        //The future function will run first before widget is build
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              //Change user verified
              final user = FirebaseAuth.instance.currentUser;
              if (user != null){
                if (user.emailVerified){
                  print('Email verified');
                } else {
                  return const VerifyEmailView();
                }
              } else {
                return const LoginView();
              }
              return const Text('Done');
            default:
              return const CircularProgressIndicator();
          }
        });
  }
}

