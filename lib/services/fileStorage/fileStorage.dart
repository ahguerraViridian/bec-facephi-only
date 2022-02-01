import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../base/actions/allActions.dart';

import '../../base/state/allState.dart';
import 'package:redux/redux.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
// import 'package:baneco_tools/simple_permissions.dart' as sp;

class FileStorage {
  static Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  // Future<File> get _localFile async {
  //   final path = await _localPath;
  //   return File('$path/counter.txt');
  // }

  static void saveImage(ByteData byteData, String name, Store<AppState> store,
      {Function(String) onSuccess, Function(dynamic) onError}) async {
    try {
      // PermissionStatus futureResultRead =
      //     await Permission.manageExternalStorage.request();
      await Permission.storage.request();

      await Permission.manageExternalStorage.request();
      // await sp.SimplePermissions.requestPermission(
      //     sp.Permission.WriteExternalStorage);

      try {
        Uint8List bytes = byteData.buffer.asUint8List();

        File file = File("/storage/emulated/0/Download/" + "$name" + ".jpg");
        // File fileResult =
        await file.writeAsBytes(bytes);
        if (onSuccess != null) onSuccess("Imagen guardada correctamente");
        store.dispatch(XUIInformationDialog(
    
          message: "Imagen guardada correctamente",
          title: "Operación realizada exitósamente",
          onContinue: () {
            dynamic storeContext =
                store.state.navigatorKey.currentState.overlay.context;
            Navigator.of(storeContext).pop();
          },
          successCheck: true,
          continueMessage: "Cerrar",
          dismissible: true,
        ));
      } catch (e) {
        if (onError != null) onError(e);
        store.dispatch(XUIPopUpMessage(
            message: 'Algo salió mal al intentar guardar\n\n$e'));
      }
    } catch (e) {
      if (onError != null) onError(e);
      store.dispatch(
          XUIPopUpMessage(message: 'Algo salió mal al intentar guardar\n\n$e'));
    }
  }

  static void saveImageInGallery(
      ByteData byteData, String name, Store<AppState> store,
      {Function(String) onSuccess, Function(dynamic) onError}) async {
    try {
      await Permission.storage.request();

      await Permission.manageExternalStorage.request();

      try {
        Uint8List bytes = byteData.buffer.asUint8List();
        dynamic result = await ImageGallerySaver.saveImage(bytes,
            quality: 90, name: "$name");

        if (result["isSuccess"] != null) if (result["isSuccess"]
            is bool) if ((result["isSuccess"] as bool) && onSuccess != null)
          onSuccess("Imagen guardada correctamente");
        store.dispatch(XUIInformationDialog(
          message: "Imagen guardada correctamente",
          title: "Operación realizada exitósamente",
          onContinue: () {
            dynamic storeContext =
                store.state.navigatorKey.currentState.overlay.context;
            Navigator.of(storeContext).pop();
          },
          successCheck: true,
          continueMessage: "Cerrar",
          dismissible: true,
        ));

        if (result["errorMessage"] != null && result["errorMessage"] != "")
          store.dispatch(XUIPopUpMessage(
              message:
                  'Algo salió mal al intentar guardar\n\n${result["errorMessage"]}'));
      } catch (e) {
        if (onError != null) onError(e);
        store.dispatch(XUIPopUpMessage(
            message: 'Algo salió mal al intentar guardar\n\n$e'));
      }
    } catch (e) {
      if (onError != null) onError(e);
      store.dispatch(
          XUIPopUpMessage(message: 'Algo salió mal al intentar guardar\n\n$e'));
    }
  }

  static Future<File> _getLocalFile(String fileName) async {
    final path = await _localPath;
    return File('$path/$fileName');
  }

  static Future<String> readFileContents(String fileName,
      {Function(dynamic) onError}) async {
    try {
      final file = await _getLocalFile(fileName);

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      if (onError != null) onError(e);
      // If encountering an error, return 0
      return "";
    }
  }

  static Future<File> writeContent(String fileName, String content) async {
    final file = await _getLocalFile(fileName);

    // Write the file
    return file.writeAsString(content);
  }
}
