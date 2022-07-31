import 'package:fanintek_auth/services/auth_service.dart';
import 'package:fanintek_auth/utils/finite_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  /// LOGIN STATE
  MyState _loginState = MyState.initial;
  MyState get loginState => _loginState;

  setLoginState(MyState loginState) {
    _loginState = loginState;
    notifyListeners();
  }

  /// REGISTER STATE
  MyState _registerState = MyState.initial;
  MyState get registerState => _registerState;

  setRegisterState(MyState registerState) {
    _registerState = registerState;
    notifyListeners();
  }

  /// VERIFICATION EMAIL STATE
  MyState _verificationEmailState = MyState.initial;
  MyState get verificationEmailState => _verificationEmailState;

  setVerificationEmailState(MyState verificationEmailState) {
    _verificationEmailState = verificationEmailState;
    notifyListeners();
  }

  /// PASSWORD RESET STATE
  MyState _passwordResetState = MyState.initial;
  MyState get passwordResetState => _passwordResetState;

  setResetPasswordState(MyState passwordResetState) {
    _passwordResetState = passwordResetState;
    notifyListeners();
  }

  /// LOGOUT STATE
  MyState _logoutState = MyState.initial;
  MyState get logoutState => _logoutState;

  setLogoutState(MyState logoutState) {
    _logoutState = logoutState;
    notifyListeners();
  }

  /// ERROR MESSAGE
  String errorMessage = '';
  clearErrorMessage() {
    errorMessage = '';
  }

  /// LOGIN METHOD
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      setLoginState(MyState.loading);

      await _authService.signInWithEmailAndPassword(email: email, password: password);

      setLoginState(MyState.loaded);
    } catch (e) {
      if (e is FirebaseAuthException) {
        errorMessage = e.toString();
      } else {
        errorMessage = e.toString();
      }
      setLoginState(MyState.failed);
      clearErrorMessage();
    }
  }

  /// REGISTER METHOD
  Future<void> signUpWithEmailAndPassword({
    required String nama,
    required String email,
    required String password,
  }) async {
    try {
      setRegisterState(MyState.loading);

      await _authService.signUpWithEmailAndPassword(nama: nama, email: email, password: password);
      await _authService.sendVerificationEmail();

      setRegisterState(MyState.loaded);
    } catch (e) {
      if (e is FirebaseAuthException) {
        errorMessage = e.toString();
      } else {
        errorMessage = e.toString();
      }
      setRegisterState(MyState.failed);
      clearErrorMessage();
    }
  }

  /// SEND EMAIL VERIFICATION METHOD
  Future<void> sendVerificationEmail() async {
    try {
      setVerificationEmailState(MyState.loading);
      await _authService.sendVerificationEmail();
      setVerificationEmailState(MyState.loaded);
    } catch (e) {
      errorMessage = e.toString();
      setVerificationEmailState(MyState.failed);
    }
  }

  /// SEND PASSWORD RESET EMAIL METHOD
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      setResetPasswordState(MyState.loading);
      await _authService.sendPasswordResetEmail(email: email);
      setResetPasswordState(MyState.loaded);
    } catch (e) {
      if (e is FirebaseAuthException) {
        errorMessage = e.toString();
      } else {
        errorMessage = e.toString();
      }
      setResetPasswordState(MyState.failed);
      clearErrorMessage();
    }
  }

  /// LOGOUT METHOD
  Future<void> signOut() async {
    try {
      setLogoutState(MyState.loading);
      await _authService.signOut();
      setLogoutState(MyState.loaded);
    } catch (e) {
      errorMessage = e.toString();
      setLogoutState(MyState.failed);
      clearErrorMessage();
    }
  }
}
