// import 'package:sentry_flutter/sentry_flutter.dart';

bool get isInDebugMode {
  // Assume you're in production mode.
  bool inDebugMode = false;

  // Assert expressions are only evaluated during development. They are ignored
  // in production. Therefore, this code only sets `inDebugMode` to true
  // in a development environment.
  assert(inDebugMode = true);

  return inDebugMode;
}

Future<void> reportError(dynamic error, dynamic stackTrace) async {
  // Print the exception to the console.
  print('Caught error: $error');
  // if (isInDebugMode) {
  // Print the full stacktrace in debug mode.
  // print(stackTrace);
  // } else {
  //   // Send the Exception and Stacktrace to Sentry in Production mode.
  // bool areCommonErrors = false;
  // if (!areCommonErrors) {
  //   await Sentry.captureException(
  //     error,
  //     stackTrace: stackTrace,
  //   );
  // }
  // }
}
