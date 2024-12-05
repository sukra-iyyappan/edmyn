import 'package:edmyn/shared/constants/error_message_map.dart';

enum SignUpStatus {
  success,
  emailAlreadyInUse,
  weakPassword,
  invalidEmail,
  incorrectPassword,
  failure,
  failed,
}

class SignUpErrorMessages {
  static String getMessage(SignUpStatus status) {
    switch (status) {
      case SignUpStatus.emailAlreadyInUse:
        return 'User already exists under the email or phone no used during registration';
      case SignUpStatus.weakPassword:
        return errorMessages['password_too_weak']!;
      case SignUpStatus.invalidEmail:
        return 'The email is invalid.';
      default:
        return 'Sign-up failed. Please try again.';
    }
  }
}
