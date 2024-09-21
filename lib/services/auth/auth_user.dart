import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable //This class is immutable that means only final and constant are allowed
class AuthUser {
  final String? email;
  final bool isEmailVerified;
  final String id;

  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailVerified,
  });

  factory AuthUser.fromFirebase(User user) => AuthUser(
    id: user.uid,
    email: user.email!, //Assert that email is not null, email no longer required and it became optional
    isEmailVerified: user.emailVerified,
  );
}
