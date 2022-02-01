class SelphIDScanMode {

  final _value;
  const SelphIDScanMode._internal(this._value);
  toString() => '$_value';

  static const CAP_MODE_GENERIC = const SelphIDScanMode._internal('GenericMode');
  static const CAP_MODE_SPECIFIC = const SelphIDScanMode._internal('SpecificMode');
  static const CAP_MODE_SEARCH = const SelphIDScanMode._internal('SearchMode');

}