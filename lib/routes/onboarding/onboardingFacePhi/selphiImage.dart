import 'dart:typed_data';

import 'package:flutter/material.dart';

class SelphiImage extends StatelessWidget {
  SelphiImage(this._bestImage, this.placeHolderWidget);

  final Uint8List _bestImage;
  final Widget placeHolderWidget;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _bestImage != null
          ? SizedBox(
              height: MediaQuery.of(context).size.height * 0.20,
              width: MediaQuery.of(context).size.height * 0.20,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fitHeight, image: MemoryImage(_bestImage)),
                      
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: Theme.of(context).primaryColorLight,
                ),
              ),
            )
          : SizedBox(
              height: MediaQuery.of(context).size.height * 0.20,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  color: Theme.of(context).primaryColorLight,
                ),
                child: placeHolderWidget,
              )),
    );
  }
}
