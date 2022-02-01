class SelphiFaceFinishStatus {

  final _value;
  const SelphiFaceFinishStatus._internal(this._value);
  toString() => '$_value';
  toInt() => _value;
  
  static SelphiFaceFinishStatus getEnum(int value) {
      switch(value) {
        case 1:
        return STATUS_OK;
        case 2:
        return STATUS_ERROR;
        case 3:
        return STATUS_CANCEL_BY_USER;
        case 4:
        return STATUS_TIMEOUT;
        default: 
        return STATUS_ERROR;
      }
  }

  static const STATUS_OK = const SelphiFaceFinishStatus._internal(1);
  static const STATUS_ERROR = const SelphiFaceFinishStatus._internal(2);
  static const STATUS_CANCEL_BY_USER = const SelphiFaceFinishStatus._internal(3);
  static const STATUS_TIMEOUT = const SelphiFaceFinishStatus._internal(4);

}