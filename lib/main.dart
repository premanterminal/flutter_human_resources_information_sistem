import 'dart:io';
import 'package:flutter_human_resources_information_sistem/Theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_human_resources_information_sistem/ScreenHome/navigation_home_screen.dart';
// import 'fitness_app/my_diary/my_diary_screen.dart';
// import 'fitness_app/fitness_app_home_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_human_resources_information_sistem/Auth/splashscreen.dart';
//import 'package:flutter_human_resources_information_sistem/OldHRIS/splashscreen.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown
  // ]).then((_) => runApp(MyApp()));
  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://dd455b9250a34b028fa2675841b8945a@o818477.ingest.sentry.io/5852381';
    },
    appRunner: () => runApp(MyApp()),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      title: 'HRIS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: AppTheme.textTheme,
        platform: TargetPlatform.iOS,
      ),
      //home: NavigationHomeScreen(),
      home: Splashscreen(),
      //home: FitnessAppHomeScreen(),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
