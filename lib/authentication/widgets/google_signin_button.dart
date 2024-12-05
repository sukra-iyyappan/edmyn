import 'package:flutter/material.dart';
import 'package:edmyn/shared/constants/image_paths.dart';
import 'package:edmyn/shared/styling.dart' as styling;

class CustomGoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const CustomGoogleSignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
            color: styling.kShadowColor,
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(1, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
                color: const Color(0xFF747775), width: 1), // Border color
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                height: 20, // Adjust the height as per the new design
                width: 20, // Adjust the width as per the new design
                image: AssetImage(
                  ImagePaths.googleLogo,
                ),
              ),
              const SizedBox(width: 12), // Match spacing from new design
              Flexible(
                child: Text(
                  'Continue with Google',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.25,
                        color: const Color(0xFF1F1F1F), // Text color
                      ),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
