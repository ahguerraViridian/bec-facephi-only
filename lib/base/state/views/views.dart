import '../allState.dart';
import '../../../routes/config.dart';

class UIView {}

class UIViews {
  bool connectivity = true;
  Map<String, dynamic> views = buildUIViews();

  dynamic getUIView(String key) {
    return views[key];
  }

  void setUIView(String key, dynamic view) {
    return views[key] = view;
  }
}

Map<String, dynamic> _views = {
  "/myAccounts": UIAccountsView(),
};

Map<String, dynamic> buildUIViews() {
  screenGlobalConfiguration.forEach((conf) {
    if (conf["viewState"] != null) {
      _views..addAll({conf["key"]: conf["viewState"]});
    }
  });
  return _views;
}
