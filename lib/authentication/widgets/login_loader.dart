import 'package:flutter/material.dart';
import 'package:edmyn/shared/styling.dart' as styling;
import 'package:edmyn/shared/utils.dart' as utils;

class LoginLoader extends StatelessWidget {
  final String title;
  final String message;
  const LoginLoader({super.key, required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          utils.kVTinyGap(),
          Text(
            message,
            style: textTheme.bodyMedium?.copyWith(
              color: styling.kSecondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          utils.kVLargeGap(),
          const CircularProgressIndicator(
            color: styling.kPrimaryColor,
          ),
        ],
      ),
    );
  }
}
