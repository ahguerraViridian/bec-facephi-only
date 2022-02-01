import '../../base/actions/state/config.dart';

import '../../base/state/appState.dart';
import 'package:redux/redux.dart';
import '../../base/state/allState.dart';
import 'package:camera/camera.dart';

class CameraService {
  static final CameraService _singleton = new CameraService._internal();

  factory CameraService() {
    return _singleton;
  }

  CameraService._internal();

  void init(Store<AppState> store) async {
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();

// Get a specific camera from the list of available cameras.
    final firstCamera = cameras.length > 0 ? cameras.last : null;
  }

  // Future<void> initConnectivity(Store<AppState> store) async {
  //   ConnectivityResult result;
  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     result = await _connectivity.checkConnectivity();
  //   } on Exception catch (e) {
  //     print(e.toString());
  //   }

  //   // If the widget was removed from the tree while the asynchronous platform
  //   // message was in flight, we want to discard the reply rather than calling
  //   // setState to update our non-existent appearance.
  //   // if (!mounted) {
  //   //   return;
  //   // }

  //   _updateConnectionStatus(result, store);
  // }

}
