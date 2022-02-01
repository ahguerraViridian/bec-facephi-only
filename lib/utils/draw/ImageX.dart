import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:ui' as ui show Image;

import 'package:flutter/services.dart';

class ImageX {
  ImageX(AssetBundle bundle) : _bundle = bundle;
  final AssetBundle _bundle;
  final Map<String, ui.Image> _images = new Map<String, ui.Image>();
  Future<ui.Image> loadImage(String url) async {
    ImageStream stream =
        new AssetImage(url, bundle: _bundle).resolve(ImageConfiguration.empty);
    Completer<ui.Image> completer = new Completer<ui.Image>();
    ImageStreamListener listener =
        ImageStreamListener((ImageInfo frame, bool synchronousCall) {
      final ui.Image image = frame.image;
      _images[url] = image;
      completer.complete(image);
      //stream.removeListener(listener);
    });

    stream.addListener(listener);
    return completer.future;
  }
}
