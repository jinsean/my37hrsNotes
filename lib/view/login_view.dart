import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/constants/routes.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/services/auth/auth_exceptions.dart';
import 'package:myapp/services/auth/auth_service.dart';
import 'package:myapp/utilities/dialogs/error_dialog.dart';

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
                        decoration: const InputDecoration(
                            hintText: 'Enter your password'),
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
                              await AuthService.firebase().logIn(
                                email: email,
                                password: password,
                              );
                              final user = AuthService.firebase().currentUser;
                              if (user?.isEmailVerified ?? false) {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  notesRoute,
                                  (route) => false,
                                );
                              } else {
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  verifyEmailRoute,
                                  (route) => false,
                                );
                              }

                            } on UserNotFoundAuthException {
                              await showErrorDialog(
                                context,
                                'User not Found',
                              );
                            } on WrongPasswordAuthException {
                              await showErrorDialog(
                                context,
                                'Wrong Credential;',
                              );
                            } on GenericAuthException {
                              await showErrorDialog(
                                context,
                                'Authentication Error',
                              );
                            }
                          },
                          child: const Text('Login')),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                registerRoute, (route) => false);
                          },
                          child: const Text('Not Registered? Register'))
                    ], //Children
                  );
                default:
                  return const Text('Loading...');
              }
            }));
  } //Widget build
}


