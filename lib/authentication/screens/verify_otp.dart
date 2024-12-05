import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edmyn/authentication/screens/login.dart';
import 'package:edmyn/authentication/services/otp_service.dart';
import 'package:edmyn/dashboard/screens/dashboard.dart';
import 'package:edmyn/shared/constants/image_paths.dart';
import 'package:edmyn/shared/global.dart';
import 'package:edmyn/shared/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:edmyn/shared/styling.dart' as styling;
import 'package:edmyn/shared/utils.dart' as utils;
import 'package:flutter/services.dart';

import '../../firestore/services/firestore_service.dart';
import '../../user/models/user_profile_model.dart';
import '../../user/screens/user_profile.dart';

class VerifyOTP extends StatefulWidget {
  const VerifyOTP({
    super.key,
    required this.otpOrderId,
    required this.phoneNumber,
    this.email,
    this.password,
    this.identifier,
    this.isSignUp = false,
  });

  final String otpOrderId;
  final String phoneNumber;
  final String? email;
  final String? password;
  final bool isSignUp;
  final String? identifier;

  @override
  State<VerifyOTP> createState() => _VerifyOTPState();
}

class _VerifyOTPState extends State<VerifyOTP> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  final OtpService _otpService = OtpService();
  bool isLoading = false;
  String errorMessage = '';
  String? _otpOrderId; // Mutable state variable
  Timer? _timer;
  int _remainingTime = 60; // Initial countdown in seconds
  bool _isResendButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _otpOrderId = widget.otpOrderId;
    _startOtpTimer(); // Start timer when screen loads
// Initialize it with the widget's value
  }

  @override
  void dispose() {
    _otpController.dispose();
    _timer?.cancel(); // Cancel the timer when screen is disposed

    super.dispose();
  }

  void _startOtpTimer() {
    setState(() {
      _isResendButtonEnabled = false; // Disable resend button initially
      _remainingTime = 60; // Set the countdown duration
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _isResendButtonEnabled = true; // Enable resend button
          _timer?.cancel();
        }
      });
    });
  }

  // Assuming you have a function that fetches the custom token from your server
  Future<void> _signInWithCustomToken(String customToken) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCustomToken(customToken);
      print("Signed in with custom token: ${userCredential.user?.uid}");
    } catch (e) {
      print("Error signing in with custom token: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in: $e')),
      );
    }
  }

  Future<void> _verifyOtp() async {
    if (formKey.currentState!.validate()) {
      _startLoading();
      final otp = _otpController.text;

      if (widget.email != null && widget.email!.isNotEmpty) {
        await _verifyEmailOtp(otp);
      } else {
        await _verifyPhoneOtp(otp);
      }
      _stopLoading();
    }
  }

// this is my phone number otp methode
  Future<void> _verifyPhoneOtp(String otp) async {
    final responseData = await _otpService.verifyOTP(
      widget.phoneNumber,
      _otpOrderId!,
      otp,
    );

    if (responseData != null) {
      _handleResponse(responseData);
    } else {
      _setError('Failed to verify phone OTP. Please try again.');
    }
  }

  Future<void> _verifyEmailOtp(String otp) async {
    final responseData = await _otpService.verifyEmailOTP(
      widget.email!,
      _otpOrderId!,
      otp,
    );

    if (responseData != null) {
      _handleResponse(responseData);

    } else {
      _setError('Failed to verify email OTP. Please try again.');
    }
  }

  void _startLoading() {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });
  }

  void _stopLoading() {
    setState(() {
      isLoading = false;
    });
  }

  void _handleResponse(Map<String, dynamic> responseData) {
    try {
      if (responseData['response'] != null) {
        final statusCode = responseData['response']['status_code'];
        final isOtpVerified = responseData['response']['is_OTP_verified'];
        final message = responseData['response']['message'] ?? '';

        if (statusCode == 200) {
          if (isOtpVerified == true) {
            _processSuccessfulVerification(responseData);
          } else {
            _setError(message.isNotEmpty
                ? message
                : 'Failed to verify OTP. Please try again.');
          }
        } else {
          _setError(message.isNotEmpty
              ? message
              : 'Unexpected response from server.');
        }
      } else {
        _setError('Unexpected response structure from server.');
      }
    } catch (e) {
      _setError('Error processing response: $e');
    }
  }

  void _processSuccessfulVerification(Map<String, dynamic> responseData) async {
    final userIdResponse = responseData['response']['user_id'];
    final customToken = responseData['response']['user_custom_token'];

    // Store the user ID globally
    userId = userIdResponse;

    if (customToken != null) {
      await _signInWithCustomToken(customToken);

      // Link email and password for sign-ups if provided
      if (widget.isSignUp && widget.email != null && widget.password != null) {
        await _linkEmailAuth();
      }

      // Fetch the current user after signing in with the custom token
      var user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final docRef = FirebaseFirestore.instance.collection("userrole").doc(user.uid);

        // Check if the document exists
        final docSnapshot = await docRef.get();
        if (docSnapshot.exists) {
          // Update the phone number if the document exists
          if (widget.phoneNumber != null && widget.phoneNumber!.isNotEmpty) {
            await docRef.update({"phoneNumber": widget.phoneNumber});
          }
        } else {
          // Create the document if it doesn't exist
          await docRef.set({
            "phoneNumber": widget.phoneNumber,
            // Add any other fields you need for a new user here
          });
        }
        // Fetch the user profile from Firestore
        UserProfile? userProfile = await FirestoreService().getUserProfile(user.uid);

        setState(() {
          isLoading = false;
        });

        // Check if the user profile data is complete
        if (_isProfileIncomplete(userProfile)) {
          // Navigate to UserProfileScreen if data is incomplete
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const UserProfileScreen(hideDrawer: true),
            ),
          );
        } else {
          // Navigate to Dashboard if data is complete
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const Dashboard(),
            ),
          );
        }
      }
    } else {
      _setError('Custom token not found');
    }
  }

// Helper function to check if profile data is incomplete
  bool _isProfileIncomplete(UserProfile? userProfile) {
    return userProfile == null ||
        userProfile.firstName == null ||
        userProfile.firstName!.isEmpty ||
        userProfile.lastName == null ||
        userProfile.lastName!.isEmpty ||
        userProfile.whichClass == null ||
        userProfile.whichClass!.isEmpty ||
        userProfile.state == null ||
        userProfile.state!.isEmpty ||
        userProfile.city == null ||
        userProfile.city!.isEmpty;
  }

  Future<void> _linkEmailAuth() async {
    final credential = EmailAuthProvider.credential(
      email: widget.email!,
      password: widget.password!,
    );

    try {
      final userCredential = await FirebaseAuth.instance.currentUser!
          .linkWithCredential(credential);

      // Send verification email
      await userCredential.user?.sendEmailVerification();

      _navigateToLogIn();
      utils.customSnackBar(
        'Please check your email and verify it using the link we sent to your registered email address',
      );
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthException(e);
    }
  }

  void _navigateToLogIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LogIn()),
    );
  }

  void _navigateToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Dashboard()),
    );
  }

  void _setError(String message) {
    setState(() {
      errorMessage = message;
    });
  }



  void _navigateToUserProfile() {
    Navigator.pushReplacementNamed(context, '/userProfile');
  }

  void _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case "provider-already-linked":
        print("The provider has already been linked to the user.");
        break;
      case "invalid-credential":
        print("The provider's credential is not valid.");
        break;
      case "credential-already-in-use":
        print(
            "The account corresponding to the credential already exists, or is already linked to a Firebase User.");
        break;
      default:
        print("Unknown error.");
    }
  }

  Future<void> _resendOtp() async {
    String? newOtpOrderId;

    if (widget.email != null && widget.email!.isNotEmpty) {
      newOtpOrderId =
          await _otpService.resendEmailOTP(widget.email!, _otpOrderId!);
    } else {
      newOtpOrderId = await _otpService.resendOTP(_otpOrderId!);
    }

    if (newOtpOrderId != null) {
      setState(() {
        _otpOrderId = newOtpOrderId; // Update the mutable state variable
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP Resent Successfully!')),
      );
      _startOtpTimer();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to resend OTP. Please try again.')),
      );
    }
  }

  @override

  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: styling.kDefaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                utils.kVLargeGap(),
                const Image(
                  fit: BoxFit.cover,
                  height: 30,
                  image: AssetImage(ImagePaths.logo),
                ),
                utils.kVLargeGap(),
                Text(
                  "Sending an OTP ${widget.phoneNumber != null && widget.phoneNumber!.isNotEmpty ? 'to your phone' : widget.email != null && widget.email!.isNotEmpty ? 'to your email' : ''}",
                  style: textTheme.headlineMedium,
                ),

                utils.kVLargeGap(),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        label: 'OTP',
                        hintText: "OTP",
                        controller: _otpController,
                        boxDecoration: const BoxDecoration(),
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(6),
                        ],
                        onValidate: (String? val) {
                          if (val == null || val.isEmpty) {
                            return 'Please enter otp';
                          }
                          return null;
                        },
                      ),
                      utils.kVLargeGap(),
                      if (errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Text(
                            errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      isLoading
                          ? const CircularProgressIndicator()
                          : InkWell(
                        onTap: isLoading ? null : _verifyOtp,
                        child: Ink(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isLoading
                                ? Colors.grey
                                : styling.kPrimaryColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Text(
                              'Verify OTP',
                              style: textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      utils.kVLargeGap(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't receive the OTP?",
                            style: textTheme.labelLarge,
                          ),
                          TextButton(
                            onPressed: _isResendButtonEnabled ? _resendOtp : null,
                            child: Text(
                              _isResendButtonEnabled
                                  ? 'Resend'
                                  : 'Resend in $_remainingTime seconds',
                              style: textTheme.labelLarge?.copyWith(
                                color: _isResendButtonEnabled
                                    ? styling.kPrimaryColor
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
