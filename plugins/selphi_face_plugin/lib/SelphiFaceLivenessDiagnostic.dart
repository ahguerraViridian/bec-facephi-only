class SelphiFaceLivenessDiagnostic {

  final _value;
  const SelphiFaceLivenessDiagnostic._internal(this._value);
  toString() => '$_value';
  toInt() => _value;
  
  static SelphiFaceLivenessDiagnostic getEnum(int value) {
      switch(value) {
        case 1:
        return LD_NOT_RATED; /** Not rated. */
        case 2:
        return LD_PHOTO_DETECTED; /** Photo detected. */
        case 3:
        return LD_LIVENESS_DETECTED; /** Photography is not detected. */
        case 4:
        return LD_UNSUCCESS; /** Unsuccess. */
        case 5:
        return LD_UNSUCCESS_PERFORMANCE; /** Unsuccess due to low performance.. */
        case 6:
        return LD_UNSUCCESS_GLASSES; /** Unsuccess due to glasses. */
        case 7:
        return LD_UNSUCCESS_LIGHT; /** Unsuccess due to bad light conditions. */
        case 8:
        return LD_UNSUCCESS_NO_MOVEMENT; /** Unsuccess due to no movement. */
        case 9:
        return LD_UNSUCCESS_WRONG_DIRECTION; /** Unsuccess due to wrong movement direction. */
        case 10:
        return LD_UNSUCCESS_TOO_FAR; /** Unsuccess due to too far detection. */
        case 11:
        return LD_UNSUCCESS_PLAYBACK; /** Unsuccess due to playback detection. */
        default:
        return LD_UNSUCCESS;
      }
  }


  static const LD_NOT_RATED = const SelphiFaceLivenessDiagnostic._internal(1);
  static const LD_PHOTO_DETECTED = const SelphiFaceLivenessDiagnostic._internal(2);
  static const LD_LIVENESS_DETECTED = const SelphiFaceLivenessDiagnostic._internal(3);
  static const LD_UNSUCCESS = const SelphiFaceLivenessDiagnostic._internal(4);
  static const LD_UNSUCCESS_PERFORMANCE = const SelphiFaceLivenessDiagnostic._internal(5);
  static const LD_UNSUCCESS_GLASSES = const SelphiFaceLivenessDiagnostic._internal(6);
  static const LD_UNSUCCESS_LIGHT = const SelphiFaceLivenessDiagnostic._internal(7);
  static const LD_UNSUCCESS_NO_MOVEMENT = const SelphiFaceLivenessDiagnostic._internal(8);
  static const LD_UNSUCCESS_WRONG_DIRECTION = const SelphiFaceLivenessDiagnostic._internal(9);
  static const LD_UNSUCCESS_TOO_FAR = const SelphiFaceLivenessDiagnostic._internal(10);
  static const LD_UNSUCCESS_PLAYBACK = const SelphiFaceLivenessDiagnostic._internal(11);


}