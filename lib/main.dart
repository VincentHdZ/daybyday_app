import 'package:daybyday_app/ui/pages/tabs_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'models/thing.dart';
import 'models/blocthings.dart';

import 'services/providers/things.dart';
import 'services/providers/blocsthings.dart';
import 'services/providers/auth.dart';

import 'ui/pages/blocthings_details_page.dart';
import 'ui/pages/thing_details_page.dart';
import 'ui/pages/auth_page.dart';
import 'ui/pages/blocthings_overview_page.dart';
import 'ui/pages/splash_screen.dart';

import 'utils/daybyday_theme_app.dart';
import 'utils/daybyday_resources.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
  runApp(DayByDayApp());
}

class DayByDayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, BlocsThings>(
          create: null,
          update: (ctx, auth, previousBlocsThings) => BlocsThings(
              auth.token,
              auth.userId,
              previousBlocsThings == null ? [] : previousBlocsThings.items),
        ),
        ChangeNotifierProxyProvider<Auth, Things>(
          create: (ctx) => null,
          update: (ctx, auth, previousThings) => Things(auth.token, auth.userId,
              previousThings == null ? [] : previousThings.items),
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
        allowFontScaling: false,
        builder: () => Consumer<Auth>(builder: (ctx, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: DayByDayRessources.textRessourceTitleApp,
            localizationsDelegates: [GlobalMaterialLocalizations.delegate],
            supportedLocales: [const Locale('en'), const Locale('fr')],
            home: auth.isAuth
                ? TabsPage()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (context, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthPage()),
            routes: {
              BlocThingsDetailsPage.routeName: (ctx) => BlocThingsDetailsPage(),
              ThingDetailsPage.routeName: (ctx) => ThingDetailsPage(),
              AuthPage.routeName: (ctx) => AuthPage(),
            },
            theme: DayByDayAppTheme.appTheme,
          );
        }),
      ),
    );
  }
}
