import 'package:flutter/material.dart';

class CustomSearchField extends StatelessWidget {
  const CustomSearchField({super.key, required this.onSearchCompletion, this.onMore});

  final void Function(String val) onSearchCompletion;
  final void Function()? onMore;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextFormField(
      decoration: const InputDecoration().copyWith(
        hintText: 'Search',
        suffixIcon:  onMore != null ? IconButton(
          onPressed: onMore,
          icon: Icon(
            Icons.more_vert,
            color: colorScheme.secondary,
            size: 25,
          ),
        ) : const SizedBox.shrink(),
        prefixIcon: Icon(
          Icons.search,
          color: colorScheme.secondary,
          size: 25,
        ),
      ),
      onChanged: onSearchCompletion,
    );
  }
}
