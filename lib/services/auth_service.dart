import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  AuthService() {
    _firebaseAuth.authStateChanges().listen((user) {
      notifyListeners(); // Notifica a UI sobre alterações de estado
    });
  }
  Stream<User?> observeChanges() {
    return _firebaseAuth.authStateChanges();
  }

  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential credential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      notifyListeners();
      print('User created: ${credential.user!.email}');
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
      print('User signed in: ${credential.user!.email}');
      notifyListeners();

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
    notifyListeners();
    print('User signed out');
    return await _firebaseAuth.signOut();
  }

  String? getCurrentUserEmail() {
    return _firebaseAuth.currentUser!.email;
  }

  Future<void> deleteAccount() async {
    try {
      await _firebaseAuth.currentUser?.delete();
      notifyListeners();
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
