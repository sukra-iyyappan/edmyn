import 'package:flutter/material.dart';

enum SignInStatus {
  success,
  userNotFound,
  wrongPassword,
  invalidCredential,
  failure,
  emailNotVerified,
  weakPassword,

}

class SignInErrorMessage extends StatelessWidget {
  final SignInStatus status;
  final Function(String) updateErrorMessage;

  const SignInErrorMessage({
    Key? key,
    required this.status,
    required this.updateErrorMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String errorMessage = '';

    switch (status) {
      case SignInStatus.userNotFound:
        errorMessage = 'User not found';
        break;

        case SignInStatus.invalidCredential:
        errorMessage = 'You have entered incorrect email or password';
        break;

      case SignInStatus.failure:
      default:
        errorMessage = 'Please verify your email before logging in..';
        break;
    }

    // Update the error message via the callback
    WidgetsBinding.instance.addPostFrameCallback((_) {
      updateErrorMessage(errorMessage);
    });

    // Display the error message on the screen
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        errorMessage,
        style: TextStyle(color: Colors.red), // Styling for the error message
      ),
    );
  }
}
