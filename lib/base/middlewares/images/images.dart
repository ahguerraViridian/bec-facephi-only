import '../../../services/images/imagesServices.dart';

import '../../../base/state/allState.dart';
import 'package:redux/redux.dart';

Middleware<AppState> cropImage() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    ImagesService.cropImage(
      path: action.path,
      maskType: action.maskType,
      onError: action.onError,
      onSuccess: action.onSuccess,
      onIOS: action.onIOS,
    );
  };
}

Middleware<AppState> cropRectImage() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    ImagesService.cropRect(
      path: action.path,
      rect: action.rect,
      onError: action.onError,
      onSuccess: action.onSuccess,
    );
  };
}

Middleware<AppState> compressImage() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    ImagesService.compressImage(
      path: action.path,
      maskType: action.maskType,
      onError: action.onError,
      onSuccess: action.onSuccess,
      onIOS: action.onIOS,
    );
  };
}

Middleware<AppState> compressImageCustomSize() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    ImagesService.compressImageCustomSize(
      path: action.path,
      onError: action.onError,
      onSuccess: action.onSuccess,
      onIOS: action.onIOS,
      height: action.height,
      width: action.width,
    );
  };
}

Middleware<AppState> rotateImage() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    ImagesService.rotateImage(
      path: action.path,
      onError: action.onError,
      onSuccess: action.onSuccess,
      orientation: action.orientation,
      context: action.context,
      store: action.store,
    );
  };
}

Middleware<AppState> getImageSize() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    ImagesService.getImageSize(
      path: action.path,
      onError: action.onError,
      onSuccess: action.onSuccess,
      onLandscapeImage: action.onLandscapeImage,
      onPortraitImage: action.onPortraitImage,
    );
  };
}
