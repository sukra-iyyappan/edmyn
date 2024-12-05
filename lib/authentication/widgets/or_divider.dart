import 'package:flutter/material.dart';
import 'package:edmyn/shared/styling.dart' as styling;

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider()),

        Text(
          'OR',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: styling.kSecondaryTextColor,
          ) ,
        ),

        const Expanded(child: Divider()),
      ],
    );
  }
}
