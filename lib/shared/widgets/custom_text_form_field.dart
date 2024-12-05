import 'package:flutter/material.dart';
import 'package:edmyn/shared/utils.dart' as utils;
import 'package:flutter/services.dart';
import 'package:edmyn/shared/styling.dart' as styling;

class CustomTextFormField extends StatelessWidget {
  final bool? required;
  final bool? readOnly;
  final bool? obscureText;
  final int? minLines;
  final int? maxLines;
  final String? label;
  final bool? hideLabel;
  final String? initialValue;
  final InputDecoration? decoration;
  final List<TextInputFormatter>? inputFormatters;
  final void Function()? onTapped;
  final void Function(String? val)? onChanged;
  final String? Function(String? val)? onValidate;
  final TextEditingController? controller;
  final TextInputType? inputType;
  final String? hintText;
  final BoxDecoration? boxDecoration;
  final Color? fillColor;
  final Widget? icon; // New icon widget property


  const CustomTextFormField({
    super.key,
    this.initialValue,
    this.obscureText,
    this.inputType,
    this.required = true,
    this.minLines = 1,
    this.maxLines = 1,
    required this.label,
    this.onChanged,
    this.onValidate,
    this.onTapped,
    this.controller,
    this.readOnly = false,
    this.inputFormatters = const [],
    this.decoration,
    this.hideLabel = false,
    this.hintText,
    this.boxDecoration,
    this.fillColor,
    this.icon, // Initialize the icon property

  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (!(hideLabel ?? false))
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             Row(
               children: [
                 Text(
                   label!,
                   style: textTheme.bodyMedium?.copyWith(
                     fontWeight: FontWeight.w600,
                   ),
                   maxLines: 5,
                 ),
                 if (required!)
                   Padding(
                     padding: const EdgeInsets.only(left: 4.0),
                     child: Icon(
                       Icons.star,
                       color: Colors.red,
                       size: 6,
                     ),
                   ),
               ],
             ),
              if (icon != null) icon!, // Display the icon if provided

            ],
          ),
        if (!(hideLabel ?? false))
        Container(
          decoration: boxDecoration,
          child: TextFormField(
            style: textTheme.bodyMedium,
            decoration: (decoration ?? const InputDecoration()).copyWith(
              labelText: label,
              hintText: hintText,
              filled: fillColor != null,
              fillColor: fillColor,
            ),
            initialValue: initialValue,
            controller: controller,
            readOnly: readOnly ?? false,
            onTap: onTapped,
            keyboardType: inputType,
            onChanged: (String? val) {
              if (onChanged != null) {
                onChanged!(val);
              }
            },
            obscureText: obscureText ?? false,
            inputFormatters: inputFormatters ?? [],
            maxLines: maxLines,
            minLines: minLines,
            validator: !(required ?? true)
                ? null
                : (String? val) {
                    if (onValidate != null) {
                      return onValidate!(val);
                    } else {
                      return null;
                    }
                  },
          ),
        ),
      ],
    );
  }
}
