import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/widgets/powered_by_takeoff.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double formWidth = 340.0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
            SizedBox(height: kDefaultPadding * 2),
            loginButton(),
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
              Navigator.popAndPushNamed(context, 'home');
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
}
