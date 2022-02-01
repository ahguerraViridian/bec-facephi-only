import 'dart:typed_data';

import 'package:flutter/material.dart';

class SelphIDImage extends StatelessWidget {
  SelphIDImage(
    this._image,
    this._heightScreenPercentage,
    this._widthScreenPercentage,
    this.placeHolderWidget,
  );

  final Uint8List _image;
  final double _heightScreenPercentage;
  final double _widthScreenPercentage;
  final Widget placeHolderWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(children: <Widget>[
        Spacer(flex: 1),
        _image != null
            ? Expanded(
                flex: 9,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height *
                      _heightScreenPercentage,
                  width: MediaQuery.of(context).size.width *
                      _widthScreenPercentage,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.contain, image: MemoryImage(_image)),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: Theme.of(context).primaryColorLight,
                    ),
                  ),
                ),
              )
            : Expanded(
                flex: 9,
                child: SizedBox(
                    height: MediaQuery.of(context).size.height *
                        _heightScreenPercentage,
                    width: MediaQuery.of(context).size.width *
                        _widthScreenPercentage,
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          color: Theme.of(context).primaryColorLight),
                      child: placeHolderWidget,
                    )),
              ),
        Spacer(flex: 1)
      ]),
    );
  }
}
