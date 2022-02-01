class SelphiFaceErrorType {
  final _value;
  const SelphiFaceErrorType._internal(this._value);
  toString() => '$_value';
  toInt() => _value;
  
  static SelphiFaceErrorType getEnum(int value) {
      switch(value) {
        case 1:
        return TE_UNKNOWN_ERROR;
        case 2:
        return TE_NO_ERROR;
        case 3:
        return TE_CAMERA_PERMISSION_DENIED;
        case 4:
        return TE_SETTINGS_PERMISSION_ERROR;
        case 5:
        return TE_HARDWARE_ERROR;
        case 6:
        return TE_EXTRACTION_LICENSE_ERROR;
        case 7:
        return TE_UNEXPECTED_CAPTURE_ERROR;
        case 8:
        return TE_CONTROL_NOT_INITIALIZATED_ERROR;
        case 9:
        return TE_BAD_EXTRACTOR_CONFIGURATION_ERROR;
        default:
        return TE_UNKNOWN_ERROR;
      }
  }



  static const TE_UNKNOWN_ERROR = const SelphiFaceErrorType._internal(1);
  static const TE_NO_ERROR = const SelphiFaceErrorType._internal(2);
  static const TE_CAMERA_PERMISSION_DENIED = const SelphiFaceErrorType._internal(3);
  static const TE_SETTINGS_PERMISSION_ERROR = const SelphiFaceErrorType._internal(4);
  static const TE_HARDWARE_ERROR = const SelphiFaceErrorType._internal(5);
  static const TE_EXTRACTION_LICENSE_ERROR = const SelphiFaceErrorType._internal(6);
  static const TE_UNEXPECTED_CAPTURE_ERROR = const SelphiFaceErrorType._internal(7);
  static const TE_CONTROL_NOT_INITIALIZATED_ERROR = const SelphiFaceErrorType._internal(8);
  static const TE_BAD_EXTRACTOR_CONFIGURATION_ERROR = const SelphiFaceErrorType._internal(9);
}