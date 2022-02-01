import 'onboarding/onboardingFacePhi/onboardingFacePhi.dart';

List<Map> screenGlobalConfiguration = [
  onboardingFacePhiConfig,
];

Map screenGlobalConfFindByKey(String key) {
  var pag = screenGlobalConfiguration.singleWhere((Map conf) {
    return conf["key"] == key;
  });
  return pag;
}
