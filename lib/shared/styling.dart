import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Theme Colors
const Color kPrimaryColor = Color(0xFF3A0CF0);
const Color kSecondaryColor = Color(0xFF6275FB);
const Color kBackgroundColor = Color(0xFFF9F9F9);
const Color kLightColor = Color(0xFFFFFFFF);

// Text Colors
const Color kPrimaryTextColor = Color(0xFF2C2C2C);
const Color kSecondaryTextColor = Color(0xFF8C8C8C);
const Color kTertiaryTextColor = Color(0xFFCFCFCF);
const Color kErrorTextColor = Color(0xFFF03E3E);
const Color kLightTextColor = Color(0xFFFFFFFF);
const Color KPasswordConditionColor = Color(0xff5c8a06);

// Form Field Colors
const Color kDefaultFieldBorderColor = Color(0xFFF1F3F5);
const Color kActiveFieldBorderColor = Color(0xFF8A9FFF);
const Color kErrorFieldBorderColor = Color(0xFFF03E3E);
const Color kDefaultFieldFillColor = Color(0xFFFFFFFF);

// Button Colors
const Color kDefaultButtonColor = kPrimaryColor;
const Color kButtonHoverColor = kPrimaryColor;
const Color kButtonPassitiveColor = Color(0xff4eec6a);
const Color kButtonNegativeColor = Color(0xFFF03E3E);

// Border Colors
const Color kDefaultBorderColor = Color(0xFFE8E8E8);
const Color kPrimaryBorderColor = kPrimaryColor;

//Shadow Colors
const Color kShadowColor = Color(0x1A000000);

// Divider Color
const Color kDividerColor = Color(0xFF909090);

// Geometry Parameters
const EdgeInsetsGeometry kDefaultPadding = EdgeInsets.all(32.0);
const EdgeInsetsGeometry kSmallPadding = EdgeInsets.all(8.0);
const EdgeInsetsGeometry kLargePadding = EdgeInsets.all(24.0);
const EdgeInsetsGeometry kSmallMargin = EdgeInsets.all(4.0);
BorderRadius kDefaultBorderRadius = BorderRadius.circular(8.0);

// DateTime Formatters
final DateFormat defaultDateTimeFormat = DateFormat('dd-MM-yyyy HH:mm');
final DateFormat defaultDateFormat = DateFormat('dd-MM-yyyy');
