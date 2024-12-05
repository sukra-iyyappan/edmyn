import 'package:edmyn/authentication/screens/login.dart';
import 'package:edmyn/authentication/utils/email_validation.dart';
import 'package:edmyn/authentication/widgets/login_loader.dart';
import 'package:edmyn/shared/constants/image_paths.dart';
import 'package:edmyn/shared/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:edmyn/shared/styling.dart' as styling;
import 'package:edmyn/shared/utils.dart' as utils;
import 'package:flutter/services.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  bool isLoading = false;
  bool showVerificationMessage = false;
  bool showContent = true;

  bool isEmail(String input) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(input);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _handleSendResetLink() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
        showContent = false;
      });

      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: _usernameController.text);

        await Future.delayed(Duration(seconds: 2));

        if (context.mounted) {
          setState(() {
            isLoading = false;
            showVerificationMessage = true;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password reset link sent to your email.'),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          isLoading = false;
          showContent = true;
        });

        String errorMessage = 'An error occurred';
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found for that email.';
        } else if (e.code == 'invalid-email') {
          errorMessage = 'Invalid email address.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
          ),
        );
      } catch (e) {
        setState(() {
          isLoading = false;
          showContent = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: isLoading
            ? const Center(
                child: LoginLoader(
                title: 'Resetting your password',
                message:
                    'Please wait while we help you reset your password. Please do not press back button or close this page',
              ))
            : showVerificationMessage
                ?Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Add the logo at the top
              Padding(
                padding: const EdgeInsets.only(top: 40.0), // Add some padding to the top
                child: Image(image: AssetImage(ImagePaths.logo), height: 40,),
              ),
              // The existing content below the logo
              utils.kVGap(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Please verify your email by clicking on the password reset link sent to your email.',
                  style: textTheme.bodyLarge?.copyWith(
                    color: styling.kSecondaryTextColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              utils.kVTinyGap(),
              TextButton(
                onPressed: () {
                  // Navigate to the login page
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => LogIn(), // Replace with your actual login page widget
                    ),
                  );
                },
                child: Text(
                  'Go to Login Page',
                  style: TextStyle(
                    fontSize: 18, // Slightly smaller font size for a more balanced look
                    fontWeight: FontWeight.w600, // Medium weight for the text
                    color: Colors.white, // Text color
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent, // Transparent background to allow the gradient
                  padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0), // Increased padding for a bigger button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Rounded corners
                  ),
                  side: BorderSide(color: Colors.white, width: 2), // White border for a defined outline
                ).copyWith(
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                        (Set<WidgetState> states) {
                      if (states.contains(WidgetState.pressed)) {
                        return Colors.deepPurple; // Darker color when pressed
                      }
                      return styling.kPrimaryColor; // Default gradient color
                    },
                  ),
                ),
              )
            ],
          ),
        )

            : SingleChildScrollView(
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
                            "No worries, let's get you back on track",
                            style: textTheme.headlineMedium,
                          ),
                          utils.kVTinyGap(),
                          Text(
                            "Enter your email to receive a password reset link",
                            style: textTheme.bodyMedium?.copyWith(
                              color: styling.kSecondaryTextColor,
                            ),
                          ),
                          utils.kVLargeGap(),
                          Form(
                            key: formKey,
                            child: Column(
                              children: [
                                CustomTextFormField(
                                  label: 'Email',
                                  hintText: "Email or username",
                                  controller: _usernameController,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(40),
                                    FilteringTextInputFormatter.allow(
                                        RegExp('[a-z0-9.@_-]')),
                                  ],
                                  onValidate: (String? val) =>
                                      EmailValidator.validate(val),
                                ),
                                utils.kVLargeGap(),
                                InkWell(
                                  onTap: _handleSendResetLink,
                                  child: Ink(
                                    width: double.infinity,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: styling.kPrimaryColor,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Send Reset Link',
                                        style: textTheme.labelLarge?.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
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
