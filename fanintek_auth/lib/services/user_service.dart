import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// GET USER DATA FROM ID TOKEN LOGIN
  Stream<User?> getIdTokenChanges() => _auth.idTokenChanges();

  bool getVerifiedEmail() => _auth.currentUser!.emailVerified;
}
