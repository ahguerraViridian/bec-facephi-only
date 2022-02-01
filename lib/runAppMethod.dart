// import 'dart:async';

// import 'package:sentry_flutter/sentry_flutter.dart';

// import 'clientConfig.dart';
// import 'sentryConfig.dart';

void runAppMethod(Function runAppMethod) async {
  // await SentryFlutter.init((options) {
  //   options.dsn = sentryDSN;
  // },
  //     appRunner: () => runZoned<Future<void>>(() async {
  runAppMethod();
  // }, onError: (error, stackTrace) {

  //   reportError(error, stackTrace);
  // }));
}
