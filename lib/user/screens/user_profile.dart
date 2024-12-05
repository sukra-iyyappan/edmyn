import 'dart:async';
import 'package:edmyn/dashboard/screens/dashboard.dart';
import 'package:edmyn/firestore/services/firestore_service.dart';
import 'package:edmyn/shared/navigation/custom_app_bar.dart';
import 'package:edmyn/shared/navigation/custom_drawer.dart';
import 'package:edmyn/shared/text_filters.dart';
import 'package:edmyn/shared/internet_checker/connectivity_provider.dart';
import 'package:edmyn/shared/widgets/custom_text_form_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:edmyn/shared/styling.dart' as styling;
import 'package:edmyn/shared/utils.dart' as utils;
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/internet_checker/no_internet_screen.dart';
import '../models/user_profile_model.dart';

class UserProfileScreen extends StatefulWidget {
  final bool hideDrawer; // Add this parameter

  const UserProfileScreen({super.key,  required this.hideDrawer});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _localityController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  FocusNode _phoneFocusNode = FocusNode();
  PhoneNumber number = PhoneNumber(isoCode: 'IN');

  bool isFirstTimeUser = false;
  bool isProfileComplete = false;
  String uid = '';
  bool isLoading = true;
  bool showMessage = false;




  @override
  void initState() {
    super.initState();
    loadUserData();
    _checkProfileCompletion();

  }
  Future<void> _checkProfileCompletion() async {
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      // Show the message if any required field is empty
      showMessage = isAnyFieldEmpty();
    });
  }

  bool isAnyFieldEmpty() {
    return _firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _classController.text.isEmpty ||
        _cityController.text.isEmpty ||
        _localityController.text.isEmpty ||
        _phoneController.text.isEmpty;
  }


  Future<void> loadUserData() async {
    var user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      uid = user.uid;

      UserProfile? userProfile = await FirestoreService().getUserProfile(uid);

      print('UID: $uid');

      if (userProfile != null) {
        print('Name: ${userProfile.firstName}');
        print('Name: ${userProfile.lastName}');
        print('Class: ${userProfile.whichClass}');
        print('City: ${userProfile.state}');
        print('Locality: ${userProfile.city}');
        print('Phone: ${userProfile.phoneNumber}');

        _firstNameController.text = userProfile.firstName ?? '';
        _lastNameController.text = userProfile.lastName ?? '';
        _classController.text = userProfile.whichClass ?? '';
        _cityController.text = userProfile.state ?? '';
        _localityController.text = userProfile.city ?? '';
        _phoneController.text = userProfile.phoneNumber ?? '';

      }
      // Check if the user is a first-time user
      final prefs = await SharedPreferences.getInstance();
      isFirstTimeUser = prefs.getBool('isFirstTime') ?? true;

      // Set state to update UI with isFirstTimeUser value
      setState(() {});
    }


  }
  @override
  void dispose() {
    _usernameController.dispose();
    _classController.dispose();
    _cityController.dispose();
    _localityController.dispose();
    _phoneController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();

    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (formKey.currentState!.validate()) {
      // Trim input data
      _firstNameController.text = _firstNameController.text.trim();
      _lastNameController.text = _lastNameController.text.trim();
      _classController.text = _classController.text.trim();
      _cityController.text = _cityController.text.trim();
      _localityController.text = _localityController.text.trim();
      _phoneController.text = _phoneController.text.trim();

      // Create a UserProfile instance with the trimmed data
      final userProfile = UserProfile(
        id: uid,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        whichClass: _classController.text,
        state: _cityController.text,
        city: _localityController.text,
        phoneNumber: _phoneController.text,
        profileCompleted: true, // Set profile as complete
      );

      setState(() {});

      try {
        // Save the profile to Firestore
        await FirestoreService().saveUserProfile(userProfile);
        // Save profile completion status locally in SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('profileCompleted', true);
// Update flags to show the drawer
        setState(() {
          isProfileComplete = true;
        });

        // Display a success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => UserProfileScreen(hideDrawer: false),
          ),
        );

      } catch (e) {
        // Display an error message if saving fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving profile: $e')),
        );
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
          key: scaffoldKey,
          drawer: widget.hideDrawer ? null : const CustomDrawer(screenId: 'PROFILE'),
          appBar: CustomAppBar(
            title: 'Profile',
            scaffoldKey: scaffoldKey,
          ),
          backgroundColor: Colors.white,
          body:Consumer<ConnectivityProvider>(builder: (context, provider, child) {
            // Check the connection status
            if (!provider.isConnected) {
              return NoInternetScreen(
                onRetry: () {},
              );
            }
            return Padding(
              padding: styling.kDefaultPadding,
              child: SingleChildScrollView(
                child:Column(
                  children: [
                    if (showMessage && isAnyFieldEmpty()) ...[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 16.0),
                        padding: EdgeInsets.all(16.0),

                        child: Text(
                          'Please complete your profile before using the app',
                          style: textTheme.bodyMedium?.copyWith(
                            // color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          // const CircleAvatar(
                          //   radius: 40,
                          //   backgroundColor: Colors.blue,
                          //   child: Icon(Icons.person, size: 40, color: Colors.white),
                          // ),
                          // utils.kVGap(),
                          // Profile input fields
                          // CustomTextFormField(
                          //   label: 'Name',
                          //   hintText: 'Name',
                          //   controller: _nameController,
                          //   inputFormatters: nameFormatters,
                          //   onValidate: (String? val) {
                          //     if (val == null || val.trim().isEmpty) {
                          //       return 'Please enter name';
                          //     } else if (RegExp(r'\s{2,}').hasMatch(val)) {
                          //       return 'Please avoid multiple spaces';
                          //     }
                          //     return null;
                          //   },
                          // ),
                          CustomTextFormField(
                            label: 'First Name',
                            hintText: ' First Name',
                            controller: _firstNameController,
                            inputFormatters: nameFormatters,
                            onValidate: (String? val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Please enter first name';
                              } else if (RegExp(r'\s{2,}').hasMatch(val)) {
                                return 'Please avoid multiple spaces';
                              }
                              return null;
                            },
                          ),
                          CustomTextFormField(
                            label: 'Last Name',
                            hintText: 'Last Name',
                            controller: _lastNameController,
                            inputFormatters: nameFormatters,
                            onValidate: (String? val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Please enter last name';
                              } else if (RegExp(r'\s{2,}').hasMatch(val)) {
                                return 'Please avoid multiple spaces';
                              }
                              return null;
                            },
                          ),
                          utils.kVGap(),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Phone Number",
                                      style: textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    utils.kHTinyGap(),
                                    Icon(
                                      Icons.star,
                                      color: Colors.red,
                                      size: 6,
                                    ),
                                  ],
                                ),
                              ]),
                          InternationalPhoneNumberInput(
                            maxLength: 10,
                            onInputChanged: (PhoneNumber number) {
                              this.number = number;
                            },
                            onInputValidated: (bool value) {},
                            selectorConfig: const SelectorConfig(
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            ),
                            ignoreBlank: false,
                            autoValidateMode: AutovalidateMode.disabled,
                            selectorTextStyle: const TextStyle(color: Colors.black),
                            initialValue: number,
                            textFieldController: _phoneController,
                            focusNode: _phoneFocusNode,
                            formatInput: false,
                            inputDecoration: const InputDecoration(
                              labelText: 'Phone No',
                              hintText: '10 digit phone no',
                            ),
                            onSaved: (PhoneNumber number) {
                              // Remove leading zeros and update the number
                              String? formattedNumber =
                              number.phoneNumber?.replaceAll(RegExp(r'^0+'), '');
                              this.number = PhoneNumber(
                                phoneNumber: formattedNumber,
                                isoCode: number.isoCode,
                                dialCode: number.dialCode,
                              );
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone number';
                              }

                              // Remove leading zeros
                              String trimmedValue =
                              value.replaceAll(RegExp(r'^0+'), '');

                              if (trimmedValue.length != 10) {
                                return 'Please enter a 10-digit phone number after removing leading zeros';
                              }

                              return null;
                            },
                          ),
                          utils.kVGap(),
                          CustomTextFormField(
                            label: 'Class',
                            hintText: 'Class',
                            controller: _classController,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9a-zA-Z]')),
                              LengthLimitingTextInputFormatter(50),
                            ],
                            onValidate: (String? val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Please enter class';
                              } else if (RegExp(r'\s{2,}').hasMatch(val)) {
                                return 'Please avoid multiple spaces';
                              }
                              return null;
                            },
                          ),
                          utils.kVGap(),
                          CustomTextFormField(
                            label: 'City',
                            hintText: 'City',
                            controller: _cityController,
                            inputFormatters: nameFormatters,
                            onValidate: (String? val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Please enter city';
                              } else if (RegExp(r'\s{2,}').hasMatch(val)) {
                                return 'Please avoid multiple spaces';
                              }
                              return null;
                            },
                          ),
                          utils.kVGap(),
                          CustomTextFormField(
                            label: 'Locality',
                            hintText: 'Locality',
                            controller: _localityController,
                            inputFormatters: nameFormatters,
                            onValidate: (String? val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Please enter locality';
                              } else if (RegExp(r'\s{2,}').hasMatch(val)) {
                                return 'Please avoid multiple spaces';
                              }
                              return null;
                            },
                          ),
                          utils.kVLargeGap(),

                          // Save button
                          SizedBox(
                            width: double.infinity, // Make button full-width
                            child: InkWell(
                              onTap: _saveProfile,
                              child: Ink(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: styling.kPrimaryColor,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Center(
                                  child: Text(
                                    'Save',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(color: Colors.white),
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
            );
          }),
        ),
      ),
    );
  }
}
