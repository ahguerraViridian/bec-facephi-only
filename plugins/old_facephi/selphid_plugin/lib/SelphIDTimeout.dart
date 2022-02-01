class SelphIDTimeout {

  final _value;
  const SelphIDTimeout._internal(this._value);
  toString() => '$_value';

  static const T_SHORT = const SelphIDTimeout._internal('Short');
  static const T_MEDIUM = const SelphIDTimeout._internal('Medium');
  static const T_LONG = const SelphIDTimeout._internal('Long');
}