enum MessageAlertType { SNACKBAR, TOAST, TOASTBAR }

enum MessageAlertColorType {
  WARNING,
  DANGER,
  SUCCESS,
  INFO,
  LIGHT,
  PRIMARY,
  SECONDARY,
  DARK
}

class MessageAlertState {
  String message = "";
  MessageAlertType type;
  MessageAlertColorType color;
  MessageAlertState({this.message = "", this.type, this.color});
}
