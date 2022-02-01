class SelphIDFinishStatus {

  final _value;
  const SelphIDFinishStatus._internal(this._value);
  toString() => '$_value';
  toInt() => _value;
  
  static SelphIDFinishStatus getEnum(int value) {
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

  static const STATUS_OK = const SelphIDFinishStatus._internal(1);
  static const STATUS_ERROR = const SelphIDFinishStatus._internal(2);
  static const STATUS_CANCEL_BY_USER = const SelphIDFinishStatus._internal(3);
  static const STATUS_TIMEOUT = const SelphIDFinishStatus._internal(4);

}