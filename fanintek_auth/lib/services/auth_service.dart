import 'package:fanintek_auth/services/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// LOGIN METHOD
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      if (!await isInternet()) {
        throw 'TIdak ada akses internet';
      }
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email') {
        throw 'Email tidak valid';
      } else if (e.code == 'user-disabled') {
        throw 'Pengguna dinonaktifkan';
      } else if (e.code == 'user-not-found') {
        throw 'Akun pengguna tidak ditemukan';
      } else if (e.code == 'wrong-password') {
        throw 'Password yang dimasukkan salah';
      }
    } catch (e) {
      rethrow;
    }
  }

  /// REGISTER METHOD
  Future<void> signUpWithEmailAndPassword({
    required String nama,
    required String email,
    required String password,
  }) async {
    try {
      if (!await isInternet()) {
        throw 'TIdak ada akses internet';
      }
      final user = await _auth.createUserWithEmailAndPassword(email: email, password: password).then((value) {
        final user = value.user;
        user!.updateDisplayName(nama);
      });
      debugPrint(user.toString());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw 'Email sudah pernah digunakan';
      } else if (e.code == 'invalid-email') {
        throw 'Email tidak valid';
      } else if (e.code == 'operation-not-allowed') {
        throw 'Akun email dan passwod dinonaktifkan';
      } else if (e.code == 'weak-password') {
        throw 'Password lemah';
      }
    } catch (e) {
      rethrow;
    }
  }

  /// SEND EMAIL VERIFICATION METHOD
  Future<void> sendVerificationEmail() async {
    try {
      if (!await isInternet()) {
        throw 'TIdak ada akses internet';
      }
      await _auth.currentUser!.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        throw 'Mohon tunggu beberapa saat lagi';
      }
    } catch (e) {
      rethrow;
    }
  }

  /// SEND PASSWORD RESET EMAIL METHOD
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      if (!await isInternet()) {
        throw 'TIdak ada akses internet';
      }
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'auth/invalid-email') {
        throw 'Email tidak valid';
      } else if (e.code == 'auth/user-not-found') {
        throw 'Email tidak ditemukan';
      }
    } catch (e) {
      rethrow;
    }
  }

  /// LOGOUT METHOD
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
