/// String validators for text inputs of different types.
class Validators {
  /// Checks if the input is a valid email address.
  static final emailValidator = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  static final String emailErrorMessage = "Invalid email address";

  /// Checks if the input is a valid name.
  static final RegExp nameValidator = RegExp(r'^[a-zA-Z ]+$');
  static final String nameErrorMessage =
      "Invalid name. Name must contain only letters";

  /// Checks if the input is a valid password.
  static final RegExp passwordValidator =
      RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
  static final String passwordErrorMessage =
      "Password must be at least 8 characters long, contain at least one uppercase letter, one lowercase letter, one number and one special character";
}
