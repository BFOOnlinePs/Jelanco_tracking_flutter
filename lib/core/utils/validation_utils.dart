class ValidationUtils {
  static bool isEmailValid(String email) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
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
    return password == confirmedPassword ;
  }
}