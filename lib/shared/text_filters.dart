import 'package:flutter/services.dart';

List<TextInputFormatter> nameFormatters = [
  FilteringTextInputFormatter.allow(RegExp('[A-Za-z. ]'))
];

List<TextInputFormatter> nonPersonNameFormatters = [
  FilteringTextInputFormatter.allow(RegExp('[A-Za-z. 0-9]'))
];

List<TextInputFormatter> addressFormatters = [
  FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9. ,/#-]'))
];

List<TextInputFormatter> emailFormatters = [
  FilteringTextInputFormatter.allow(RegExp('[a-z0-9.@_-]'))
];

List<TextInputFormatter> passwordFormatters = [
  FilteringTextInputFormatter.allow(RegExp('[A-Za-z0-9\$@*#-]')),
];

List<TextInputFormatter> contactNoFormatters = [
  FilteringTextInputFormatter.digitsOnly,
  LengthLimitingTextInputFormatter(10)
];

List<TextInputFormatter> integerFormatters = [
  FilteringTextInputFormatter.digitsOnly,
  LengthLimitingTextInputFormatter(10)
];

List<TextInputFormatter> doubleFormatters = [
  FilteringTextInputFormatter.allow(RegExp('[0-9.]')),
  LengthLimitingTextInputFormatter(10)
];
