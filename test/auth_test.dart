//import 'package:test/test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/services/auth/auth_exceptions.dart';
import 'package:myapp/services/auth/auth_provider.dart';
import 'package:myapp/services/auth/auth_user.dart';

void main() {
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1332780094.
  group('Mock Authentication',(){
    final provider = MockAuthProvider();
    test('Should not be initialized to begin with', () {
      expect(provider.isInitialized, false);
      });

    test('Cannot log out if not initialized', () {
      expect(
        provider.logOut(),
        throwsA(const TypeMatcher<NotInitializedException>()),
      );
      });

      test('Should be able to be initialized', () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      });

      test('User should be null after initialization', () {
        expect(provider.currentUser, null);
      });

      test('Should be able to initialize in less than 2 seconds', () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      });

      test('Create user should delegate to login function', () async {
        final badEmalUser = provider.createUser(
          email: 'foo',
          password: 'bar',
        );
        expect(badEmalUser,
          throwsA(const TypeMatcher<UserNotFoundAuthException>()),
        );

        final badPasswordUser = provider.createUser(
          email: 'foo',
          password: 'foobar',
        );
        expect(badPasswordUser,
          throwsA(const TypeMatcher<WrongPasswordAuthException>()),
        );

        final user = await provider.createUser(
          email: 'foo',
          password: 'bar',
        );
        expect(provider.currentUser, user);
        expect(user.isEmailVerified, false);
      });


      test('Logged in user should be able to get verified', () {
        provider.sendEmailVerification();
        final user = provider.currentUser;
        expect(user, isNotNull);
        expect(user!.isEmailVerified, true);
      });

      test('Should be able to log out and log in again', () async {
        await provider.logOut();
        await provider.logIn(
          email: 'email',
          password: 'password',
        );
      });
    });
}

class NotInitializedException implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user; //_means private function
  var _isInitialized = false;   //Declare initial state for _isInitialized
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async{
    // TODO: implement createUser
    if (!isInitialized) throw NotInitializedException();
      await Future.delayed(const Duration(seconds: 1));
      return logIn(
        email: email,
        password: password,
      );
    }

  @override
  // TODO: implement currentUser
  AuthUser? get currentUser => _user;


  @override
  Future<void> initialize() async{
    // TODO: implement initialize
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({required String email, required String password,}) {
    // TODO: implement logIn
    if (!isInitialized) throw NotInitializedException();
    if (email == 'william.com') throw UserNotFoundAuthException();
    if (password == 'foobar') throw WrongPasswordAuthException();
    const user = AuthUser(isEmailVerified: false);
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async{
    // TODO: implement logOut
    if (!isInitialized) throw NotInitializedException();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async{
    // TODO: implement sendEmailVerification
    if (!isInitialized) throw NotInitializedException();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(isEmailVerified: true);
    _user = newUser;

  }
}
