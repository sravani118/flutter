import 'package:firebase_auth/firebase_auth.dart';

/// Authentication service for handling user sign-up, sign-in, and sign-out
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sign up with email and password
  Future<UserCredential?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('An account already exists for that email.');
      }
      throw Exception(e.message ?? 'Sign up failed');
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  /// Sign in with email and password
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided.');
      }
      throw Exception(e.message ?? 'Sign in failed');
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Stream of authentication state changes
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}
