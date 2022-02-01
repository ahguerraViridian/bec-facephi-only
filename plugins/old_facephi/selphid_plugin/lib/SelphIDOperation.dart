class SelphIDOperation {

  final _value;
  const SelphIDOperation._internal(this._value);
  toString() => '$_value';

  static const CAPTURE_FRONT = const SelphIDOperation._internal('CaptureFront');
  static const CAPTURE_BACK = const SelphIDOperation._internal('CaptureBack');
  static const CAPTURE_WIZARD = const SelphIDOperation._internal('CaptureWizard');

}