import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import '../../utils/allUtils.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../../base/state/allState.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

import '../../base/enums/allEnums.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:exif/exif.dart';
import 'package:image/image.dart' as img;
import 'package:image_crop/image_crop.dart';

class ImagesService {
  static void cropImage(
      {@required String path,
      Function onSuccess,
      Function(dynamic) onError,
      Function onIOS,
      @required CameraMaskType maskType}) async {
    // if (!Platform.isIOS) {
    try {
      ImageProperties properties =
          await FlutterNativeImage.getImageProperties(path);
      List<int> bytes = await File(path).readAsBytes();
      Map<String, IfdTag> exifData = await readExifFromBytes(bytes);
      // final options = await getImageOptions(file: file);
      // debugPrint('image width: ${options.width}, height: ${options.height}');

      int originalImageWidth = properties.width;
      int originalImageHeight = properties.height;

      if (properties.width == 0 ||
          properties.height == 0 ||
          properties.width == null ||
          properties.height == null) {
        originalImageWidth =
            int.parse(exifData["EXIF ExifImageWidth"].printable);
        originalImageHeight =
            int.parse(exifData["EXIF ExifImageLength"].printable);
      }

      int originX = originalImageWidth < originalImageHeight
          ? (originalImageWidth * 0.0375).round()
          : ((originalImageWidth / 2) -
                  ((originalImageHeight / 2) - originalImageHeight * 0.0375))
              .round();
      int originY = originalImageWidth < originalImageHeight
          ? ((originalImageHeight / 2) -
                  ((originalImageWidth / 2) - originalImageWidth * 0.0375))
              .round()
          : (originalImageHeight * 0.0375).round();
      // int width = originalImageWidth < originalImageHeight
      //     ? (originalImageWidth - originalImageWidth * 0.075).round()
      //     : (originalImageHeight - originalImageHeight * 0.075).round();
      // int height = originalImageWidth < originalImageHeight
      //     ? (originalImageWidth - originalImageWidth * 0.075).round()
      //     : (originalImageHeight - originalImageHeight * 0.075).round();

      double l;
      double t;
      double r;
      double b;

      switch (maskType) {
        case CameraMaskType.SQUARE_MASK:
          originX = originalImageWidth < originalImageHeight
              ? (originalImageWidth * 0.0375).round()
              : ((originalImageWidth / 2) -
                      ((originalImageHeight / 2) -
                          originalImageHeight * 0.0375))
                  .round();
          originY = originalImageWidth < originalImageHeight
              ? ((originalImageHeight / 2) -
                      ((originalImageWidth / 2) - originalImageWidth * 0.0375))
                  .round()
              : (originalImageHeight * 0.0375).round();
          // width = originalImageWidth < originalImageHeight
          //     ? (originalImageWidth - originalImageWidth * 0.075).round()
          //     : (originalImageHeight - originalImageHeight * 0.075).round();
          // height = originalImageWidth < originalImageHeight
          //     ? (originalImageWidth - originalImageWidth * 0.075).round()
          //     : (originalImageHeight - originalImageHeight * 0.075).round();

          l = 0.0375;
          t = originalImageWidth < originalImageHeight
              ? originY / originalImageHeight
              : originX / originalImageWidth;
          r = 1 - 0.0375;
          b = originalImageWidth < originalImageHeight
              ? 1 - (originY / originalImageHeight)
              : 1 - (originX / originalImageWidth);

          break;
        case CameraMaskType.RECTANGLE_ID_PORTRAIT:
          int threshold = 30;
          originX = threshold;
          originY = ((originalImageWidth -
                          (originalImageHeight -
                              originalImageWidth * (5.5 / 8.5))) /
                      2)
                  .round() -
              threshold;

          l = originX / originalImageWidth;
          t = originY / originalImageHeight;
          r = 1 - originX / originalImageWidth;
          b = 1 - originY / originalImageHeight;
          break;
        case CameraMaskType.RECTANGLE_ID:
          int threshold = 30;
          originX = originalImageWidth < originalImageHeight
              ? ((originalImageWidth -
                              ((originalImageHeight -
                                      originalImageHeight * 0.3) /
                                  1.6)) /
                          2)
                      .round() -
                  threshold
              : (originalImageWidth * 0.15).round() - threshold;
          originY = originalImageWidth < originalImageHeight
              ? (originalImageHeight * 0.15).round() - threshold
              : ((originalImageHeight -
                              ((originalImageWidth - originalImageWidth * 0.3) /
                                  1.6)) /
                          2)
                      .round() -
                  threshold;

          // width = originalImageWidth < originalImageHeight
          //     ? ((originalImageHeight - originalImageHeight * 0.3) / 1.6)
          //             .round() +
          //         (threshold * 2)
          //     : (originalImageWidth - originalImageWidth * 0.3).round() +
          //         (threshold * 2);
          // height = originalImageWidth < originalImageHeight
          //     ? (originalImageHeight - originalImageHeight * 0.3).round() +
          //         (threshold * 2)
          //     : ((originalImageWidth - originalImageWidth * 0.3) / 1.6)
          //             .round() +
          //         (threshold * 2);

          l = originX / originalImageWidth;
          t = originY / originalImageHeight;
          r = 1 - originX / originalImageWidth;
          b = 1 - originY / originalImageHeight;
          break;
        default:
      }
      File croppedFile;

      // if (Platform.isIOS) {
      croppedFile = await ImageCrop.cropImage(
        file: File(path),
        area: Rect.fromLTRB(l, t, r, b),
      );
      // } else {
      //   croppedFile = await FlutterNativeImage.cropImage(
      //       path, originX, originY, width, height);
      // }

      await croppedFile.copy(path);

      if (onSuccess != null) onSuccess();
    } catch (e) {
      if (onError != null) onError(e);
    }
    // } else {
    //   if (onIOS != null) onIOS();
    // }
  }

  static cropRect({
    @required String path,
    @required Rect rect,
    Function onSuccess,
    Function(dynamic) onError,
  }) async {
    try {
      ImageProperties properties =
          await FlutterNativeImage.getImageProperties(path);

      int width = properties.width;
      int height = properties.height;
      List<int> bytes = await File(path).readAsBytes();
      Map<String, IfdTag> exifData = await readExifFromBytes(bytes);
      if (properties.width == 0 ||
          properties.height == 0 ||
          properties.width == null ||
          properties.height == null) {
        width = int.parse(exifData["EXIF ExifImageWidth"].printable);
        height = int.parse(exifData["EXIF ExifImageLength"].printable);
      }

      // double y1 = (height - width) / 2;

      double y1 = (height - width) / 2;
      double y2 = y1 + width;

      File croppedFile;

      // if (Platform.isIOS) {
      croppedFile = await ImageCrop.cropImage(
        file: File(path),
        area: Rect.fromLTRB(0, y1 / height, 1, y2 / height),
      );
      // } else {
      //   croppedFile = await FlutterNativeImage.cropImage(
      //       path, originX, originY, width, height);
      // }

      await croppedFile.copy(path);

      if (onSuccess != null) onSuccess();
    } catch (e) {
      if (onError != null) onError(e);
    }
  }

  static void compressImage({
    @required String path,
    Function onSuccess,
    Function(dynamic) onError,
    Function onIOS,
    @required CameraMaskType maskType,
  }) async {
    // if (!Platform.isIOS) {
    try {
      ImageProperties properties =
          await FlutterNativeImage.getImageProperties(path);

      int width = properties.width;
      int height = properties.height;
      List<int> bytes = await File(path).readAsBytes();
      Map<String, IfdTag> exifData = await readExifFromBytes(bytes);
      if (properties.width == 0 ||
          properties.height == 0 ||
          properties.width == null ||
          properties.height == null) {
        width = int.parse(exifData["EXIF ExifImageWidth"].printable);
        height = int.parse(exifData["EXIF ExifImageLength"].printable);
      }

      int targetWidth = 480;
      int targetHeight = 480;

      switch (maskType) {
        case CameraMaskType.SQUARE_MASK:
          targetWidth = 480;
          targetHeight = 480;
          break;
        case CameraMaskType.RECTANGLE_ID:
          targetWidth = width > height ? 768 : 480;
          targetHeight = width > height ? 480 : 768;
          break;
        case CameraMaskType.DYNAMIC_RATIO:
          targetWidth = width > height ? ((width / height) * 480).round() : 480;
          targetHeight =
              width > height ? 480 : ((height / width) * 480).round();
          break;
        default:
      }

      File compressedFile;

      if (Platform.isIOS) {
        compressedFile = await ImageCrop.sampleImage(
          file: File(path),
          preferredWidth: targetWidth,
          preferredHeight: targetHeight,
        );
      } else {
        compressedFile = await FlutterNativeImage.compressImage(path,
            quality: 80, targetWidth: targetWidth, targetHeight: targetHeight);
      }

      await compressedFile.copy(path);
      // List<int> bytes2 = await File(path).readAsBytes();
      // Map<String, IfdTag> exifData2 = await readExifFromBytes(bytes2);
      if (onSuccess != null) onSuccess();
    } catch (e) {
      if (onError != null) onError(e);
    }
    // } else {
    //   if (onIOS != null) onIOS();
    // }
  }

  static void compressImageCustomSize({
    @required String path,
    Function onSuccess,
    Function(dynamic) onError,
    Function onIOS,
    @required int width,
    @required int height,
  }) async {
    // if (!Platform.isIOS) {
    try {
      File compressedFile;

      if (Platform.isIOS) {
        compressedFile = await ImageCrop.sampleImage(
          file: File(path),
          preferredWidth: width,
          preferredHeight: height,
        );
      } else {
        compressedFile = await FlutterNativeImage.compressImage(path,
            quality: 97, targetWidth: width, targetHeight: height);
      }

      await compressedFile.copy(path);

      if (onSuccess != null) onSuccess();
    } catch (e) {
      if (onError != null) onError(e);
    }
    // } else {
    //   if (onIOS != null) onIOS();
    // }
  }

  static void rotateImage({
    @required String path,
    @required Orientation orientation,
    Function onSuccess,
    Function(dynamic) onError,
    @required Store<AppState> store,
    @required BuildContext context,
  }) async {
    try {
      List<int> bytes = await File(path).readAsBytes();
      Map<String, IfdTag> exifData = await readExifFromBytes(bytes);
      img.Image originalImage = img.decodeImage(bytes);
      ImageProperties properties =
          await FlutterNativeImage.getImageProperties(path);
      // We'll use the exif package to read exif data
      // This is map of several exif properties
      // Let's check 'Image Orientation'

      final height = originalImage.height;
      final width = originalImage.width;

      // Let's check for the image size
      bool isExifOrientationNull = exifData["Image Orientation"] == null;
      print(
          "--------------------Image properties orientation => ${properties.orientation}\n");
      if (!isExifOrientationNull)
        print(
            "--------------------Exif orientation => ${exifData["Image Orientation"].printable}\n");
      print("--------------------image width/height => $width/$height\n");

      // store.dispatch(XUIPopUpMessage(
      //     context: context,
      //     message: 'Image properties orientation => ${properties.orientation}\n'
      //         'Exif orientation => ${exifData["Image Orientation"].printable}\n'
      //         'image width/height => $width/$height\n'));

      void rotate(num degrees) async {
        img.Image fixedImage;

        fixedImage = img.copyRotate(originalImage, degrees,
            interpolation: img.Interpolation.average);

        List<int> newBytes = img.encodeJpg(fixedImage);

        await File(path).writeAsBytes(newBytes);
        if (onSuccess != null) onSuccess();
      }

      Future toLandscape() async {
        bool isHeightBiggerThanWidth = height > width;
        if (isHeightBiggerThanWidth) {
          print("--------------------height bigger than width, rotating...");
          rotate(-90);
          return;
        }

        if (properties.orientation == ImageOrientation.normal) {
          rotate(0);
          return;
        }
        if (properties.orientation == ImageOrientation.rotate90) {
          rotate(-90);
          return;
        }
        if (properties.orientation == ImageOrientation.rotate180) {
          rotate(0);
          return;
        }
        if (properties.orientation == ImageOrientation.rotate270) {
          rotate(-270);
          return;
        }
        if (properties.orientation == ImageOrientation.undefined) {
          print(
              "--------------------Image properties orientation UNDEFINED, searching exif Data...\n");
          if (!isExifOrientationNull) if (exifData["Image Orientation"]
              .printable
              .contains("normal")) {
            rotate(0);
            return;
          }
          if (!isExifOrientationNull) if (exifData["Image Orientation"]
              .printable
              .contains("Rotated 90 CCW")) {
            rotate(90);

            return;
          }

          if (!isExifOrientationNull) if (exifData["Image Orientation"]
              .printable
              .contains("Rotated 90 CW")) {
            rotate(-90);

            return;
          }
          if (!isExifOrientationNull) if (exifData["Image Orientation"]
              .printable
              .contains("Rotated 90")) {
            rotate(-90);

            return;
          }
          if (!isExifOrientationNull) if (exifData["Image Orientation"]
              .printable
              .contains("Rotated 180")) {
            rotate(-180);
            return;
          }
          if (!isExifOrientationNull) if (exifData["Image Orientation"]
              .printable
              .contains("Rotated 270")) {
            rotate(-270);
            return;
          }

          rotate(0);
          return;
        }
      }

      switch (orientation) {
        case Orientation.landscape:
          await toLandscape();
          break;
        default:
          if (onSuccess != null) onSuccess();
      }
    } catch (e) {
      if (onError != null) onError(e);
    }
  }

  static Future<Uint8List> rotateImageToUint8List({
    @required Uint8List bytesUint8List,
    @required Orientation orientation,
    Function(dynamic) onError,
    @required BuildContext context,
  }) async {
    Uint8List result;
    try {
      Directory dir = await getTemporaryDirectory();
      File imageFile =
          await File('${dir.path}/my_image.jpg').writeAsBytes(bytesUint8List);
      List<int> bytes = List.from(bytesUint8List);
      Map<String, IfdTag> exifData = await readExifFromBytes(bytes);
      img.Image originalImage = img.decodeImage(bytes);
      ImageProperties properties =
          await FlutterNativeImage.getImageProperties(imageFile.path);
      // We'll use the exif package to read exif data
      // This is map of several exif properties
      // Let's check 'Image Orientation'

      final height = originalImage.height;
      final width = originalImage.width;

      // Let's check for the image size
      bool isExifOrientationNull = exifData["Image Orientation"] == null;
      print(
          "--------------------Image properties orientation => ${properties.orientation}\n");
      if (!isExifOrientationNull)
        print(
            "--------------------Exif orientation => ${exifData["Image Orientation"].printable}\n");
      print("--------------------image width/height => $width/$height\n");

      // store.dispatch(XUIPopUpMessage(
      //     context: context,
      //     message: 'Image properties orientation => ${properties.orientation}\n'
      //         'Exif orientation => ${exifData["Image Orientation"].printable}\n'
      //         'image width/height => $width/$height\n'));

      Future<Uint8List> rotate(num degrees) async {
        img.Image fixedImage;

        fixedImage = img.copyRotate(originalImage, degrees,
            interpolation: img.Interpolation.average);

        List<int> newBytes = img.encodeJpg(fixedImage);

        await imageFile.writeAsBytes(newBytes);

        return imageFile.readAsBytesSync();
      }

      Future<Uint8List> toLandscape() async {
        Uint8List resultImage;
        bool isHeightBiggerThanWidth = height > width;
        if (isHeightBiggerThanWidth) {
          print("--------------------height bigger than width, rotating...");
          resultImage = await rotate(90);
          return resultImage;
        }

        if (properties.orientation == ImageOrientation.normal) {
          resultImage = await rotate(0);
          return resultImage;
        }
        if (properties.orientation == ImageOrientation.rotate90) {
          resultImage = await rotate(-90);
          return resultImage;
        }
        if (properties.orientation == ImageOrientation.rotate180) {
          resultImage = await rotate(0);
          return resultImage;
        }
        if (properties.orientation == ImageOrientation.rotate270) {
          resultImage = await rotate(-270);
          return resultImage;
        }
        if (properties.orientation == ImageOrientation.undefined) {
          print(
              "--------------------Image properties orientation UNDEFINED, searching exif Data...\n");
          if (!isExifOrientationNull) if (exifData["Image Orientation"]
              .printable
              .contains("normal")) {
            resultImage = await rotate(0);
            return resultImage;
          }
          if (!isExifOrientationNull) if (exifData["Image Orientation"]
              .printable
              .contains("Rotated 90 CCW")) {
            resultImage = await rotate(90);

            return resultImage;
          }

          if (!isExifOrientationNull) if (exifData["Image Orientation"]
              .printable
              .contains("Rotated 90 CW")) {
            resultImage = await rotate(-90);

            return resultImage;
          }
          if (!isExifOrientationNull) if (exifData["Image Orientation"]
              .printable
              .contains("Rotated 90")) {
            resultImage = await rotate(-90);

            return resultImage;
          }
          if (!isExifOrientationNull) if (exifData["Image Orientation"]
              .printable
              .contains("Rotated 180")) {
            resultImage = await rotate(-180);
            return resultImage;
          }
          if (!isExifOrientationNull) if (exifData["Image Orientation"]
              .printable
              .contains("Rotated 270")) {
            resultImage = await rotate(-270);
            return resultImage;
          }

          resultImage = await rotate(0);
          return resultImage;
        }
        return resultImage;
      }

      switch (orientation) {
        case Orientation.landscape:
          result = await toLandscape();
          break;
        default:
        // if (onSuccess != null) onSuccess();
      }
    } catch (e) {
      if (onError != null) onError(e);
    }
    return result;
  }

  static void rotateImageDegrees({
    @required String path,
    @required double degrees,
    Function(String) onSuccess,
    Function(dynamic) onError,
    @required Store<AppState> store,
    @required BuildContext context,
  }) async {
    try {
      List<int> bytes = await File(path).readAsBytes();
      Map<String, IfdTag> exifData = await readExifFromBytes(bytes);
      img.Image originalImage = img.decodeImage(bytes);
      // ImageProperties properties =
      //     await FlutterNativeImage.getImageProperties(path);
      // We'll use the exif package to read exif data
      // This is map of several exif properties
      // Let's check 'Image Orientation'

      final height = originalImage.height;
      final width = originalImage.width;

      // Let's check for the image size
      bool isExifOrientationNull = exifData["Image Orientation"] == null;
      // print(
      //     "--------------------Image properties orientation => ${properties.orientation}\n");
      if (!isExifOrientationNull)
        print(
            "--------------------Exif orientation => ${exifData["Image Orientation"].printable}\n");
      print("--------------------image width/height => $width/$height\n");

      // store.dispatch(XUIPopUpMessage(
      //     context: context,
      //     message: 'Image properties orientation => ${properties.orientation}\n'
      //         'Exif orientation => ${exifData["Image Orientation"].printable}\n'
      //         'image width/height => $width/$height\n'));

      Future<void> rotate(num ndegrees) async {
        img.Image fixedImage;

        fixedImage = img.copyRotate(originalImage, ndegrees,
            interpolation: img.Interpolation.average);

        List<int> newBytes = img.encodeJpg(fixedImage);
        final newPath = join(
            // Store the picture in the temp directory.
            // Find the temp directory using the `path_provider` plugin.
            (await getTemporaryDirectory()).path,
            '${DateTime.now()}.png');

        await File(newPath).writeAsBytes(newBytes);
        if (onSuccess != null) onSuccess(newPath);
        return;
      }

      await rotate(degrees);
    } catch (e) {
      if (onError != null) onError(e);
    }
  }

  static void getImageSize({
    @required String path,
    Function(int, int) onLandscapeImage,
    Function(int, int) onPortraitImage,
    Function(int, int) onSuccess,
    Function(dynamic) onError,
  }) async {
    try {
      List<int> bytes = await File(path).readAsBytes();
      Map<String, IfdTag> exifData = await readExifFromBytes(bytes);
      img.Image originalImage = img.decodeImage(bytes);

      int width = originalImage.width;
      int height = originalImage.height;
      ImageProperties properties =
          await FlutterNativeImage.getImageProperties(path);

      bool knownOrientationNormal =
          properties.orientation == ImageOrientation.normal ||
              exifData["Image Orientation"].printable.contains("normal");
      if (onSuccess != null) onSuccess(width, height);

      if (width > height && knownOrientationNormal) {
        if (onLandscapeImage != null) onLandscapeImage(width, height);
      } else {
        if (onPortraitImage != null) onPortraitImage(width, height);
      }
    } catch (e) {
      if (onError != null) onError(e);
    }
  }

  static Future<File> cropImageToFilePortrait(File originalFile,
      {Function(dynamic) onError}) async {
    File result = originalFile;
    try {
      final sampleFile = await ImageCrop.sampleImage(
        file: originalFile,
        preferredWidth: 1024,
        preferredHeight: 4096,
      );

      ImageProperties properties =
          await FlutterNativeImage.getImageProperties(sampleFile.path);

      int width = properties.width;
      int height = properties.height;
      if (properties.width > properties.height) {
        // if image is horizontal
        width = properties.height;
        height = properties.width;
      }
      double xInit = 0;
      double yInit = (height / 2) - (width / 2);
      double xAmount = width.toDouble();
      double yAmount = width.toDouble();
      Rect area = Rect.fromLTWH(
          xInit / width, yInit / height, xAmount / width, yAmount / height);

      final croppedFile = await ImageCrop.cropImage(
        file: sampleFile,
        area: area,
      );

      result = croppedFile;
    } catch (e) {
      if (onError != null) onError(e);
    }

    return result;
  }

  static Future<File> cropImageToRectangleIDPortrait(File originalFile,
      {Function(dynamic) onError}) async {
    File result = originalFile;
    try {
      final sampleFile = await ImageCrop.sampleImage(
        file: originalFile,
        preferredWidth: 1024,
        preferredHeight: 4096,
      );

      ImageProperties properties =
          await FlutterNativeImage.getImageProperties(sampleFile.path);

      int width = properties.width;
      int height = properties.height;
      if (properties.width > properties.height) {
        // if image is horizontal
        width = properties.height;
        height = properties.width;
      }

      double _cardHeight = width * (5.5 / 8.5); // height ratio of ID CARD
      double _cardWidth = width.toDouble();

      double xInit = 0;
      double yInit = (height / 2) - (_cardHeight / 2);
      double xAmount = _cardWidth;
      double yAmount = _cardHeight;
      Rect area = Rect.fromLTWH(
          xInit / width, yInit / height, xAmount / width, yAmount / height);

      final croppedFile = await ImageCrop.cropImage(
        file: sampleFile,
        area: area,
      );

      result = croppedFile;
    } catch (e) {
      if (onError != null) onError(e);
    }

    return result;
  }

  static Future<String> cropImageToFilePortraitBase64(String originalBase64,
      {Function(dynamic) onError}) async {
    String result;
    try {
      Uint8List bytes = base64Decode(originalBase64);
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      var filePath = tempPath + '/file_01.tmp';
      File fileBestImage = File(filePath);
      fileBestImage.writeAsBytesSync(bytes);
      File croppedFile =
          await cropImageToFilePortrait(fileBestImage, onError: (e) {
        if (onError != null) onError(e);
      });

      final newBytes = croppedFile.readAsBytesSync();
      result = base64Encode(newBytes);
    } catch (e) {
      if (onError != null) onError(e);
    }

    return result;
  }
}
