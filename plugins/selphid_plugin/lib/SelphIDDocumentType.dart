class SelphIDDocumentType {

  final _value;
  const SelphIDDocumentType._internal(this._value);
  toString() => '$_value';

  static const DT_IDCARD = const SelphIDDocumentType._internal('DT_IDCard');
  static const DT_PASSPORT = const SelphIDDocumentType._internal('DT_Passport');
  static const DT_DRIVERSLICENSE = const SelphIDDocumentType._internal('DT_DriversLicense');
  static const DT_FOREIGNCARD = const SelphIDDocumentType._internal('DT_ForeignCard');
  static const DT_CREDITCARD = const SelphIDDocumentType._internal('DT_CreditCard');
  static const DT_CUSTOM = const SelphIDDocumentType._internal('DT_Custom');
}