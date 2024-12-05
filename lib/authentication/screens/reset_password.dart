import 'package:edmyn/authentication/screens/login.dart';
import 'package:edmyn/shared/constants/image_paths.dart';
import 'package:edmyn/shared/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:edmyn/shared/styling.dart' as styling;
import 'package:edmyn/shared/utils.dart' as utils;
import 'package:flutter/services.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({super.key});

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool hidePassword = true;
  bool hideConfirmPassword = true;

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                  'Reset Password',
                  style: textTheme.headlineMedium,
                ),
                utils.kVTinyGap(),
                Text(
                  "Reset your password",
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
                        label: 'Create Password',
                        hintText: "Create Password",
                        controller: _passwordController,
                        decoration: const InputDecoration().copyWith(
                          isDense: true,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                hidePassword = !hidePassword;
                              });
                            },
                            icon: Icon(
                              hidePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: styling.kPrimaryColor,
                            ),
                          ),
                        ),
                        obscureText: hidePassword,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(40),
                        ],
                        onValidate: (String? val) {
                          if (val == null || val.isEmpty) {
                            return 'Field Required';
                          } else {
                            return null;
                          }
                        },
                      ),
                      utils.kVLargeGap(),
                      CustomTextFormField(
                        label: 'Confirm Password',
                        hintText: "Confirm Password",
                        controller: _confirmPasswordController,
                        decoration: const InputDecoration().copyWith(
                          isDense: true,
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                hideConfirmPassword = !hideConfirmPassword;
                              });
                            },
                            icon: Icon(
                              hideConfirmPassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: styling.kPrimaryColor,
                            ),
                          ),
                        ),
                        obscureText: hideConfirmPassword,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(40),
                        ],
                        onValidate: (String? val) {
                          if (val == null || val.isEmpty) {
                            return 'Field Required';
                          } else {
                            return null;
                          }
                        },
                      ),
                      utils.kVLargeGap(),
                      InkWell(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            if (_passwordController.text.trim() !=
                                _confirmPasswordController.text.trim()) {
                            } else {
                              if (!context.mounted) return;
                              utils.customSnackBar('Passwords do not match');
                            }
                          }
                          // _handleSignUp();
                          // if (_errorMessage.isNotEmpty) {
                          //   Padding(
                          //     padding: const EdgeInsets.only(top: 16.0),
                          //     child: Text(
                          //       _errorMessage,
                          //       style: const TextStyle(color: Colors.red),
                          //     ),
                          //   );
                          // }
                        },
                        child: Ink(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: styling.kPrimaryColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Text(
                              'Reset Password',
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
                            'Already have an account?',
                            style: textTheme.labelLarge,
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LogIn()));
                            },
                            child: Text(
                              'Login',
                              style: textTheme.labelLarge
                                  ?.copyWith(color: styling.kPrimaryColor),
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
