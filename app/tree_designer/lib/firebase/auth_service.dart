import 'package:firebase_auth/firebase_auth.dart';
import 'package:tree_designer/firebase/firestore.dart';

class AuthService {
  static final FirebaseAuth _authInstance = FirebaseAuth.instance;

  static bool isUserLoggedIn() {
    return _authInstance.currentUser != null;
  }

  static void logUserOut() {
    _authInstance.signOut();
  }

  static Future<String?> login({required String email, required String password}) async {
    try {
      await _authInstance.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          return 'No user found for the provided email.';
        } else if (e.code == 'wrong-password') {
          return 'The password provided is incorrect.';
        } else if (e.code == 'invalid-email') {
          return 'The email address is not valid.';
        } else if (e.code == 'user-disabled') {
          return 'The user account has been disabled.';
        } else if (e.code == 'too-many-requests') {
          return 'Too many unsuccessful login attempts. Please try again later.';
        } else {
          return e.message;
        }
    } catch (e) {
        return e.toString();
    }

    return 'success';
  }

  static Future<String?> registration({required String email, required String password}) async {
    try {
      UserCredential userCredentials = await _authInstance.createUserWithEmailAndPassword(email: email, password: password);
      FirestoreUtils.addNewUserToDatabase(userCredentials);
    } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
            return 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
            return 'The account already exists for that email.';
        } else if (e.code == 'invalid-email') {
            return 'The email address is not valid.';
        } else if (e.code == 'operation-not-allowed') {
            return 'Email/password accounts are not enabled.';
        } else if (e.code == 'email-already-exists') {
            return 'The email address is already in use by another account.';
        } else {
            return e.message;
        }
    } catch (e) {
        return e.toString();
    }

    return 'success';
  }
}