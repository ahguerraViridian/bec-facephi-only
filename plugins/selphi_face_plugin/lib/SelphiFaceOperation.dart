class SelphiFaceOperation {

  final _value;
  const SelphiFaceOperation._internal(this._value);
  toString() => '$_value';

  static const AUTHENTICATE = const SelphiFaceOperation._internal('Authenticate');
}