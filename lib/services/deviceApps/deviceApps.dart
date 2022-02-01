import '../../base/state/appState.dart';
import 'package:redux/redux.dart';
import 'package:device_apps/device_apps.dart';

class DeviceAppsService {
  static final DeviceAppsService _singleton = new DeviceAppsService._internal();

  factory DeviceAppsService() {
    return _singleton;
  }

  DeviceAppsService._internal();

  void init(Store<AppState> store) async {}

  Future<bool> isAppInstalled(
      String packageName, {Function(dynamic) onError}) async {
    bool result = false;
    try {
      result = await DeviceApps.isAppInstalled(packageName);
    } catch (e) {
      if (onError != null) onError(e);
    }

    return result;
  }
}
