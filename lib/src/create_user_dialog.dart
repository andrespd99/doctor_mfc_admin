import 'package:doctor_mfc_admin/constants.dart';

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

  String? emailFieldError;
  String? nameFieldError;
  String? passwordFieldError;
  String? confirmPasswordFieldError;

  @override
  Widget build(BuildContext context) {
    return CustomAlertDialog(
      title: 'Create new user',
      showBackButton: false,
      body: [
        TextField(
          controller: nameController,
          decoration: InputDecoration(
            labelText: 'First and Last name',
            errorText: nameFieldError,
          ),
        ),
        SizedBox(height: kDefaultPadding),
        TextField(
          controller: emailController,
          decoration:
              InputDecoration(labelText: 'Email', errorText: emailFieldError),
        ),
        SizedBox(height: kDefaultPadding),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: passwordFieldError,
          ),
          obscureText: true,
        ),
        SizedBox(height: kDefaultPadding),
        TextField(
          controller: confirmPasswordController,
          decoration: InputDecoration(
            labelText: 'Confirm password',
            errorText: confirmPasswordFieldError,
          ),
          obscureText: true,
        ),
      ],
      finishButtonTitle: 'Create user',
      onFinish: () => onCreateUser(context),
    );
  }

  void onCreateUser(BuildContext context) {
    bool isValid = true;
    setState(() {
      emailFieldError = null;
      nameFieldError = null;
      passwordFieldError = null;
      confirmPasswordFieldError = null;
    });

    if (passwordController.text != confirmPasswordController.text) {
      isValid = false;
      setState(() {
        confirmPasswordFieldError = 'Passwords do not match';
      });
    }
    if (emailController.text.isEmpty) {
      isValid = false;
      setState(() {
        emailFieldError = 'Email is required';
      });
    }
    if (nameController.text.isEmpty) {
      isValid = false;
      setState(() {
        nameFieldError = 'Name is required';
      });
    }
    if (passwordController.text.isEmpty) {
      isValid = false;
      setState(() {
        passwordFieldError = 'Password is required';
      });
    }
    if (isValid) {
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
}
