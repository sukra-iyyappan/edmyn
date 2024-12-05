import 'package:edmyn/shared/constants/image_paths.dart';
import 'package:flutter/material.dart';
import 'package:edmyn/shared/styling.dart' as styling;

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final VoidCallback? onMenuTap;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.scaffoldKey,
    this.onMenuTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(title),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Image.asset(
          ImagePaths.whiteLogo,
          width: 40,
          fit: BoxFit.contain,
        ),
      ),
      actions: [
        IconButton(
          onPressed: onMenuTap ??
                  () {
                if (scaffoldKey.currentState != null) {
                  if (scaffoldKey.currentState!.isDrawerOpen) {
                    scaffoldKey.currentState!.closeDrawer();
                  } else {
                    scaffoldKey.currentState!.openDrawer();
                  }
                }
              },
          icon: const Icon(Icons.menu, color: styling.kLightColor),
        ),
      ],
    );
  }
}
