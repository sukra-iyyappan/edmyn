import 'package:flutter/material.dart';
import 'package:edmyn/shared/global.dart' as global;

// For Spacing between widgets
Widget kVGap() {
  return const SizedBox(height: 8.0);
}
Widget kVLiteGap() {
  return const SizedBox(height: 6.0);
}

Widget kVLGap() {
  return const SizedBox(height: 16.0);
}

Widget kVLargeGap() {
  return const SizedBox(height: 24.0);
}

Widget kXlGap() {
  return const SizedBox(height: 146.0);
}

Widget kVTinyGap() {
  return const SizedBox(height: 4.0);
}

Widget kHGap() {
  return const SizedBox(width: 8.0);
}

Widget kHLargeGap() {
  return const SizedBox(width: 16.0);
}

Widget kHXLargeGap() {
  return const SizedBox(width: 32.0);
}

Widget kHTinyGap() {
  return const SizedBox(width: 4.0);
}

Widget navigationLabelText(TextTheme textTheme, String label) {
  return Text(
    label,
    style: textTheme.bodyMedium,
  );
}

customSnackBar(String message) {
  ScaffoldMessenger.of(global.navigatorKey.currentContext!).showSnackBar(
    SnackBar(
      padding: const EdgeInsets.all(16.0),
      content: Text(
        message,
      ),
    ),
  );
}
