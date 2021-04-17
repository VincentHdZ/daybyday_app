import 'package:flutter/material.dart';

import '../../utils/daybyday_resources.dart';
import '../../utils/daybyday_theme_app.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DayByDayAppTheme.accentColor,
      body: Container(
        child: Center(
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
    );
  }
}
