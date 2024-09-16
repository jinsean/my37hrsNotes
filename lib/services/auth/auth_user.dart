import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/material.dart';

@immutable //This class is immutable that means only final and constant are allowed
class AuthUser {
  final bool isEmailVerified;
  const AuthUser(this.isEmailVerified);

  factory AuthUser.fromFirebase(User user) => AuthUser(user.emailVerified);

}
