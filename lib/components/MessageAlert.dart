import 'package:flutter/material.dart';
import '../base/state/allState.dart';

class MessageAlert {
  MessageAlertState state;
  MessageAlert({this.state});

  Widget build() {
    switch (state.type) {
      case MessageAlertType.SNACKBAR:
        break;
      case MessageAlertType.TOAST:
        break;
      case MessageAlertType.TOASTBAR:
        break;
    }
    return buildSnackBar();
  }

  Widget buildSnackBar() {
    return new SnackBar(
        backgroundColor: new Color(0xff595353),
        duration: Duration(seconds: 4),
        content: new Text(
          state.message,
          style: new TextStyle(color: Colors.white, fontSize: 16.0),
        ));
  }

  Widget buildToast() {
    return Container();
  }

  Widget buildToastBar() {
    return Container();
  }

  Color getColorType() {
    Color cl;
    switch (state.color) {
      case MessageAlertColorType.PRIMARY:
        cl = new Color(0xffcce5ff);
        break;
      case MessageAlertColorType.SECONDARY:
        cl = new Color(0xffe2e3e5);
        break;
      case MessageAlertColorType.SUCCESS:
        cl = Colors.greenAccent;
        break;
      case MessageAlertColorType.WARNING:
        cl = new Color(0xfffff3cd);
        break;
      case MessageAlertColorType.INFO:
        cl = new Color(0xffd1ecf1);
        break;
      case MessageAlertColorType.LIGHT:
        cl = new Color(0xfffefefe);
        break;
      case MessageAlertColorType.DANGER:
        cl = Colors.redAccent;
        break;
      case MessageAlertColorType.DARK:
        cl = new Color(0xffd6d8d9);
        break;
    }
    return cl;
  }
}
