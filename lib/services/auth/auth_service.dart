import 'package:myapp/services/auth/auth_provider.dart';
import 'package:myapp/services/auth/auth_user.dart';
import 'package:myapp/services/auth/firebase_auth_provider.dart';

class AuthService implements AuthProvider {
  final AuthProvider provider;
  const AuthService(this.provider);

  factory AuthService.firebase() => AuthService(FirebaseAuthProvider());

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) =>
      // TODO: implement createUser
      provider.createUser(
        email: email,
        password: password,
      );

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => provider.currentUser;

  @override
  // TODO: implement logIn
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) =>
      provider.logIn(
        email: email,
        password: password,
      );

  @override
  // TODO: implement logOut
  Future<void> logOut() => provider.logOut();

  @override
  // TODO: implement sendEmailVerification
  Future<void> sendEmailVerification() => provider.sendEmailVerification();
  
  @override
  // TODO: implement initialize
  Future<void> initialize() => provider.initialize();
  
}
