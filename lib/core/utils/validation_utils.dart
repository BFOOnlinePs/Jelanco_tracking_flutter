class ValidationUtils {
  static String? validateEmailOrPhone(String? value) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    final phoneRegex = RegExp(r'^\d{10}$'); // Example:
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال البريد الإلكتروني أو رقم الجوال';
    } else if (!emailRegex.hasMatch(value) && !phoneRegex.hasMatch(value)) {
      return 'صيغة البريد الإلكتروني / رقم الجوال غير صحيحة.';
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
