import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fanintek_auth/services/user_service.dart';
import 'package:fanintek_auth/utils/finite_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = UserService();

  MyState _state = MyState.initial;
  MyState get lstate => _state;

  changeState(MyState state) {
    _state = state;
    notifyListeners();
  }

  bool _isVerified = false;
  bool get isVerified => _isVerified;

  changeIsVerified(bool state) {
    _isVerified = state;
    notifyListeners();
  }

  Stream<User?> getIdTokenChanges() => _userService.getIdTokenChanges();

  Stream<bool> getVerifiedEmail() => Stream.periodic(
        const Duration(seconds: 2),
        (int count) {
          return _userService.getVerifiedEmail();
        },
      );
}
