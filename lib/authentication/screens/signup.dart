import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edmyn/authentication/screens/login.dart';
import 'package:edmyn/authentication/screens/verify_otp.dart';
import 'package:edmyn/authentication/services/auth_service.dart';
import 'package:edmyn/authentication/utils/email_validation.dart';
import 'package:edmyn/authentication/utils/signup_error_message.dart';
import 'package:edmyn/authentication/widgets/disclaimer.dart';
import 'package:edmyn/authentication/widgets/google_signin_button.dart';
import 'package:edmyn/authentication/widgets/login_loader.dart';
import 'package:edmyn/authentication/widgets/or_divider.dart';
import 'package:edmyn/authentication/widgets/terms_conditions.dart';
import 'package:edmyn/dashboard/screens/dashboard.dart';
import 'package:edmyn/shared/constants/image_paths.dart';
import 'package:edmyn/shared/text_filters.dart';
import 'package:edmyn/shared/widgets/custom_text_form_field.dart';
import 'package:edmyn/shared/constants/error_message_map.dart';
import 'package:edmyn/authentication/utils/password_validation.dart';
import 'package:edmyn/user/models/user_profile_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:edmyn/shared/styling.dart' as styling;
import 'package:edmyn/shared/utils.dart' as utils;
import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import '../../firestore/services/firestore_service.dart';
import '../../shared/internet_checker/no_internet_screen.dart';
import '../../shared/internet_checker/connectivity_provider.dart';
import '../../user/screens/user_profile.dart';
import '../services/otp_service.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final AuthService _authService = AuthService();
  FocusNode _phoneFocusNode = FocusNode();

  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isLoading = false;
  bool showVerificationMessage = false;
  String errorMessage = '';
  bool acceptTerms = false;
  PhoneNumber number = PhoneNumber(isoCode: 'IN');
  String _otpOrderId = '';
  bool _isOtpSent = false;
  bool isButtonDisabled = false;
  bool showPasswordInfo =
      false;

  @override
  void initState() {
    super.initState();

    _phoneFocusNode.addListener(() {
      if (!_phoneFocusNode.hasFocus) {
        String currentText = _phoneController.text;
        String trimmedText = currentText.replaceAll(RegExp(r'^0+'), '');

        if (currentText != trimmedText) {
          _phoneController.text = trimmedText;
          _phoneController.selection = TextSelection.fromPosition(
            TextPosition(offset: trimmedText.length),
          );
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _usernameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneFocusNode.dispose();
  }

  Future<bool> _showTermsDialog() async {
    bool agreed = false;

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return TermsAndConditionsDialog(
          onAgree: () {
            agreed = true;
            Navigator.of(context).pop(); // Close the dialog
          },
          onDisagree: () {
            agreed = false;
            Navigator.of(context).pop(); // Close the dialog
          },
        );
      },
    );

    return agreed;
  }

  Future<void> _openTerms() async {
    bool agreed = await _showTermsDialog();

    setState(() {
      acceptTerms = agreed;
    });
  }

  Future<void> _openDisclaimer() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return const DisclaimerDialog();
      },
    );
  }

  Future<void> _handleSignUp() async {
    if (formKey.currentState!.validate()) {
      if (!acceptTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please accept the terms and conditions.'),
          ),
        );
        return;
      }

      setState(() {
        isLoading = true;
        errorMessage = '';
      });

      // Check the sign-up method and proceed accordingly
      if (_phoneController.text.isNotEmpty) {
        // Using phone number method
        await _handleSignUpWithEmailAndPhone();
      } else {
        // Using email-only method
        await _handleSignUpWithEmail();
      }
    }
  }

  Future<void> _handleSignUpWithEmailAndPhone() async {
    // Check if phone number is already registered
    final existingUserQuery = await FirebaseFirestore.instance
        .collection('userrole')
        .where('phoneNumber', isEqualTo: _phoneController.text)
        .get();
    print('');
    print('');
    print('');

    print(existingUserQuery);
    print('');
    print('');
    print('');

    if (existingUserQuery.docs.isNotEmpty) {
      // Phone number already exists, show error message
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This phone number is already registered. Please use a different number or sign in.'),
        ),
      );
      return;
    }

    // Request OTP
    String? orderId = await OtpService().requestForOTP(_phoneController.text);

    if (orderId != null) {
      setState(() {
        _otpOrderId = orderId;
        _isOtpSent = true;
        isLoading = false;
      });


      // Navigate to OTP verification screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => VerifyOTP(
            otpOrderId: _otpOrderId,
            phoneNumber: _phoneController.text,
            email: _usernameController.text.trim(),
            password: _passwordController.text.trim(),
            isSignUp: true,
          ),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to send OTP. Please try again.'),
        ),
      );
    }
  }

  Future<void> _handleSignUpWithEmail() async {
    SignUpStatus status = await _authService.signUpUsingEmailAndPassword(
      _usernameController.text.trim(),
      _passwordController.text.trim(),
    );
    // Process the result of the sign-up attempt
    _processSignUpStatus(status);
  }

  void _processSignUpStatus(SignUpStatus status) {
    setState(() {
      isLoading = false;
    });

    if (status == SignUpStatus.success) {
      showVerificationMessage =
      true; // Set to true if you want to show a verification message
      return; // Exit early on success
    }

    // Retrieve the error message using the new class
    String errorMessage = SignUpErrorMessages.getMessage(status);

    // Show a SnackBar with the error message
    _showErrorSnackBar(errorMessage);
  }



  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body:
            Consumer<ConnectivityProvider>(builder: (context, provider, child) {
          // Check the connection status
          if (!provider.isConnected) {
            return NoInternetScreen(
              onRetry: () {},
            );
          }
          return isLoading
              ? const Center(
                  child: LoginLoader(
                  title: 'Signing you up',
                  message:
                      'Please wait while we sign you up. Please do not press back button or close this page',
                )) // Display the loading screen
              : Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: styling.kDefaultPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (showVerificationMessage)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 40.0), // Add some padding to the top
                                    child: Image(image: AssetImage(ImagePaths.logo), height: 40,),
                                  ),
                                  // The existing content below the logo
                                  utils.kVLargeGap(),
                                  Text(
                                    'Please verify your email by clicking on the verification link sent to your email',
                                    style: textTheme.bodyLarge,
                                    textAlign: TextAlign.center,
                                  ),
                                  utils.kVGap(),
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
                                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                            (Set<MaterialState> states) {
                                          if (states.contains(MaterialState.pressed)) {
                                            return Colors.deepPurple; // Darker color when pressed
                                          }
                                          return styling.kPrimaryColor; // Default gradient color
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          if (!showVerificationMessage) ...[
                            utils.kVLargeGap(),
                            const Image(
                              fit: BoxFit.cover,
                              height: 30,
                              image: AssetImage(ImagePaths.logo),
                            ),
                            utils.kVLargeGap(),
                            Text(
                              'Hello !',
                              style: textTheme.headlineMedium,
                            ),
                            utils.kVTinyGap(),
                            Text(
                              "We are so excited to have you! Let’s get started",
                              style: textTheme.bodyMedium?.copyWith(
                                color: styling.kSecondaryTextColor,
                              ),
                            ),
                            utils.kVLargeGap(),
                            CustomGoogleSignInButton(
                              onPressed: () async {
                                // Show the Terms and Conditions dialog
                                bool agreed = await _showTermsDialog();

                                if (agreed) {
                                  // If the user agrees, start the sign-in process
                                  setState(() {
                                    isLoading = true;
                                    errorMessage =
                                        ''; // Clear previous error messages
                                  });

                                  try {
                                    // Try signing in with Google
                                    bool success =
                                        await _authService.signInWithGoogle();

                                    if (success) {
                                      // Fetch user profile data
                                      var user =
                                          FirebaseAuth.instance.currentUser;
                                      if (user != null) {
                                        // Check if user profile exists in Firestore
                                        UserProfile? userProfile =
                                            await FirestoreService()
                                                .getUserProfile(user.uid);

                                        setState(() {
                                          isLoading = false;
                                        });

                                        if (userProfile != null) {
                                          // User already registered
                                          setState(() {
                                            errorMessage =
                                                'This account is already registered. Please sign in instead.';
                                          });
                                        } else {
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const UserProfileScreen(
                                                      hideDrawer: true),
                                            ),
                                          );
                                        }
                                      }
                                    } else {
                                      // Handle sign-in failure
                                      setState(() {
                                        isLoading = false;
                                        errorMessage =
                                            'Google sign-in failed. Please try again.';
                                      });
                                    }
                                  } catch (e) {
                                    // setState(() {
                                    //   isLoading = false;
                                      // Check if the error is due to sign-in cancellation
                                    //   if (e is FirebaseAuthException &&
                                    //       e.code == 'sign_in_canceled') {
                                    //     errorMessage =
                                    //         'Sign-in aborted by user.';
                                    //   } else {
                                    //     errorMessage =
                                    //         'Sign-in was cancelled or failed. Please try again.';
                                    //   }
                                    // });
                                    print('Error during Google sign-in: $e');
                                  }
                                } else {
                                  setState(() {
                                    errorMessage =
                                        'You must agree to the terms and conditions to proceed.';
                                  });
                                }
                              },
                            ),
                            utils.kVLargeGap(),
                            const OrDivider(),
                            utils.kVTinyGap(),
                            if (errorMessage.isNotEmpty)
                              Text(
                                errorMessage,
                                style: textTheme.bodySmall
                                    ?.copyWith(color: styling.kErrorTextColor),
                              ),
                            utils.kVGap(),
                            Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  CustomTextFormField(
                                    label: 'Email',
                                    hintText: "Email ",
                                    controller: _usernameController,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(40),
                                      FilteringTextInputFormatter.allow(
                                          RegExp('[a-z0-9.@_-]')),
                                    ],
                                    onValidate: (String? val) =>
                                        EmailValidator.validate(val),
                                  ),
                                  utils.kVGap(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Phone Number",
                                        style: textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 5,
                                      ),
                                    ],
                                  ),
                                  InternationalPhoneNumberInput(
                                    maxLength: 10,
                                    onInputChanged: (PhoneNumber number) {
                                      this.number =
                                          number; // Store the original number for later use
                                    },
                                    textStyle: textTheme.bodyMedium,
                                    onInputValidated: (bool value) {},
                                    selectorConfig: const SelectorConfig(
                                      selectorType:
                                          PhoneInputSelectorType.BOTTOM_SHEET,
                                    ),
                                    ignoreBlank: false,
                                    autoValidateMode: AutovalidateMode.disabled,
                                    selectorTextStyle:
                                        const TextStyle(color: Colors.black),
                                    initialValue: number,
                                    textFieldController: _phoneController,
                                    focusNode: _phoneFocusNode,
                                    formatInput: false,
                                    keyboardType: TextInputType.number,
                                    inputDecoration: const InputDecoration(
                                      labelText: 'Phone No (Optional)',
                                      hintText: '10 digit phone no',
                                    ),
                                    onSaved: (PhoneNumber number) {
                                      // Save the phone number without leading zeros
                                      if (number.phoneNumber != null &&
                                          number.phoneNumber!.isNotEmpty) {
                                        this.number = PhoneNumber(
                                          phoneNumber: number.phoneNumber,
                                          // Store the original number
                                          isoCode: number.isoCode,
                                          dialCode: number.dialCode,
                                        );
                                      } else {
                                        this.number = PhoneNumber(
                                          phoneNumber: '',
                                          isoCode: '',
                                          dialCode: '',
                                        );
                                      }
                                    },
                                    validator: (value) {
                                      // If the field is empty, it's valid because it's optional
                                      if (value == null || value.isEmpty) {
                                        return null; // No validation error when the field is empty
                                      }

                                      // Remove leading zeros for validation only
                                      String trimmedValue =
                                          value.replaceAll(RegExp(r'^0+'), '');

                                      // Validate that the trimmed phone number is exactly 10 digits
                                      if (trimmedValue.length != 10) {
                                        return 'Please enter a 10-digit phone number after removing leading zeros';
                                      }

                                      // Check if the phone number contains only digits
                                      if (!RegExp(r'^\d+$')
                                          .hasMatch(trimmedValue)) {
                                        return 'Phone number can only contain digits';
                                      }

                                      return null; // Phone number is valid
                                    },
                                  ),
                                  CustomTextFormField(
                                    label: 'Password',
                                    hintText: "Password",
                                    controller: _passwordController,
                                    icon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          showPasswordInfo = !showPasswordInfo;
                                        });
                                      },
                                      icon: Icon(
                                        showPasswordInfo
                                            ? Icons.info
                                            : Icons.info_outline,
                                        color: styling.kPrimaryColor,
                                        size: 18,
                                      ),
                                    ),
                                    decoration: InputDecoration(
                                      isDense: true,
                                      suffixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          // Password visibility toggle
                                          IconButton(
                                            onPressed: () {
                                              setState(() {
                                                hidePassword = !hidePassword;
                                              });
                                            },
                                            icon: Icon(
                                              hidePassword
                                                  ? Icons
                                                      .visibility_off_outlined
                                                  : Icons.visibility_outlined,
                                              color: styling.kPrimaryColor,
                                            ),
                                          ),
                                          // Requirements toggle
                                        ],
                                      ),
                                    ),
                                    obscureText: hidePassword,
                                    inputFormatters: passwordFormatters,
                                    onValidate: (String? val) =>
                                        PasswordValidator.validate(val),
                                  ),
                                  utils.kVTinyGap(),
                                  // Password Requirements Text
                                  Visibility(
                                    visible: showPasswordInfo,
                                    // Show/hide based on showPasswordInfo
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'The password must be 8-20 characters in length and must have at least one uppercase letter, one lowercase letter, one number, and one special character. Allowed special characters are \$,@,*#-',
                                        style: textTheme.bodySmall?.copyWith(
                                          color:
                                              styling.KPasswordConditionColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  utils.kVGap(),
                                  CustomTextFormField(
                                    label: 'Confirm Password',
                                    hintText: "Confirm Password",
                                    controller: _confirmPasswordController,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            hideConfirmPassword =
                                                !hideConfirmPassword;
                                          });
                                        },
                                        icon: Icon(
                                          hideConfirmPassword
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          color: styling.kPrimaryColor,
                                        ),
                                      ),
                                    ),
                                    obscureText: hideConfirmPassword,
                                    inputFormatters: passwordFormatters,
                                    onValidate: (String? val) {
                                      // Trim the input to remove any leading or trailing whitespace
                                      String trimmedValue = val?.trim() ?? '';

                                      // Check if the trimmed value is empty
                                      if (trimmedValue.isEmpty) {
                                        return 'Please confirm your password';
                                      } else if (trimmedValue !=
                                          _passwordController.text) {
                                        return errorMessages[
                                            'passwords_do_not_match'];
                                      }
                                      return null;
                                    },
                                  ),
                                  utils.kVGap(),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: acceptTerms,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            acceptTerms = value ?? false;
                                          });
                                        },
                                      ),
                                      Expanded(
                                        child: RichText(
                                          text: TextSpan(
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    "Before signing up please confirm that you have read and understood the edmyn",
                                                style: textTheme.bodyMedium
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              TextSpan(
                                                text: " Terms and Conditions",
                                                style: textTheme.bodyMedium
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: styling.kPrimaryColor,
                                                  fontSize: 12,
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () async {
                                                        await _openTerms();
                                                      },
                                              ),
                                              TextSpan(
                                                text: " / ",
                                                style: textTheme.bodyMedium
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                ),
                                              ),
                                              TextSpan(
                                                text: "Disclaimer",
                                                style: textTheme.bodyMedium
                                                    ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: styling.kPrimaryColor,
                                                  fontSize: 12,
                                                ),
                                                recognizer:
                                                    TapGestureRecognizer()
                                                      ..onTap = () async {
                                                        await _openDisclaimer();
                                                      },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  utils.kVGap(),
                                  InkWell(
                                    onTap: isButtonDisabled
                                        ? null
                                        : () async {
                                            setState(() {
                                              isButtonDisabled =
                                                  true; // Disable the button
                                            });
                                            await _handleSignUp();
                                            setState(() {
                                              isButtonDisabled =
                                                  false; // Re-enable the button after handling sign-up
                                            });
                                          },
                                    child: Ink(
                                      width: double.infinity,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: styling.kPrimaryColor,
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Sign Up',
                                          style: textTheme.labelLarge?.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  utils.kVGap(),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Already have an account?',
                                        style: textTheme.labelLarge,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const LogIn()));
                                        },
                                        child: Text(
                                          'Login',
                                          style: textTheme.labelLarge?.copyWith(
                                              color: styling.kPrimaryColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                );
        }),
      ),
    );
  }
}
