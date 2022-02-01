class StOnboardingBanks {
  List<StOnboardingBankData> onBoardingBanks = [];
  void clearOnboardingBanks() {
    onBoardingBanks.clear();
  }

  void addOnboardingBank(StOnboardingBankData onboardingBank) {
    onBoardingBanks.add(onboardingBank);
  }

  List<StOnboardingBankData> getData() {
    return onBoardingBanks;
  }
}

class StOnboardingBankData {
  String asobanCode;
  String name;
  String logoImgURL;
  String primaryColor;
  String secondaryColor;
  StOnboardingBankData({
    this.asobanCode,
    this.logoImgURL,
    this.name,
    this.primaryColor,
    this.secondaryColor,
  });
}
