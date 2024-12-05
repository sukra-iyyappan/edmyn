import 'package:flutter/material.dart';

class TermsAndConditionsDialog extends StatefulWidget {
  final VoidCallback onAgree;
  final VoidCallback onDisagree;

  const TermsAndConditionsDialog({
    required this.onAgree,
    required this.onDisagree,
    super.key,
  });

  @override
  _TermsAndConditionsDialogState createState() =>
      _TermsAndConditionsDialogState();
}

class _TermsAndConditionsDialogState extends State<TermsAndConditionsDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Terms and Conditions'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Text(
              'Please read and agree to the terms and conditions to continue.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            const Text(
              '1. Introduction\n'
              'Welcome to our educational platform, designed to enhance your learning experience. By accessing or using our app and related services, you agree to comply with and be bound by these Terms and Conditions.\n\n'
              '2. Acceptance of Terms\n'
              'By using our app, you agree to these Terms and Conditions. If you do not agree with these terms, please do not use our app.\n\n'
              '3. Use of Services\n'
              'We provide educational resources and tools for users. You agree to use our services for personal, non-commercial educational purposes only. You must not use the app for any illegal or unauthorized activities.\n\n'
              '4. User Accounts\n'
              'To access certain features of the app, you may be required to create an account. You are responsible for maintaining the confidentiality of your account information and for all activities conducted under your account. Notify us immediately if you suspect any unauthorized use of your account.\n\n'
              '5. User Content\n'
              'You retain ownership of any content you create or upload to the app. By submitting content, you grant us a worldwide, royalty-free, non-exclusive license to use, reproduce, modify, and display your content for the purposes of operating and improving the app.\n\n'
              '6. Privacy\n'
              'Your privacy is important to us. Our Privacy Policy outlines how we collect, use, and protect your personal information. By using the app, you consent to our Privacy Policy.\n\n'
              '7. Educational Content\n'
              'We provide educational content that is intended for general information and educational purposes only. We make no representations or warranties regarding the accuracy, completeness, or reliability of the content. Always seek professional advice when making decisions based on educational content.\n\n'
              '8. Intellectual Property\n'
              'All intellectual property rights in the app, including but not limited to trademarks, logos, and content, are owned by us or our licensors. You may not use, reproduce, or distribute any content from the app without our express written permission.\n\n'
              '9. Termination\n'
              'We reserve the right to terminate or suspend your access to the app at our discretion, without notice, for any violation of these Terms and Conditions or any other reason.\n\n'
              '10. Disclaimer of Warranties\n'
              'The app is provided on an "as-is" and "as-available" basis. We do not warrant that the app will be error-free, uninterrupted, or free of viruses or other harmful components. Your use of the app is at your own risk.\n\n'
              '11. Limitation of Liability\n'
              'To the fullest extent permitted by law, we shall not be liable for any indirect, incidental, special, consequential, or punitive damages arising out of or related to your use of the app, including but not limited to damages for loss of data, profits, or other intangible losses.\n\n'
              '12. Changes to Terms\n'
              'We may update these Terms and Conditions from time to time. We will notify you of significant changes by posting the updated terms on our website or app. Your continued use of the app after such changes constitutes your acceptance of the revised terms.\n\n'
              '13. Governing Law\n'
              'These Terms and Conditions are governed by and construed in accordance with the laws of [Your Jurisdiction]. Any disputes arising under or in connection with these terms shall be subject to the exclusive jurisdiction of the courts of [Your Jurisdiction].\n\n'
              '14. Contact Us\n'
              'If you have any questions or concerns about these Terms and Conditions, please contact us at support@ourapp.com.',
              style: TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Disagree'),
          onPressed: () {
            widget.onDisagree(); // User disagrees
          },
        ),
        TextButton(
          child: const Text('Agree'),
          onPressed: () {
            widget.onAgree(); // User agrees
          },
        ),
      ],
    );
  }
}
