import '../base/state/appState.dart';
import 'package:redux/redux.dart';
import 'camera/camera.dart';
import 'facePhi/facePhiService.dart';
import 'deviceApps/deviceApps.dart';
import 'huawei/huaweiServices.dart';

class Services {
  static CameraService cameraService = CameraService();
  static HuaweiService huaweiService = HuaweiService();
  static FacePhiService facePhiService = FacePhiService();
  static DeviceAppsService deviceAppsService = DeviceAppsService();

  static void init(Store<AppState> store) {
    //Init transaction Id

    //Init secureStorage

    //Init Firebase

    cameraService.init(store);

    facePhiService.init(store);
    deviceAppsService.init(store);
  }
}
