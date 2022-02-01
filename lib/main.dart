import 'dart:io';

import 'runAppMethod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'appSpectorConfig.dart';
import 'clientConfig.dart';
import 'app.dart' as app;
import 'themes/appThemes.dart';
import 'utils/allUtils.dart';
import 'config/config.dart';

void main() async {
  Config.appFlavor = Flavor.DEV;
  Config.appClient = appClient;
  Config.iOSAppID = iOSAppID;
  AppThemes.setStatusBarColor();

  HttpOverrides.global =
      new HttpOverridesCustom(); // Override the certificates for https
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  /// END
  runAppSpector(Config.appFlavor);
  runAppMethod(() {
    runApp(
      app.App(),
    );
  });
}
