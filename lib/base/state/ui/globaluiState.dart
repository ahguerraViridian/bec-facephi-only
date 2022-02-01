import '../../../base/enums/allEnums.dart';

class StGlobalUI {
  GlobalUIState currentUIState = GlobalUIState.NORMAL;

  setCurrentUIState(GlobalUIState newUIState) {
    this.currentUIState = newUIState;
  }
}
