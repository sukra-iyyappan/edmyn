class PasswordValidator {
  static String? validate(String? val) {
    if (val == null || val.isEmpty) {
      return 'Please enter your password';
    } else if (val.length < 8 || val.length > 20) {
      return 'Password must be 8-20 characters long';
    } else if (!RegExp(r'(?=.*[A-Z])').hasMatch(val)) {
      return 'Password must contain at least one uppercase letter';
    } else if (!RegExp(r'(?=.*[a-z])').hasMatch(val)) {
      return 'Password must contain at least one lowercase letter';
    } else if (!RegExp(r'(?=.*\d)').hasMatch(val)) {
      return 'Password must contain at least one number';
    } else if (!RegExp(r'(?=.*[\$@*#-])').hasMatch(val)) {
      return 'Password must contain at least one special character: \$,@,*#-';
    }
    return null;
  }
}
