class ValidationUtils {
  static String? validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال إسم الموظف';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (value != null && value.isNotEmpty && !emailRegex.hasMatch(value)) {
      return 'صيغة البريد الإلكتروني غير صحيحة';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    final phoneRegex = RegExp(r'^\d{10}$');
    if (value != null && value.isNotEmpty && !phoneRegex.hasMatch(value)) {
      return 'صيغة رقم الجوال غير صحيحة';
    }
    return null;
  }

  static String? validateEmailOrPhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال البريد الإلكتروني أو رقم الجوال';
    }

    final emailValidationResult = validateEmail(value);
    if (emailValidationResult == null) {
      return null;
    }

    final phoneValidationResult = validatePhone(value);
    if (phoneValidationResult == null) {
      return null;
    }

    return 'صيغة البريد الإلكتروني / رقم الجوال غير صحيحة.';
  }

  // static String? validateEmailOrPhone(String? value) {
  //   final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
  //   final phoneRegex = RegExp(r'^\d{10}$'); // Example:
  //   if (value == null || value.isEmpty) {
  //     return 'الرجاء إدخال البريد الإلكتروني أو رقم الجوال';
  //   } else if (!emailRegex.hasMatch(value) && !phoneRegex.hasMatch(value)) {
  //     return 'صيغة البريد الإلكتروني / رقم الجوال غير صحيحة.';
  //   }
  //
  //   return null; // Input is valid
  // }

  static bool isPasswordValid(String password) {
    if (password.length < 8) {
      return false;
    }
    return true;
  }
//
// static bool isConfirmedPasswordValid(
//   String password,
//   String confirmedPassword,
// ) {
//   return password == confirmedPassword;
// }
}
