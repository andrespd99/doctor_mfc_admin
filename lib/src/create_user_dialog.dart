import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/models/validators.dart';

import 'package:doctor_mfc_admin/services/database.dart';
import 'package:doctor_mfc_admin/widgets/custom_alert_dialog.dart';
import 'package:doctor_mfc_admin/widgets/future_loading_indicator.dart';
import 'package:flutter/material.dart';

class CreateUserDialog extends StatefulWidget {
  CreateUserDialog({Key? key}) : super(key: key);

  @override
  State<CreateUserDialog> createState() => _CreateUserDialogState();
}

class _CreateUserDialogState extends State<CreateUserDialog> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool? validName;
  bool? validEmail;
  bool? validPassword;
  bool? validConfirmPassword;

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      title: 'Create new user',
      showBackButton: false,
      body: [
        TextField(
          controller: nameController,
          onChanged: (value) => validateName(value),
          decoration: InputDecoration(
            labelText: 'First and Last name',
            errorText: (validName != null && validName != true)
                ? Validators.nameErrorMessage
                : null,
          ),
        ),
        SizedBox(height: kDefaultPadding),
        TextField(
          controller: emailController,
          onChanged: (value) => validateEmail(value),
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: (validEmail != null && validEmail != true)
                ? Validators.emailErrorMessage
                : null,
          ),
        ),
        SizedBox(height: kDefaultPadding),
        TextField(
          controller: passwordController,
          onChanged: (value) => validatePassword(value),
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: (validPassword != null && validPassword != true)
                ? Validators.passwordErrorMessage
                : null,
          ),
          obscureText: true,
        ),
        SizedBox(height: kDefaultPadding),
        TextField(
          controller: confirmPasswordController,
          onChanged: (value) => validateConfirmPassword(),
          decoration: InputDecoration(
            labelText: 'Confirm password',
            errorText:
                (validConfirmPassword != null && validConfirmPassword != true)
                    ? 'Passwords do not match'
                    : null,
          ),
          obscureText: true,
        ),
      ],
      finishButtonTitle: 'Create user',
      onFinish: () => onCreateUser(context),
      isButtonEnabled: inputsAreValid(),
    );
  }

  void validateName(String value) =>
      setState(() => validName = Validators.nameValidator.hasMatch(value));

  void validateEmail(String value) {
    return setState(
        () => validEmail = Validators.emailValidator.hasMatch(value));
  }

  void validatePassword(String value) {
    return setState(
      () => validPassword = Validators.passwordValidator.hasMatch(value),
    );
  }

  void validateConfirmPassword() {
    return setState(() {
      validConfirmPassword =
          confirmPasswordController.text == passwordController.text;
    });
  }

  /// Returns true if all input fields are valid and not empty.
  bool inputsAreValid() {
    if (nameController.text.isNotEmpty &&
        emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty &&
        validEmail == true &&
        validName == true &&
        validPassword == true &&
        validConfirmPassword == true) {
      return true;
    } else
      return false;
  }

  void onCreateUser(BuildContext context) {
    assert(inputsAreValid() == true);

    futureLoadingIndicator(
      context,
      Database().createUser(
        userName: nameController.text,
        userEmail: emailController.text,
        password: passwordController.text,
      ),
    ).then((value) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User created successfully')),
      );
    });
  }
}
