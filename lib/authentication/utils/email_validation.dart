class EmailValidator {
  static String? validate(String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
      return 'You have entered an incorrect email';
    }
    return null;
  }

  static bool isEmail(String input) {
    String emailPattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    return RegExp(emailPattern).hasMatch(input);
  }
}
