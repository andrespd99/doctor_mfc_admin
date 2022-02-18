import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/services/mfc_auth_service.dart';
import 'package:doctor_mfc_admin/widgets/custom_loading_indicator.dart';
import 'package:doctor_mfc_admin/widgets/powered_by_takeoff.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// PortView dimensions.
  late final size = MediaQuery.of(context).size;

  /// Material text theme
  late final textTheme = Theme.of(context).textTheme;

  /// Controller for the email field
  final emailController = TextEditingController();

  /// Controller for the password field
  final passwordController = TextEditingController();

  /// Widgets for the email and password fields.
  double formWidth = 340.0;

  /// Set to `true` when the authentication is in progress, `false` otherwise.
  bool isLoading = false;

  /// Error message to display when the authentication fails.
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(brightness: Brightness.dark),
      child: Container(
        padding: EdgeInsets.only(
          top: 100,
          left: size.width * 0.333,
          right: kDefaultPadding * 2,
          bottom: kDefaultPadding * 2,
        ),
        decoration: BoxDecoration(
          gradient: kRadialPrimaryBg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(),
            SizedBox(height: kDefaultPadding * 4),
            emailInput(),
            SizedBox(height: kDefaultPadding),
            passwordInput(),
            SizedBox(height: kDefaultPadding),
            if (errorMessage != null) errorMessageWidget(),
            SizedBox(height: kDefaultPadding),
            // If is loading, show the loading indicator, otherwise show the login button.
            isLoading
                ? Container(
                    width: formWidth,
                    child: Center(child: CustomLoadingIndicator()),
                  )
                : loginButton(),
            Spacer(),
            poweredByTakeoff()
          ],
        ),
      ),
    );
  }

  Widget poweredByTakeoff() {
    return Row(
      children: [
        Spacer(),
        PoweredByTakeoffWidget(),
      ],
    );
  }

  Container loginButton() {
    return Container(
      width: formWidth,
      child: Row(
        children: [
          Spacer(),
          ElevatedButton(
            onPressed: () {
              // When authentication is in progress, set `isLoading` to `true`.
              setState(() => isLoading = true);
              Provider.of<MFCAuthService>(context, listen: false)
                  .signInWithEmailAndPassword(
                emailController.text,
                passwordController.text,
              )
                  .then((errorMessage) {
                setState(() => isLoading = false);
                if (errorMessage != null) {
                  setState(() => this.errorMessage = errorMessage);
                }
              });
              // When completed, set `isLoading` back to `false`.
            },
            child: Text('Log in'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(
                  horizontal: kDefaultPadding * 1.5, vertical: kDefaultPadding),
              primary: kAccentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget emailInput() {
    return Container(
      width: formWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Email or username',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: kDefaultPadding / 3),
          TextField(
            enabled: !isLoading,
            controller: emailController,
            decoration: InputDecoration(
              hintText: 'email@takeoff.com',
              hintStyle: TextStyle(
                color: kFontWhite.withOpacity(0.4),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                borderSide: BorderSide(
                  width: 1.5,
                  color: Colors.white,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                borderSide: BorderSide(
                  width: 1.5,
                  color: kSecondaryLightColor,
                ),
              ),
            ),
            cursorColor: kSecondaryLightColor,
            style: TextStyle(
              color: kFontWhite,
            ),
          ),
        ],
      ),
    );
  }

  Widget passwordInput() {
    return Container(
      width: formWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          SizedBox(height: kDefaultPadding / 3),
          TextField(
            enabled: !isLoading,
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintStyle: TextStyle(
                color: kFontWhite.withOpacity(0.4),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                borderSide: BorderSide(
                  width: 1.5,
                  color: Colors.white,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                borderSide: BorderSide(
                  width: 1.5,
                  color: kSecondaryLightColor,
                ),
              ),
            ),
            cursorColor: kSecondaryLightColor,
            style: TextStyle(
              color: kFontWhite,
            ),
          ),
        ],
      ),
    );
  }

  Row header() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Login',
          style: Theme.of(context)
              .textTheme
              .headline2
              ?.copyWith(color: kFontWhite),
        ),
        SizedBox(width: kDefaultPadding / 2),
        Container(
          color: kFontWhite.withOpacity(0.15),
          width: 4.0,
          height: 20,
        ),
        SizedBox(width: kDefaultPadding / 2),
        Text(
          'ADMIN',
          style: Theme.of(context)
              .textTheme
              .headline2
              ?.apply(color: kSecondaryLightColor),
        ),
      ],
    );
  }

  Widget errorMessageWidget() {
    assert(errorMessage != null);
    return Container(
      width: formWidth,
      padding: EdgeInsets.symmetric(
          horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultBorderRadius),
        color: Colors.red.shade100,
        // border: Border.all(width: .5, color: Colors.red),
        boxShadow: [
          BoxShadow(
            offset: Offset(3, 3),
            color: Colors.red.withOpacity(0.30),
            blurRadius: 5.0,
          ),
        ],
      ),
      child: Text(
        errorMessage!,
        textAlign: TextAlign.center,
        style: textTheme.bodyText1?.copyWith(color: Colors.red),
      ),
    );
  }
}
