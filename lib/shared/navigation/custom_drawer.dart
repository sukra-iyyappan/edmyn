import 'package:edmyn/authentication/screens/login.dart';
import 'package:edmyn/dashboard/screens/dashboard.dart';
import 'package:edmyn/public_resource/screens/public_resource_screen.dart';
import 'package:edmyn/user/screens/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:edmyn/shared/styling.dart' as styling;
import 'package:edmyn/shared/utils.dart' as utils;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:edmyn/authentication/services/auth_service.dart';

class CustomDrawer extends StatefulWidget {
  final String screenId;
  const CustomDrawer({super.key, required this.screenId});
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final AuthService _authService = AuthService(); // Instantiate AuthService

  Future<void> logout(BuildContext context) async {
    try {
      // Sign out using AuthService
      await _authService.signOut();

      // Update logged-in state in shared preferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);

      // Navigate to the SignIn screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LogIn()),
      );
    } catch (error) {
      print('Error during logout: $error');
    }
  }

  int selectedIndex = 0;

  List<String> screenIdList = [
    'DASHBOARD',
    // 'PUBLIC-RESOURCE',
    'PROFILE',
    'LOGOUT',
  ];

  @override
  void initState() {
    super.initState();
    selectedIndex = screenIdList.indexOf(widget.screenId);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    String screenId = widget.screenId;
    return NavigationDrawer(
      onDestinationSelected: (int index) {
        setState(() {
          selectedIndex = index;
          screenId = screenIdList[index];
        });


        if (screenId == 'DASHBOARD') {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const Dashboard()));
         }
        //else if (screenId == 'PUBLIC-RESOURCE') {
        //   Navigator.of(context)
        //       .push(MaterialPageRoute(builder: (_) => ResourceListScreen()));
        // }
          else if (screenId == 'PROFILE') {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const UserProfileScreen(hideDrawer: false,)));
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  'Logout',
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                content: Text(
                  'Are you sure you want to logout?',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                actions: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                    child: Text(
                      'Cancel',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      logout(context); // Perform logout
                    },
                    child: Text(
                      'Logout',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: styling.kLightTextColor),
                    ),
                  ),
                ],
              );
            },
          );
        }
      },
      selectedIndex: selectedIndex,
      children: [
        NavigationDrawerDestination(
          icon: const Icon(Icons.home_outlined),
          label: utils.navigationLabelText(textTheme, 'Dashboard'),
        ),
        // NavigationDrawerDestination(
        //   icon: const Icon(Icons.read_more),
        //   label: utils.navigationLabelText(textTheme, 'Public Resource'),
        // ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.person_pin_outlined),
          label: utils.navigationLabelText(textTheme, 'Profile'),
        ),
        NavigationDrawerDestination(
          icon: const Icon(Icons.logout),
          label: utils.navigationLabelText(textTheme, 'Logout'),
        ),
      ],
    );
  }
}
