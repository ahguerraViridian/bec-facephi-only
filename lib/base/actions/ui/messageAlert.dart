import 'package:flutter/material.dart';

import '../../../base/state/allState.dart';

class XUIMessageAlert {
  String message;
  MessageAlertType type;
  MessageAlertColorType color;

  XUIMessageAlert({this.message = "", this.color, this.type});
}

//RS - Reset
class ResetMsgAlertAction {}

class XUIPopUpMessage {
  String message;
  BuildContext context;
  String code;
  Function onClose;
  Function onSecondButton;

  bool dismissible;
  bool boldMode;
  bool secondButtonBoldMode;
  bool useCustomContext;
  bool noButtons;
  String buttonMessage;
  String secondButtonMessage;

  XUIPopUpMessage({
    @required this.message,
    this.context,
    this.code,
    this.onClose,
    this.dismissible = true,
    this.boldMode = false,
    this.secondButtonBoldMode = false,
    this.useCustomContext = false,
    this.noButtons = false,
    this.buttonMessage,
    this.onSecondButton,
    this.secondButtonMessage,
  });
}

class XUIInformationDialog {
  String message;
  String title;
  String backMessage;
  String continueMessage;
  bool successCheck;
  bool dismissible;
  bool addPop;
  Function onContinue;
  Function onBack;
  BuildContext context;
  IconData continueIcon;
  IconData backIcon;

  XUIInformationDialog({
    this.message = "",
    this.context,
    this.successCheck,
    this.title,
    this.onContinue,
    this.onBack,
    this.continueMessage,
    this.backMessage,
    this.continueIcon,
    this.dismissible,
    this.backIcon,
    this.addPop = false,
  });
}

class XUIShowAnyModal {
  BuildContext context;
  Widget widget;
  bool dismissible;
  bool useSafeArea;
  bool useRootNavigator;

  XUIShowAnyModal({
    this.widget,
    this.dismissible,
    this.useRootNavigator,
    this.useSafeArea,
    this.context,
  });
}

class XUIShowExchangeRateModal {}
