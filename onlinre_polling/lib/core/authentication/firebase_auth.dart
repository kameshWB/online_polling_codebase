import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
export 'package:firebase_auth/firebase_auth.dart';


class FirebaseAuthentication {
  static FirebaseAuth _auth = FirebaseAuth.instance;

  static String getUserID() {
    User user = _auth.currentUser;
    return user.uid.toString();
  }

  static getUser() {
    User user = _auth.currentUser;
    return user;
  }

  static getUserName() {
    User user = _auth.currentUser;
    return user.displayName;
  }

  static getUserEmail() {
    User user = _auth.currentUser;
    return user.email;
  }

  static Future signOut() async {
    print('signOut');
    try {
      await _auth.signOut();
      print('Success');
      return true;
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return e;
    }
  }

  static Future signInWithEmailPassword(
      [String email, String password, AuthCredential pendingCredential]) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (pendingCredential != null) {
        // Link the pending credential with the existing account
        await userCredential.user.linkWithCredential(pendingCredential);
      }

      User user = userCredential.user;

      if (user == null) {
        print('Failed');
        return false;
      } else {
        print('Success');
        return true;
      }
    } catch (e) {
      return e;
    }
  }

  static Future registerWithEmailPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      await result.user.sendEmailVerification();

      if (user == null) {
        print('Failed');
        return false;
      } else {
        print('Success');
        return true;
      }
    } catch (e) {
      print(e);
      return e;
    }
  }
}
