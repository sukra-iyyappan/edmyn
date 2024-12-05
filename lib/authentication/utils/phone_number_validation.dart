class PhoneValidator {
  static String? validate(String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter your phone number';
    } else if (!isPhoneNumber(val)) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  static bool isPhoneNumber(String input) {
    // Assuming phone numbers are 10 digits long
    String phonePattern = r'^\d{10}$';
    return RegExp(phonePattern).hasMatch(input);
  }
}
