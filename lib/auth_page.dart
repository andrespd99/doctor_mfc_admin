import 'package:doctor_mfc_admin/constants.dart';
import 'package:doctor_mfc_admin/services/mfc_auth_service.dart';
import 'package:doctor_mfc_admin/src/index_page.dart';
import 'package:doctor_mfc_admin/src/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Provider.of<MFCAuthService>(context).userStream(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return Container(
            padding: EdgeInsets.only(
              top: 100,
              left: MediaQuery.of(context).size.width * 0.333,
              right: kDefaultPadding * 2,
              bottom: kDefaultPadding * 2,
            ),
            decoration: BoxDecoration(
              gradient: kRadialPrimaryBg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/no-connection-white.png',
                        height: 75,
                      ),
                      SizedBox(height: kDefaultPadding * 2),
                      Text('No connection.'),
                      TextButton(
                        onPressed: () => setState(() {}),
                        child: Text('Try again'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          // If user is null, it means it's not logged in.
          bool isLoggedIn = snapshot.hasData;
          if (isLoggedIn) {
            return IndexPage();
          } else {
            return LoginPage();
          }
        }
      },
    );
  }
}
