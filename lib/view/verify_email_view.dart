import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:myapp/constants/routes.dart';
// import 'package:myapp/services/auth/auth_service.dart';
import 'package:myapp/services/auth/bloc/auth_bloc.dart';
import 'package:myapp/services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Verify Email'),
        ),
        body: Column(
          children: [
            const Text(
                "We've sent you an email verification, please check your inbox"),
            const Text(
                'If you haven\'t received a verification email, press the button below to send another'),
            TextButton(
              onPressed: () {
                // AuthService.firebase().sendEmailVerification();
                // await AuthService.firebase().sendEmailVerification();
                context.read<AuthBloc>().add(
                      const AuthEventSendEmailVerification(),
                    );
              },
              child: const Text('Send Verification Email'),
            ),
            TextButton(
              onPressed: () async {
                context.read<AuthBloc>().add(
                      const AuthEventLogOut(),
                    );
                // await AuthService.firebase().logOut();
                // Navigator.of(context).pushNamedAndRemoveUntil(
                //   registerRoute,
                //   (route) => false,
                // );
              },
              child: const Text('Restart'),
            )
          ],
        ));
  }
}
