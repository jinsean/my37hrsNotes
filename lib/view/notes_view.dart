import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import 'package:myapp/enums/menu_action.dart';
import 'package:myapp/main.dart';
import 'package:myapp/services/auth/auth_service.dart';


class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  devtools.log(shouldLogout.toString());
                  if (shouldLogout) {
                    AuthService.firebase().logOut();
                     Navigator.of(context).pushNamedAndRemoveUntil(
                        '/login/', (route) => false);
                  }
              }
            }, //Initially null and ready to be set
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                    value: MenuAction.logout, child: Text('Logout'))
              ];
            },
          )
        ],
      ),
      body: const Text('Hello World'),
    );
  }
}