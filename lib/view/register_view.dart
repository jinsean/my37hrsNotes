import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:myapp/constants/routes.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/services/auth/auth_exceptions.dart';
// import 'package:myapp/services/auth/auth_service.dart';
import 'package:myapp/services/auth/bloc/auth_bloc.dart';
import 'package:myapp/services/auth/bloc/auth_event.dart';
import 'package:myapp/services/auth/bloc/auth_state.dart';
import 'package:myapp/utilities/dialogs/error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        //First handle exception
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
              context,
              'Weak Password',
            );
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
              context,
              'Email is already in use',
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              'Failed to register',
            );
          }else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              context,
              'Invalid Email',
            );
          }
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Register'),
          ),
          body: FutureBuilder(
              //The future function will run first before widget is build
              future: Firebase.initializeApp(
                options: DefaultFirebaseOptions.currentPlatform,
              ),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            //After declare in init state, declare here to store value in the init state
                            controller: _email,
                            decoration: const InputDecoration(
                                hintText: 'Enter your email'),
                            enableSuggestions: false,
                            autocorrect: false,
                            autofocus: true,
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
                          Center(
                            child: Column(
                              children: [
                                TextButton(
                                    //Remember to use async cuz ...
                                    onPressed: () async {
                                      //update the page state varible with the new value
                                      final email = _email.text;
                                      final password = _password.text;
                                      context.read<AuthBloc>().add(
                                            AuthEventRegister(
                                              email,
                                              password,
                                            ),
                                          );
                                      //Create a user with email and password, use await cuz it is async or "future"
                                      // try {
                                      //   await AuthService.firebase().createUser(
                                      //     email: email,
                                      //     password: password,
                                      //   );
                                      //   //Send email verification
                                      //   AuthService.firebase().sendEmailVerification();
                                      //   Navigator.of(context)
                                      //       .pushNamed(verifyEmailRoute);
                                      // } on WeakPasswordAuthException {
                                      //   await showErrorDialog(
                                      //     context,
                                      //     'Weak Password',
                                      //   );
                                      // } on EmailAlreadyInUseAuthException {
                                      //   await showErrorDialog(
                                      //     context,
                                      //     'Email already in use',
                                      //   );
                                      // } on GenericAuthException {
                                      //   await showErrorDialog(
                                      //     context,
                                      //     'Failed to register',
                                      //   );
                                      // }
                                    },
                                    child: const Text('Register')),
                                TextButton(
                                    onPressed: () {
                                      // Navigator.of(context).pushNamedAndRemoveUntil(
                                      //     loginRoute, (route) => false);
                                      context.read<AuthBloc>().add(
                                            const AuthEventLogOut(),
                                          );
                                    },
                                    child: const Text('Already Registered? Login')),
                              ],
                            ),
                          )
                        ], //Children
                      ),
                    );
                  default:
                    return const Text('Loading...');
                }
              })),
    );
  } //Widget build
}
