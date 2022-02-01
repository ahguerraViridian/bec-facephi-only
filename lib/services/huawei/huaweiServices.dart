import '../../base/state/allState.dart';
import 'package:redux/redux.dart';

class HuaweiService {
  static final HuaweiService _singleton = new HuaweiService._internal();

  factory HuaweiService() {
    return _singleton;
  }

  HuaweiService._internal();
  void init(Store<AppState> store) async {
    print("Huawei services disabled");
  }
}
