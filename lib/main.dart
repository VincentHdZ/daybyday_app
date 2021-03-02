import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'models/thing.dart';
import 'models/blocthings.dart';

import 'services/providers/things.dart';
import 'services/providers/blocsthings.dart';

import 'ui/pages/blocthings_details_page.dart';
import 'ui/pages/blocthings_overview_page.dart';
import 'ui/pages/thing_details_page.dart';

import 'utils/daybyday_theme_app.dart';
import 'utils/daybyday_resources.dart';

void main() => runApp(DayByDayApp());

class DayByDayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => BlocsThings(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Things(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => BlocThings(),
        ),
                ChangeNotifierProvider(
          create: (ctx) => Thing(),
        ),
      ],
      child: ScreenUtilInit(
        // Iphone 11 1792 * 828
        designSize: Size(828, 1792),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: DayByDayRessources.textRessourceTitleApp,
          localizationsDelegates: [GlobalMaterialLocalizations.delegate],
          supportedLocales: [const Locale('en'), const Locale('fr')],
          routes: {
            "/": (context) => BlocThingsOverviewPage(),
            BlocThingsDetailsPage.routeName: (context) => BlocThingsDetailsPage(),
            ThingDetailsPage.routeName: (context) => ThingDetailsPage(),
          },
          theme: DayByDayAppTheme.appTheme,
        ),
      ),
    );
  }
}
