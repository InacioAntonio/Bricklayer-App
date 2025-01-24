import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      return credential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  String? getCurrentUserEmail() {
    return _firebaseAuth.currentUser!.email;
  }

  Future<void> deleteAccount() async {
    try {
      await _firebaseAuth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> updateAccountEmail(String newEmail) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user is currently signed in.');
      }
      await user.updateEmail(newEmail);
    } on FirebaseAuthException catch (e) {
      throw Exception('Error updating email: ${e.message}');
    }
  }

  Future<void> updateAccountPassword(String newPassword) async {
    try {
      await _firebaseAuth.currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  Future<void> signInAnonymously() async {
    try {
      await _firebaseAuth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }
}
