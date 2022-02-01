import 'appBarVM.dart';

import '../../components/flavors/flavorTag.dart';
import '../../themes/additionalThemeFeatures.dart';
import '../../utils/allUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import '../../base/state/appState.dart';

class StandardAppBar extends StatefulWidget {
  final double elevation;
  final Function onPop;
  final bool addLeading;
  final String imgAsset;
  final Widget bottom;
  StandardAppBar({
    this.addLeading,
    this.onPop,
    this.bottom,
    this.elevation,
    this.imgAsset,
  });

  @override
  _StandardAppBarState createState() => _StandardAppBarState();
}

class _StandardAppBarState extends State<StandardAppBar> {
  final Size size = Size.fromHeight(57.0);
  ImageProvider<Object> backgroundImage;
  Color backgroundColor;

  @override
  void initState() {
    super.initState();

    backgroundImage = AssetImage("assets/allContent/banklogo_baneco.png");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, AppBarVM>(
        distinct: true,
        converter: AppBarVM.fromStore,
        builder: (BuildContext context, AppBarVM vm) {
          DynamicLog.devPrint("////////--> StoreConnector - StandardAppBar");
          backgroundColor = Theme.of(context).primaryColor;
          return AppBar(
            foregroundColor: Theme.of(context).primaryColorLight,
            leading: widget.onPop != null
                ? IconButton(
                    icon: Icon(Icons.arrow_back),
                    tooltip: null,
                    onPressed: widget.onPop,
                    color: Theme.of(context).primaryColorLight,
                  )
                : widget.addLeading
                    ? null
                    : Container(),
            elevation: widget.elevation,
            title:
                // ClientHandler.dynamicClientWidget(
                //   defaultWidget: Image.asset(
                //     imgAsset,
                //     fit: BoxFit.contain,
                //     height: ClientHandler.dynamicClientValue(
                //             defaultValue: 17.0, bancoSol: 20.0)
                //         .toDouble(),
                //   ),
                //   bancoSol: Container(),
                // ),
                Container(
              child: Stack(
                alignment: AlignmentDirectional.topEnd,
                children: [
                  Image.asset(
                    widget.imgAsset,
                    fit: BoxFit.contain,
                    height: 17.0.toDouble(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 00),
                    child: FlavorTag(
                      fontSize: 8,
                    ),
                  ),
                  // Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  //   // SizedBox(width: 30,),
                  //   FlavorTag(
                  //     fontSize: 10,
                  //   )
                  // ]),
                ],
              ),
            ),
            flexibleSpace: Container(),
            centerTitle: true,
            bottom: widget.bottom,
            // actions: [
            //   vm.exchangeRateList.exchangeRateList.isEmpty
            //       ? Container()
            //       : InkWell(
            //           onTap: () {
            //             vm.onExchangeRateTap();
            //           },
            //           child: Container(
            //               margin: EdgeInsets.only(right: 15),

            //               // decoration: BoxDecoration(
            //               //     color: Theme.of(context).primaryColorLight,
            //               //     border: Border.all(
            //               //       color: Theme.of(context).primaryColorLight,
            //               //     ),
            //               //     borderRadius:
            //               //         BorderRadius.all(Radius.circular(5))),
            //               child: Icon(
            //                 BanecoIcons.exchange_rate,
            //                 size: 40,
            //               )),
            //         ),
            // ],
          );
        });
  }
}
