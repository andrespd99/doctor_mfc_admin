import 'package:doctor_mfc_admin/models/auth_exception.dart';
import 'package:doctor_mfc_admin/models/role.dart';
import 'package:doctor_mfc_admin/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MFCAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? get user => FirebaseAuth.instance.currentUser;

  Stream<User?> userStream() => _auth.authStateChanges().asBroadcastStream();

  /// Future to sign user in the application. Returns a [String] if it finish with an error
  /// with the error message.
  ///
  /// If the user exists, his role will be evaluated to check if he has
  /// access to the application.
  ///
  Future<String?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      // First, get user document from database. If no document is found,
      // an error will be thrown back. If a document is found, it's role
      // will be checked to evaluate if he has access or not.
      await Database().getUserDocByEmail(email).then((userDoc) {
        bool hasAccess = this.hasAccess(userDoc.data()!.role);
        bool isDisabled = this.isDisabled(userDoc.data()!.disabled);
        if (!hasAccess) {
          throw AuthException("Access denied");
        } else if (isDisabled) {
          throw FirebaseAuthException(code: 'user-disabled');
        }
        return _auth.signInWithEmailAndPassword(
            email: email, password: password);
      });
    } catch (error) {
      if (error is FirebaseAuthException) {
        print(error.code);
        if (error.code == 'user-disabled') {
          return 'User has been disabled. Contact support for more information';
        } else {
          return 'Invalid email or password';
        }
      } else if (error is AuthException) {
        return error.message;
      } else {
        return 'An error occurred. Please try again later';
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  bool hasAccess(Role role) {
    return (role == Role.ADMIN || role == Role.SUPER_ADMIN);
  }

  bool isDisabled(bool? disabled) {
    return disabled != null && disabled == true;
  }
}
