class ValidationUtils {
  static String? validateEmailOrPhone(String? value) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    final phoneRegex = RegExp(r'^\+97\d{8,13}$'); // Example: +97 followed by 8 to 13 digits

    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال البريد الإلكتروني أو رقم الجوال';
    } else if (!emailRegex.hasMatch(value) && !phoneRegex.hasMatch(value)) {
      // Custom error message for phone number format
      return 'صيغة البريد الإلكتروني / رقم الجوال غير صحيحة. \nرقم الجوال يجب أن يبدأ بمقدمة الواتساب.';
    }

    return null; // Input is valid
  }

  static bool isPasswordValid(String password) {
    if (password.length < 8) {
      return false;
    }
    return true;
  }

  static bool isConfirmedPasswordValid(
    String password,
    String confirmedPassword,
  ) {
    return password == confirmedPassword;
  }
}
