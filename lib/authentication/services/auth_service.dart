import 'package:edmyn/authentication/utils/signin_error_message.dart';
import 'package:edmyn/authentication/utils/signup_error_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: [
    'profile',
    'email',
  ]);

  String getCurrentUserEmail() {
    User? user = _firebaseAuth.currentUser;
    return user?.email ?? '';
  }

  // Sign up using email and password
  Future<SignUpStatus> signUpUsingEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print('signup creditinal ');
      print(userCredential);

      // Send verification email
      await userCredential.user?.sendEmailVerification().then((_) {
        print('Verification email sent to ${userCredential.user?.email}');
      }).catchError((error) {
        print('Failed to send verification email: $error');
      });

      return SignUpStatus.success;
    } on FirebaseAuthException catch (e) {
      print("");
      print("");
      print("");
      print("");

      print(e);
      print("");
      print("");
      print("");
      print("");
      switch (e.code) {
        case 'email-already-in-use':
          return SignUpStatus.emailAlreadyInUse;
        case 'weak-password':
          return SignUpStatus.weakPassword;
        case 'invalid-email':
          return SignUpStatus.invalidEmail;
        default:
          return SignUpStatus.failed;
      }
    } catch (e) {
      print("");
      print("");

      print(e);
      print("");
      print("");
      print("");
      print("");
      return SignUpStatus.failed;
    }
  }

// Email verified
  Future<bool> isEmailVerified() async {
    User? user = _firebaseAuth.currentUser;
    await user?.reload();
    user = _firebaseAuth.currentUser;
    return user?.emailVerified ?? false;
  }

  //Sign in  Email
  Future<SignInStatus> signInUsingEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return SignInStatus.success;
    } on FirebaseAuthException catch (e) {
      print("");
      print(e);

      // Handle different FirebaseAuth error codes
      if (e.code == 'user-not-found') {
        return SignInStatus.userNotFound; // No user found for this email
      } else if (e.code == 'wrong-password') {
        return SignInStatus.wrongPassword; // Incorrect password
      } else if (e.code == 'weak-password') {
        return SignInStatus.weakPassword; // Weak password entered
      } else if (e.code == 'email-not-verified') {
        return SignInStatus.emailNotVerified; // Email not verified
      } else if (e.code == 'invalid-credential') {
        return SignInStatus.invalidCredential;
      } else {
        return SignInStatus.failure; // General failure for other errors
      }
    } catch (e) {
      print(e);
      return SignInStatus.failure;
    }
  }

  // Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      await _googleSignIn.signOut(); // Optional: sign out before sign in
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        print("Sign-in aborted by user.");
        return false;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
      return true;
    } catch (e) {
      print('');
      print('');
      print('');
      print('');
      print('');

      print(e);
      print('');
      print('');
      print('');
      print('');
      print('');
      print('');

      print('Error during Google Sign-In: $e');
      return false;
    }
  }

// Sign out
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      // Handle any additional logout logic, but do not reinitialize Firebase.
    } catch (e) {
      print("Error during sign out: $e");
    }
  }

}
