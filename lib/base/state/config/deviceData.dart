import 'dart:convert';

class StDeviceData {
  double latitude;
  double longitude;
  String deviceType;
  String deviceOS;
  String deviceBrowser;
  StDeviceData({
    this.latitude,
    this.longitude,
    this.deviceType,
    this.deviceOS,
    this.deviceBrowser,
  });

  StDeviceData copyWith({
    double latitude,
    double longitude,
    String deviceType,
    String deviceOS,
    String deviceBrowser,
  }) {
    return StDeviceData(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      deviceType: deviceType ?? this.deviceType,
      deviceOS: deviceOS ?? this.deviceOS,
      deviceBrowser: deviceBrowser ?? this.deviceBrowser,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'deviceType': deviceType,
      'deviceOS': deviceOS,
      'deviceBrowser': deviceBrowser,
    };
  }

  factory StDeviceData.fromMap(Map<String, dynamic> map) {
    return StDeviceData(
      latitude: map['latitude'],
      longitude: map['longitude'],
      deviceType: map['deviceType'],
      deviceOS: map['deviceOS'],
      deviceBrowser: map['deviceBrowser'],
    );
  }

  String toJson() => json.encode(toMap());

  factory StDeviceData.fromJson(String source) =>
      StDeviceData.fromMap(json.decode(source));
}
