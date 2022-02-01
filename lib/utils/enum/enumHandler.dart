import '../../base/enums/allEnums.dart';

class EnumHandler {
  static ButtonAction getButtonTypeEnum(String string) {
    ButtonAction result;
    if (string != null) {
      switch (string.toUpperCase()) {
        case "NEXT":
          result = ButtonAction.NEXT;
          break;
        case "BACK":
          result = ButtonAction.BACK;
          break;
        default:
      }
    }

    return result;
  }
}
