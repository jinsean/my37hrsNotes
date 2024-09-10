import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  //late mean currently no value but will have value later
  //Initially in Stateless than change to statefull
  //If statefull widget is use we need to create a init state and dispose state
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  //Create the state but need to dispose it as well
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: FutureBuilder(
            //The future function will run first before widget is build
            future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return Column(
                    children: [
                      TextField(
                        //After declare in init state, declare here to store value in the init state
                        controller: _email,
                        decoration:
                            const InputDecoration(hintText: 'Enter your email'),
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextField(
                        controller: _password,
                        decoration:
                            const InputDecoration(hintText: 'Enter your password'),
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                      ),
                      TextButton(
                          //Remember to use async cuz ...
                          onPressed: () async {
                            //update the page state varible with the new value
                            final email = _email.text;
                            final password = _password.text;
                            try {
                              //Create a user with email and password, use await cuz it is async or "future"
                              final userCredential = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                email: email,
                                password: password,
                              );
                              print(userCredential);
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                print('No user found for that email.');
                              } else if (e.code == 'wrong-password') {
                                print('Wrong password provided for that user.');
                              } else {
                                
                              } 
                            }
                          },
                          child: Text('Login'))
                    ], //Children
                  );
                default:
                  return const Text('Loading...');
              }
            }));
  } //Widget build
}
