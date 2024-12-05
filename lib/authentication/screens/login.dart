import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edmyn/authentication/screens/forgot_password.dart';
import 'package:edmyn/authentication/screens/signup.dart';
import 'package:edmyn/authentication/screens/verify_otp.dart';
import 'package:edmyn/authentication/services/auth_service.dart';
import 'package:edmyn/authentication/services/otp_service.dart';
import 'package:edmyn/authentication/utils/email_validation.dart';
import 'package:edmyn/authentication/utils/phone_number_validation.dart';
import 'package:edmyn/authentication/utils/signin_error_message.dart';
import 'package:edmyn/authentication/widgets/google_signin_button.dart';
import 'package:edmyn/authentication/widgets/login_loader.dart';
import 'package:edmyn/authentication/widgets/or_divider.dart';
import 'package:edmyn/dashboard/screens/dashboard.dart';
import 'package:edmyn/shared/constants/image_paths.dart';
import 'package:edmyn/shared/global.dart';
import 'package:edmyn/shared/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:edmyn/shared/styling.dart' as styling;
import 'package:edmyn/shared/utils.dart' as utils;
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../firestore/services/firestore_service.dart';
import '../../shared/internet_checker/no_internet_screen.dart';
import '../../shared/internet_checker/connectivity_provider.dart';
import '../../user/models/user_profile_model.dart';
import '../../user/screens/user_profile.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> with SingleTickerProviderStateMixin {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool hidePassword = true;
  bool isLoading = false;
  SignInStatus? signInStatus;
  String passwordErrorMessage = '';
  String otpErrorMessage = '';
  String _otpOrderId = '';
  bool _isOtpSent = false;
  int _currentTabIndex = 0;

  final AuthService _authService = AuthService();
  late TabController _tabController;

  @override
  void dispose() {
    _tabController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    passwordErrorMessage = '';
    otpErrorMessage = '';
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        if (_tabController.index == 0) {
          otpErrorMessage = '';
        } else {
          passwordErrorMessage = '';
        }
        setState(() {});
      }
    });
  }



  void _handleSignIn() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
        signInStatus = null;
      });

      try {
        SignInStatus status = await _authService.signInUsingEmailAndPassword(
          _usernameController.text.trim(),
          _passwordController.text.trim(),
        );

        if (status == SignInStatus.success) {
          User? user = FirebaseAuth.instance.currentUser;

          if (user != null) {
            if (!user.emailVerified) {
              setState(() {
                isLoading = false;
                signInStatus = SignInStatus.emailNotVerified;
              });

              await FirebaseAuth.instance.signOut(); // Sign out the unverified user
              return;
            }

            // Fetch user data from Firestore
            DocumentSnapshot userDoc = await FirebaseFirestore.instance
                .collection("userrole")
                .doc(user.uid)
                .get();

            if (userDoc.exists) {
              var userData = userDoc.data() as Map<String, dynamic>;
              String firstName = userData["firstName"] ?? "";
              String lastName = userData["lastName"] ?? "";
              String storedEmail = userData["email"] ?? "";

              bool mandatoryFieldsFilled = firstName.isNotEmpty && lastName.isNotEmpty;

              // Update the email in Firestore if it is different from the stored email
              if (storedEmail != user.email) {
                await FirebaseFirestore.instance
                    .collection("userrole")
                    .doc(user.uid)
                    .update({"email": user.email});
              }

              if (mandatoryFieldsFilled) {
                // If required fields are filled, navigate to the Dashboard
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Dashboard()),
                );
              } else {
                // If mandatory fields are not filled, navigate to User Profile
                setState(() {
                  signInStatus = SignInStatus.failure;
                });
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const UserProfileScreen(hideDrawer: true)),
                );
              }
            } else {
              // If the user data does not exist, navigate to the User Profile screen
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const UserProfileScreen(hideDrawer: true)),
              );
            }
          }
        } else {
          setState(() {
            isLoading = false;
            signInStatus = status; // Set signInStatus based on the failure reason
          });
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          signInStatus = SignInStatus.failure; // Handle any Firebase-specific error here
        });
      } catch (e) {
        setState(() {
          signInStatus = SignInStatus.failure;
        });
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }




  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return PopScope(
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Consumer<ConnectivityProvider>(
            builder: (context, provider, child) {
              // Check the connection status
              if (!provider.isConnected) {
                return NoInternetScreen(
                  onRetry: () {},
                );
              }
              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
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

                            // Loading or sign-in form based on `isLoading`
                            isLoading
                                ? const Align(
                                    alignment: Alignment.center,
                                    child: LoginLoader(
                                      title: 'Signing you in',
                                      message:
                                          'Please wait while we sign you in. Please do not press back button or close this page',
                                    ),
                                  )
                                : buildSignInForm(textTheme, context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Column buildSignInForm(TextTheme textTheme, BuildContext context) {
    return Column(
      children: [
        Text(
          'Hello!',
          style: textTheme.headlineMedium,
        ),
        utils.kVTinyGap(),
        Text(
          "Login to your account",
          style: textTheme.bodyMedium?.copyWith(
            color: styling.kSecondaryTextColor,
          ),
        ),
        utils.kVLargeGap(),
        TabBar(
          controller: _tabController,
          labelColor: styling.kPrimaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: styling.kPrimaryColor,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(
              width: 4.0,
              color: styling.kPrimaryColor,
            ),
            insets: EdgeInsets.symmetric(horizontal: 0.9),
          ),
          tabs: const [
            FittedBox(child: Tab(text: "Sign in with Password")),
            Tab(text: "Sign in with OTP"),
          ],
        ),
        utils.kVLargeGap(),
        SizedBox(
          height: 450, // Adjust the height as needed
          child: TabBarView(
            controller: _tabController,
            children: [
              buildPasswordLoginForm(textTheme, context),
              buildOtpLoginForm(textTheme, context),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildPasswordLoginForm(TextTheme textTheme, BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomTextFormField(
            label: 'Email',
            hintText: "Email",
            controller: _usernameController,
            inputFormatters: [
              LengthLimitingTextInputFormatter(40),
              FilteringTextInputFormatter.allow(RegExp('[a-z0-9.@_-]')),
            ],
            onValidate: (String? val) => EmailValidator.validate(val),
          ),
          utils.kVLargeGap(),
          CustomTextFormField(
            label: 'Password',
            hintText: "Password",
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
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: styling.kPrimaryColor,
                ),
              ),
            ),
            obscureText: hidePassword,
            onValidate: (String? val) {
              if (val == null || val.isEmpty) {
                return 'Please enter your password'; // Validation message
              }
              return null; // No validation error if there's a value
            },
            // inputFormatters: passwordFormatters,
          ),

          utils.kVTinyGap(),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgotPassword()),
                );
              },
              child: const Text(
                'Forgot Password?',
              ),
            ),
          ),
          InkWell(
            onTap: _handleSignIn,
            child: Ink(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: styling.kPrimaryColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: Text(
                  'Login',
                  style: textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          utils.kVLGap(),
          const OrDivider(),
          utils.kVLGap(),
          // Google Button
          CustomGoogleSignInButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
                passwordErrorMessage = ''; // Clear previous error messages
              });

              try {
                // Try signing in with Google
                bool success = await _authService.signInWithGoogle();

                if (success) {
                  // Fetch user profile data
                  var user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    // Fetch the user profile from Firestore
                    UserProfile? userProfile = await FirestoreService().getUserProfile(user.uid);

                    setState(() {
                      isLoading = false;
                    });

                    // Check if the user data is complete
                    if (userProfile == null ||
                        userProfile.firstName == null ||
                        userProfile.firstName!.isEmpty ||
                        userProfile.lastName == null ||
                        userProfile.lastName!.isEmpty ||
                        userProfile.whichClass == null ||
                        userProfile.whichClass!.isEmpty ||
                        userProfile.state == null ||
                        userProfile.state!.isEmpty ||
                        userProfile.city == null ||
                        userProfile.city!.isEmpty) {
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
                  // Handle sign-in failure
                  setState(() {
                    isLoading = false;
                    passwordErrorMessage = 'Google sign-in failed. Please try again.';
                  });
                }
              } catch (e) {
                setState(() {
                  isLoading = false;
                  passwordErrorMessage = 'Sign-in was cancelled or failed. Please try again.';
                });
                print('Error during Google sign-in: $e');
              }
            },
          ),
          utils.kVGap(),
          if (signInStatus != null && signInStatus != SignInStatus.success)
            SignInErrorMessage(status: signInStatus!, updateErrorMessage: (String ) {  },),
          utils.kVGap(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No account?',
                style: textTheme.labelLarge,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const SignUp()));
                },
                child: Text(
                  'Sign Up',
                  style: textTheme.labelLarge
                      ?.copyWith(color: styling.kPrimaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildOtpLoginForm(TextTheme textTheme, BuildContext context) {
    final OtpService otpService =
        OtpService(); // Create an instance of OtpService
    final AuthService _authService = AuthService();
    final TextEditingController _usernameController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomTextFormField(
            label: ' Email or Phone Number ',
            hintText: "Enter your email or phone number",
            controller: _usernameController,
            onValidate: (String? val) {
              if (val == null || val.isEmpty) {
                return 'Please enter your email or phone number';
              } else if (!EmailValidator.isEmail(val) &&
                  !PhoneValidator.isPhoneNumber(val)) {
                return 'Please enter a valid email or 10-digit phone number';
              }
              return null;
            },
          ),
          utils.kVLargeGap(),
          InkWell(
            onTap: isLoading
                ? null
                : () async {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                        otpErrorMessage = ''; // Clear previous error messages
                      });

                      String input = _usernameController.text.trim();
                      print('User input: $input');

                      bool isEmail = EmailValidator.isEmail(input);
                      bool isPhoneNumber = PhoneValidator.isPhoneNumber(input);

                      print('Is email: $isEmail');
                      print('Is phone number: $isPhoneNumber');

                      String? otpOrderId;

                      // try {
                      //   // Proceed to send OTP
                      //   if (isEmail) {
                      //     print('Attempting to send OTP to email: $input');
                      //     otpOrderId =
                      //         await otpService.requestForEmailOTP(input);
                      //     print('OTP Order ID from email: $otpOrderId');
                      //    }
                      //   //else if (isPhoneNumber) {
                      //   //   bool isPhoneNumberExists = await isPhoneNumberRegistered(input);
                      //   //
                      //   //   if (isPhoneNumberExists) {
                      //   //     // Notify user that the phone number is already registered
                      //   //     utils.customSnackBar('This phone number is already registered. ');
                      //   //     setState(() {
                      //   //       isLoading = false; // Stop loading spinner
                      //   //     });
                      //   //     return; // Exit the function here
                      //   //
                      //   //   } else {
                      //       // Proceed with sending OTP
                      //       print('Attempting to send OTP to phone number: $input');
                      //       otpOrderId = await otpService.requestForOTP(input);
                      //       print('OTP Order ID from phone: $otpOrderId');
                      //     }
                      //   }
                      try {
                        // Proceed to send OTP
                        if (isEmail) {
                          print('Attempting to send OTP to email: $input');
                          otpOrderId =
                          await otpService.requestForEmailOTP(input);
                          print('OTP Order ID from email: $otpOrderId');
                        } else if (isPhoneNumber) {
                          print(
                              'Attempting to send OTP to phone number: $input');
                          otpOrderId = await otpService.requestForOTP(input);
                          print('OTP Order ID from phone: $otpOrderId');
                        }

                        if (otpOrderId != null) {
                        setState(() {
                            _otpOrderId =
                                otpOrderId!; // Store the received order ID
                            _isOtpSent = true;
                            isLoading = false;
                          });
                          setState(() {
                            otpErrorMessage = ''; // Clear error message
                          });

                          // Navigate to the correct OTP verification screen based on input type
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => VerifyOTP(
                                otpOrderId: _otpOrderId,
                                phoneNumber: isEmail
                                    ? ''
                                    : input, // Pass phoneNumber if not email
                                email: isEmail
                                    ? input
                                    : null, // Pass email if it's an email, otherwise null
                              ),
                            ),
                          );
                        } else {
                          setState(() {
                            isLoading = false;
                            otpErrorMessage =
                                'Failed to send OTP. Please try again.';
                          });
                        }
                      } catch (e) {
                        setState(() {
                          isLoading = false;
                          otpErrorMessage = 'An error occurred: $e';
                        });
                        print('Error sending OTP: $e');
                      }
                    }
                  },
            child: Ink(
              width: double.infinity,
              height: 50,
              decoration: BoxDecoration(
                color: styling.kPrimaryColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Center(
                child: isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text(
                        'Send OTP',
                        style: textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
          utils.kVLGap(),
          const OrDivider(),
          utils.kVLGap(),
          CustomGoogleSignInButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
                passwordErrorMessage = ''; // Clear previous error messages
              });

              try {
                // Try signing in with Google
                bool success = await _authService.signInWithGoogle();

                if (success) {
                  // Fetch user profile data
                  var user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    // Fetch the user profile from Firestore
                    UserProfile? userProfile = await FirestoreService().getUserProfile(user.uid);

                    setState(() {
                      isLoading = false;
                    });

                    // Check if the user data is complete
                    if (userProfile == null ||
                        userProfile.firstName == null ||
                        userProfile.firstName!.isEmpty ||
                        userProfile.lastName == null ||
                        userProfile.lastName!.isEmpty ||
                        userProfile.whichClass == null ||
                        userProfile.whichClass!.isEmpty ||
                        userProfile.state == null ||
                        userProfile.state!.isEmpty ||
                        userProfile.city == null ||
                        userProfile.city!.isEmpty) {
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
                  // Handle sign-in failure
                  setState(() {
                    isLoading = false;
                    passwordErrorMessage = 'Google sign-in failed. Please try again.';
                  });
                }
              } catch (e) {
                setState(() {
                  isLoading = false;
                  passwordErrorMessage = 'Sign-in was cancelled or failed. Please try again.';
                });
                print('Error during Google sign-in: $e');
              }
            },
          ),
          utils.kVTinyGap(),
          if (otpErrorMessage.isNotEmpty)
            Text(
              otpErrorMessage,
              style:
                  textTheme.bodySmall?.copyWith(color: styling.kErrorTextColor),
            ),
          utils.kVTinyGap(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'No account?',
                style: textTheme.labelLarge,
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const SignUp()));
                },
                child: Text(
                  'Sign Up',
                  style: textTheme.labelLarge
                      ?.copyWith(color: styling.kPrimaryColor),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
