import 'package:flutter/material.dart';

import '../../utils/daybyday_theme_app.dart';
import '../../utils/daybyday_resources.dart';

import '../../ui/widgets/auth_signin.dart';
import '../../ui/widgets/auth_signup.dart';

class AuthPage extends StatefulWidget {
  static final String routeName = "/auth";
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool _signIn = true;
  void _setAuthMode() {
    setState(() {
      _signIn = !_signIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: DayByDayAppTheme.accentColor,
      body: Stack(children: [
        Padding(
          padding: EdgeInsets.only(top: 50.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              DayByDayRessources.textTitleAuthScreen,
              style: TextStyle(
                color: Colors.white,
                fontSize: 50,
                fontWeight: FontWeight.bold,
                fontFamily: "DancingScript",
              ),
            ),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child:
                  _signIn ? AuthSignIn(_setAuthMode) : AuthSignUp(_setAuthMode),
            ),
          ],
        ),
      ]),
    );
  }
}
