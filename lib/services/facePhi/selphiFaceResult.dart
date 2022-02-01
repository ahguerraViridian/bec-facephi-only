import 'dart:convert';
import 'dart:core';
import 'package:selphi_face_plugin/SelphiFaceFinishStatus.dart';
import 'package:selphi_face_plugin/SelphiFaceErrorType.dart';

class SelphiFaceResult {
  final String template; // 0
  final dynamic images; // 1
  final String errorType; // 2
  final String errorMessage; // 3
  final String bestImage; // 4
  final double templateScore; // 5
  final int livenessDiagnostic; // 6
  final SelphiFaceFinishStatus finishStatus; // 7
  final String templateRaw; // 8
  final String bestImageCropped; // 9
  final int faceScoreDiagnostic; // 10
  final double eyeGlassesScore; // 11
  final String statistics; // 12

  final String qrData;
  final SelphiFaceErrorType errorDiagnostic; // 8

  const SelphiFaceResult({
    this.template,
    this.livenessDiagnostic,
    this.statistics,
    this.finishStatus,
    this.errorDiagnostic,
    this.errorMessage,
    this.templateRaw,
    this.eyeGlassesScore,
    this.templateScore,
    this.qrData,
    this.bestImage,
    this.bestImageCropped,
    this.errorType,
    this.faceScoreDiagnostic,
    this.images,
  });

  Map<String, dynamic> toMap() {
    return {
      'finishStatus': finishStatus.toInt(),
      'errorDiagnostic': errorDiagnostic.toInt(),
      'errorMessage': errorMessage,
      'templateRaw': templateRaw,
      'eyeGlassesScore': eyeGlassesScore,
      'templateScore': templateScore,
      'qrData': qrData,
      'bestImage': bestImage,
      'bestImageCropped': bestImageCropped,
    };
  }

  static SelphiFaceResult fromMap(Map<dynamic, dynamic> map) {
    if (map == null) return null;

    return SelphiFaceResult(
      template: map['template'], //0
      images: map['images'], //1
      errorType: map['errorType'], //2
      errorMessage: map['errorMessage'], //3
      bestImage: map['bestImage'], //4
      templateScore: map['templateScore'], //5
      livenessDiagnostic: map['livenessDiagnostic'], //6
      finishStatus: SelphiFaceFinishStatus.getEnum(map['finishStatus']), // 7
      templateRaw: map['templateRaw'], // 8
      bestImageCropped: map['bestImageCropped'], // 9
      faceScoreDiagnostic: map['faceScoreDiagnostic'], // 10
      eyeGlassesScore: map['eyeGlassesScore'], // 11
      statistics: map['statistics'], // 11

      errorDiagnostic: SelphiFaceErrorType.getEnum(map['errorDiagnostic']),
      qrData: map['qrData'],
    );
  }

  @override
  String toString() {
    return 'SelphiFaceResult(finishStatus: $finishStatus, errorDiagnostic: $errorDiagnostic, errorMessage: $errorMessage, templateRaw: $templateRaw, eyeGlassesScore: $eyeGlassesScore, templateScore: $templateScore, qrData: $qrData, bestImage: $bestImage, bestImageCropped: $bestImageCropped)';
  }
}
