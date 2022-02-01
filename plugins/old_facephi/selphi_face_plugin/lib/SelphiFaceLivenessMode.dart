class SelphiFaceLivenessMode {

  final _value;
  const SelphiFaceLivenessMode._internal(this._value);
  toString() => '$_value';

  static const LM_PASSIVE = const SelphiFaceLivenessMode._internal('PASSIVE');
  static const LM_NONE = const SelphiFaceLivenessMode._internal('NONE');
}