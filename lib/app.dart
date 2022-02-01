import 'dart:async';
import 'sentryConfig.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter/cupertino.dart';
import 'base/actions/allActions.dart';
import 'base/state/appState.dart';
import 'base/reducers/appReducers.dart';
import 'base/middlewares/middlewares.dart';
import 'config/config.dart';
import 'delegates/cupertino.dart';
import 'services/services.dart';
import 'utils/allUtils.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  _init() async {
    // Case 1: App is already running in background:
    // Listen to lifecycle changes to subsequently call Java MethodHandler to check for shared data

    SystemChannels.lifecycle.setMessageHandler((msg) {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  didUpdateWidget(dynamic oldWIdget) {
    super.didUpdateWidget(oldWIdget);
  }

  Widget getErrorWidget(FlutterErrorDetails error) {
    return Container(
        child: Center(
      child: Text("Error"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // if (Config.appFlavor == Flavor.PROD) {
    FlutterError.onError = (FlutterErrorDetails details) async {
      print("$details");
      String typeAheadError =
          "RenderBox.size accessed beyond the scope of resize, layout, or permitted parent access. R";
    };
    // }

    ErrorWidget.builder = getErrorWidget;
    store.state.config.setPlatform(
        Theme.of(context).platform == TargetPlatform.iOS ? "ios" : "android");

    Services.init(store);
    return RawGestureDetector(
        gestures: {
          AllowMultipleGestureRecognizer: GestureRecognizerFactoryWithHandlers<
              AllowMultipleGestureRecognizer>(
            () => AllowMultipleGestureRecognizer(),
            (AllowMultipleGestureRecognizer instance) {
              instance.onTap = () {};
            },
          )
        },
        child: StoreProvider(
          store: store,
          child: new MaterialApp(
            title: "Banco Economico",
            theme: store.state.config.theme.copyWith(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      background: Theme.of(context).bottomAppBarColor,
                      // background:Colors.purple,
                      onBackground: Theme.of(context).bottomAppBarColor,
                      // onBackground:Colors.purple,
                      primary: store.state.config.theme.primaryColor,
                      onPrimary: store.state.config.theme.primaryColor,
                      primaryVariant: store.state.config.theme.primaryColor,
                      brightness: Brightness.light,
                    ),
                appBarTheme: Theme.of(context).appBarTheme.copyWith(
                      brightness: Brightness.dark,
                    )),
            navigatorKey: store.state.navigatorKey,
            supportedLocales: [
              const Locale('en', 'US'), // American English
              const Locale('es', 'ES'), // Spanish
              // ...
            ],
            localizationsDelegates: [
              // ... app-specific localization delegate[s] here

              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              DefaultCupertinoLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              const FallbackCupertinoLocalisationsDelegate(),
            ],
            debugShowCheckedModeBanner: false,
            home: store.state.navigation.getInitialRoute(
              ios: Theme.of(context).platform == TargetPlatform.iOS,
            ),
          ),
        ));
  }
}

Store<AppState> store = new Store<AppState>(
    //Store for the application Redux
    appReducer, //reducers
    initialState: AppState.loading(),
    middleware: createMiddlewares());

class AllowMultipleGestureRecognizer extends TapGestureRecognizer {
  @override
  void rejectGesture(int pointer) {
    try {
      acceptGesture(pointer);
    } catch (e) {
      DynamicLog.devPrint("$e");
    }
  }
}
