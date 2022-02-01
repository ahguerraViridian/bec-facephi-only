class SelphIDCompressFormat {

  final _value;
  const SelphIDCompressFormat._internal(this._value);
  toString() => '$_value';

  static const T_JPEG = const SelphIDCompressFormat._internal('jpeg');
  static const T_PNG = const SelphIDCompressFormat._internal('png');
}