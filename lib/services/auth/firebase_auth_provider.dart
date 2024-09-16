import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/services/auth/auth_exceptions.dart';
import 'package:myapp/services/auth/auth_provider.dart';
import 'package:myapp/services/auth/auth_user.dart';

import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

class FirebaseAuthProvider implements AuthProvider {
    @override
  // TODO: implement initialise
  Future<void> initialize() async{
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }
  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return AuthUser.fromFirebase(user);
      } else {
        throw UserNotFoundAuthException();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException();
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException();
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException();
      } else {
        throw GenericAuthException();
      }
    } catch (_) {
      throw GenericAuthException();
    }
  }
  // TODO: implement createUser

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return AuthUser.fromFirebase(user);
    } else {
      return null;
    }
  }

  @override
  // TODO: implement logIn
  Future<AuthUser> logIn({
    required String email, 
    required String password,
    })async{
    // TODO: implement logIn
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        return AuthUser.fromFirebase(user);
      } else {
        throw UserNotFoundAuthException();
      }
    } on FirebaseAuthException catch (e){
      if (e.code == 'user-not-found'){
        throw UserNotFoundAuthException();
      }else if (e.code == 'wrong-password'){
        throw WrongPasswordAuthException();
      }else{
        throw GenericAuthException();
      }
    }catch (_){
      throw GenericAuthException();
    }
  }

  @override
  Future<void> logOut() async{
    // TODO: implement logOut
    final user = FirebaseAuth.instance.currentUser;
    if (user != null){
      await FirebaseAuth.instance.signOut();
    }else{
      throw UserNotLoggedInAuthException();
    }
  }

  @override
  Future<void> sendEmailVerification() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.sendEmailVerification();
    } else {
      throw UserNotLoggedInAuthException();
    }
  }
  
}
