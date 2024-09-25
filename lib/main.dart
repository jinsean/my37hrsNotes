// import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/constants/routes.dart';
import 'package:myapp/helphers/loading/laoding_screen.dart';
// import 'package:myapp/services/auth/auth_service.dart';
import 'package:myapp/services/auth/bloc/auth_bloc.dart';
import 'package:myapp/services/auth/bloc/auth_event.dart';
import 'package:myapp/services/auth/bloc/auth_state.dart';
import 'package:myapp/services/auth/firebase_auth_provider.dart';
import 'package:myapp/view/login_view.dart';
import 'package:myapp/view/notes/create_update_note_view.dart';
import 'package:myapp/view/notes/notes_view.dart';
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
      home: BlocProvider<AuthBloc>(
        create: (context) => AuthBloc(FirebaseAuthProvider()),
        child: const HomePage(),
      ),
      routes: {
        // loginRoute: (context) => const LoginView(),
        // registerRoute: (context) => const RegisterView(),
        // notesRoute: (context) => const NotesView(),
        // verifyEmailRoute: (context) => const VerifyEmailView(),
        createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.isLoading) {
          LaodingScreen().show(
              context: context,
              text: state.loadingText ?? 'Please wait while we are loading');
        } else {
          LaodingScreen().hide();
        }
      },
      builder: (context, state) {
        if (state is AuthStateLoggedIn) {
          return const NotesView();
        } else if (state is AuthStateNeedsVerification) {
          return const VerifyEmailView();
        } else if (state is AuthStateLoggedOut) {
          return const LoginView();
        } else if (state is AuthStateRegistering) {
          return const RegisterView();
        } else {
          return const Scaffold(
            body: CircularProgressIndicator(),
          );
        }
      },
    );
    // return FutureBuilder(
    //     //The future function will run first before widget is build
    //     future: AuthService.firebase().initialize(),
    //     builder: (context, snapshot) {
    //       switch (snapshot.connectionState) {
    //         case ConnectionState.done:
    //           //Change user verified
    //           final user = AuthService.firebase().currentUser;
    //           if (user != null) {
    //             if (user.isEmailVerified) {
    //               return const NotesView();
    //             } else {
    //               return const VerifyEmailView();
    //             }
    //           } else {
    //             return const LoginView();
    //           }
    //         default:
    //           return const CircularProgressIndicator();
    //       }
    //     });
  }
}

// class Homepage extends StatefulWidget {
//   const Homepage({super.key});

//   @override
//   State<Homepage> createState() => _HomepageState();
// }

// class _HomepageState extends State<Homepage> {
//   late final TextEditingController _controller;

//   @override
//   void initState() {
//     _controller = TextEditingController();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => CounterBloc(),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Counter Testing'),
//         ),
//         body: BlocConsumer<CounterBloc, CounterState>(
//           listener: (context, state) {
//             _controller.clear();
//           },
//           builder: (context, state) {
//             final invalidValue =
//                 (state is CounterStateInvalidNumber) ? state.invalidValue : '';
//             return Column(children: [
//               Text("Curret value: ${state.value}"),
//               Visibility(
//                 visible: state is CounterStateInvalidNumber,
//                 child: Text(
//                   "Invalid value: $invalidValue",
//                 ),
//               ),
//               TextField(
//                 controller: _controller,
//                 decoration: const InputDecoration(
//                   hintText: 'Enter a number',
//                 ),
//                 keyboardType: TextInputType.number,
//               ),
//               Row(
//                 children: [
//                   TextButton(
//                     onPressed: () {
//                       context
//                           .read<CounterBloc>()
//                           .add(CounterDecrementEvent(_controller.text));
//                     },
//                     child: const Text('-'),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       context
//                           .read<CounterBloc>()
//                           .add(CounterIncrementEvent(_controller.text));
//                     },
//                     child: const Text('+'),
//                   )
//                 ],
//               )
//             ]);
//           },
//         ),
//       ),
//     );
//   }
// }

// Future<bool> showLogOutDialog(BuildContext context) {
//   return showDialog<bool>(
//     context: context,
//     builder: (context) {
//       return AlertDialog(
//         title: const Text('Sign Out'),
//         content: const Text('Are you sure you want to sign out?'),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(false);
//             },
//             child: const Text('Cancel'),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop(true);
//             },
//             child: const Text('Log Out'),
//           ),
//         ],
//       );
//     },
//   ).then((value) => value ?? false); //Cause user may press outside the dialog
// }

// @immutable
// abstract class CounterState {
//   final int value;
//   const CounterState(this.value);
// }

// class CounterIncrement extends CounterState {
//   const CounterIncrement(int value) : super(value);
// }

// class CounterDecrement extends CounterState {
//   const CounterDecrement(int value) : super(value);
// }

// class CounterStateValid extends CounterState {
//   const CounterStateValid(int value) : super(value);
// }

// class CounterStateInvalidNumber extends CounterState {
//   final String invalidValue;
//   const CounterStateInvalidNumber({
//     required this.invalidValue,
//     required int previousValue,
//   }) : super(previousValue);
// }

// @immutable
// abstract class CounterEvent {
//   final String value;
//   const CounterEvent(this.value);
// }

// //This are going to be packed and sent to the reducer or UI
// class CounterIncrementEvent extends CounterEvent {
//   const CounterIncrementEvent(String value) : super(value);
// }

// class CounterDecrementEvent extends CounterEvent {
//   const CounterDecrementEvent(String value) : super(value);
// }

// class CounterBloc extends Bloc<CounterEvent, CounterState> {
//   CounterBloc() : super(const CounterStateValid(0)) {
//     on<CounterIncrementEvent>((event, emit) {
//       final integer = int.tryParse(event.value);
//       if (integer == null) {
//         emit(CounterStateInvalidNumber(
//           invalidValue: event.value,
//           previousValue: state.value,
//         ));
//       } else {
//         emit(CounterStateValid(state.value + integer));
//       }
//     });
//     on<CounterDecrementEvent>((event, emit) {
//       final integer = int.tryParse(event.value);
//       if (integer == null) {
//         emit(CounterStateInvalidNumber(
//           invalidValue: event.value,
//           previousValue: state.value,
//         ));
//       } else {
//         emit(CounterStateValid(state.value - integer));
//       }
//     });
//   }
// }


