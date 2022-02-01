import 'dart:core';
import 'package:selphid_plugin/SelphIDFinishStatus.dart';
import 'package:selphid_plugin/SelphIDErrorType.dart';

class SelphIDResult {
  final int timeoutStatus; //0
  final String frontDocumentImage; //1
  final int errorType; //2
  final String errorMessage; //3
  final String documentData; //4
  final String rawFrontDocument; //5
  final String faceImage; //6
  final String tokenOCR; //7
  final SelphIDFinishStatus finishStatus; //8
  final String tokenFrontDocument; //9
  final double matchingSidesScore; //10
  final String backDocumentImage; // 11
  final String rawBackDocument; // 12
  final String tokenBackDocument; // 13
  final String tokenFaceImage; // 14

  final String documentCaptured; //
  final SelphIDErrorType errorDiagnostic;

  const SelphIDResult({
    this.finishStatus,
    this.errorDiagnostic,
    this.errorMessage,
    this.timeoutStatus,
    this.frontDocumentImage,
    this.backDocumentImage,
    this.faceImage,
    this.tokenFrontDocument,
    this.tokenBackDocument,
    this.tokenFaceImage,
    this.documentData,
    this.tokenOCR,
    this.documentCaptured,
    this.matchingSidesScore,
    this.errorType,
    this.rawBackDocument,
    this.rawFrontDocument,
  });

  Map<String, dynamic> toMap() {
    return {
      'timeoutStatus': timeoutStatus, // 0
      'frontDocumentImage': frontDocumentImage, // 1
      'errorType': errorType, // 2
      'errorMessage': errorMessage, // 3
      'documentData': documentData, // 4
      'rawFrontDocument': rawFrontDocument, // 5
      'faceImage': faceImage, // 6
      'tokenOCR': tokenOCR, // 7
      'finishStatus': finishStatus.toInt(), // 8
      'tokenFrontDocument': tokenFrontDocument, // 9
      'matchingSidesScore': matchingSidesScore, // 10
      'backDocumentImage': backDocumentImage, // 11
      'rawBackDocument': rawBackDocument, // 12
      'tokenBackDocument': tokenBackDocument, // 13
      'tokenFaceImage': tokenFaceImage, // 14

      'errorDiagnostic': errorDiagnostic.toInt(),
      'documentCaptured': documentCaptured,
    };
  }

  static SelphIDResult fromMap(Map<dynamic, dynamic> map) {
    if (map == null) return null;

    return SelphIDResult(
      timeoutStatus: map['timeoutStatus'], // 0
      frontDocumentImage: map['frontDocumentImage'], // 1
      errorType: map['errorType'], // 2 
      errorMessage: map['errorMessage'], // 3
      documentData: map['documentData'], // 4
      rawFrontDocument: map['rawFrontDocument'], // 5
      faceImage: map['faceImage'], // 6
      tokenOCR: map['tokenOCR'], // 7
      finishStatus: SelphIDFinishStatus.getEnum(map['finishStatus']), // 8
      tokenFrontDocument: map['tokenFrontDocument'], // 9
      matchingSidesScore: map['matchingSidesScore'], // 10
      backDocumentImage: map['backDocumentImage'], // 11
      rawBackDocument: map['rawBackDocument'], // 12
      tokenBackDocument: map["tokenBackDocument"], // 13
      tokenFaceImage: map['tokenFaceImage'], // 14

      
      documentCaptured: map['documentCaptured'],



      errorDiagnostic: SelphIDErrorType.getEnum(map['errorDiagnostic']),
    );
  }

  @override
  String toString() {
    return 'SelphIDResult(finishStatus: $finishStatus, errorDiagnostic: $errorDiagnostic, errorMessage: $errorMessage, timeoutStatus: $timeoutStatus, frontDocumentImage: $frontDocumentImage,  backDocumentImage: $backDocumentImage, faceImage: $faceImage, tokenFrontDocumentImage: $tokenFrontDocument, tokenBackDocumentImage: $tokenBackDocument, tokenFaceImage: $tokenFaceImage, documentData: $documentData, tokenOCR: $tokenOCR, documentCaptured: $documentCaptured, matchingSidesScore: $matchingSidesScore)';
  }
}
