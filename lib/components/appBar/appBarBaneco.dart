import '../../config/config.dart';
import '../../themes/additionalThemeFeatures.dart';
import 'package:flutter/material.dart';

import 'appBarStoreWidget.dart';

class AppBarBaneco {
  // @override
  static Widget buildAppBar({
    BuildContext context,
    String imgAsset = "",
    Widget bottom,
    Function onPop,
    bool addLeading = true,
    double elevation = 4,
  }) {
    return PreferredSize(
      preferredSize: Size.fromHeight(56.0),
      child: StandardAppBar(
        addLeading: addLeading,
        bottom: bottom,
        elevation: elevation,
        imgAsset: imgAsset,
        onPop: onPop,
      ),
    );
  }

  static Widget buildOnboardingAppBar({
    BuildContext context,
    String bankName = "",
    Widget bottom,
    Function onPop,
    bool addLeading = true,
    bool exitButton = false,
    Function onExit,
  }) {
    return AppBar(
      foregroundColor: Theme.of(context).primaryColorLight,
      actions: exitButton
          ? [
              IconButton(
                icon: Icon(Icons.exit_to_app),
                tooltip: null,
                onPressed: () {
                  if (onExit != null) onExit();
                },
              )
            ]
          : [Container()],
      leading: onPop != null
          ? IconButton(
              icon: Icon(Icons.arrow_back),
              tooltip: null,
              onPressed: onPop,
            )
          : addLeading
              ? null
              : Container(),
      title: bankName.contains("BANCO ECONOMICO")
          ? Image.asset(
              "assets/allContent/banklogo${Config.getFileExt(false)}.png",
              fit: BoxFit.contain,
              height: 17.0,
            )
          : Text(
              bankName,
              style: TextStyle(
                  color: Theme.of(context).primaryColorLight,
                  fontWeight: FontWeight.w600,
                  fontSize: 17),
            ),
      centerTitle: true,
      bottom: bottom,
    );
  }
}
