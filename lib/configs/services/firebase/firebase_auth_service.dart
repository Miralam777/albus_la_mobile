import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Private constructor - no instances allowed
  AuthService._();

  // Static Firebase Auth instance
  static final FirebaseAuth _auth = FirebaseAuth.instance;

// TODO:
  // Get idToken (refreshes automatically if expired)
  // UserCredential userCredential = await AuthService().
  /// Sign in with email and password
  /// Returns [UserCredential] on success
  /// Throws [FirebaseAuthException] on failure
  static Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    }
  }

  /// Handle Firebase Auth exceptions
  static Exception _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return Exception('No user found with this email.');
      case 'wrong-password':
        return Exception('Wrong password.');
      case 'invalid-email':
        return Exception('Invalid email address.');
      case 'user-disabled':
        return Exception('This account has been disabled.');
      case 'too-many-requests':
        return Exception('Too many attempts. Try again later.');
      default:
        return Exception('Login failed. Please try again.');
    }
  }

  static Future<String?> getIdToken() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return await user.getIdToken();
  }

  // Get idToken (force refresh)
  /*  static Future<String?> getIdTokenForced() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return await user.getIdToken(true);
  } */

  // Get user ID
/*   static String? getUserId() {
    return _auth.currentUser?.uid;
  } */

  // Check if user is logged in
/*   static bool isLoggedIn() {
    return _auth.currentUser != null;
  } */

  // Get current user
/*   static User? getCurrentUser() {
    return _auth.currentUser;
  } */

  // Get user email
/*   static String? getUserEmail() {
    return _auth.currentUser?.email;
  } */

  // Logout
  static Future<void> logout() async {
    await _auth.signOut();
  }

  // Listen to auth state changes
/*   static Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  } */
}
