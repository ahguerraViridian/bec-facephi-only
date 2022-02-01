import '../../enums/allEnums.dart';
import '../allState.dart';

// This state is for view in accounts Route
class UIAccountsView extends UIView {
  TypeView accountTypeView;
  MessageAlertState messageAlert;

  UIAccountsView({this.accountTypeView = TypeView.WAITING, this.messageAlert});

  TypeView getAccountTypeView() {
    return accountTypeView;
  }

  void setAccountTypeView(TypeView type) {
    accountTypeView = type;
  }
}
