import 'package:flutter/material.dart';

class DisclaimerDialog extends StatelessWidget {
  const DisclaimerDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Disclaimer'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Educational Purposes Only\n\n'
                'The information provided by [Your App Name] is for general educational purposes only. All content, including but not limited to text, graphics, images, and other material, is intended for informational purposes and should not be construed as professional or academic advice.\n\n'
                'No Guarantees\n\n'
                'While we strive to provide accurate and up-to-date information, [Your App Name] makes no warranties or representations about the accuracy, completeness, or reliability of the content. The information is provided on an "as is" basis and we do not guarantee that it will be current, accurate, or error-free.\n\n'
                'Not a Substitute for Professional Advice\n\n'
                'The content provided through [Your App Name] is not intended to be a substitute for professional advice, including but not limited to academic, medical, legal, or financial advice. Always seek the advice of a qualified professional with any questions you may have regarding a specific subject matter.\n\n'
                'Limitation of Liability\n\n'
                'In no event shall [Your App Name], its creators, or any affiliated parties be liable for any direct, indirect, incidental, special, or consequential damages arising out of or in connection with the use of or inability to use the app, even if advised of the possibility of such damages.\n\n'
                'Third-Party Links\n\n'
                '[Your App Name] may contain links to third-party websites or resources. These links are provided for convenience and informational purposes only. We do not endorse and are not responsible for the content, products, or services offered by any third parties.\n\n'
                'Changes to Disclaimer\n\n'
                'We reserve the right to modify or update this disclaimer at any time without prior notice. It is your responsibility to review this disclaimer periodically for any changes.\n\n'
                'Contact Us\n\n'
                'If you have any questions about this disclaimer or the content of [Your App Name], please contact us at [Your Contact Information].'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
        ),
      ],
    );
  }
}
