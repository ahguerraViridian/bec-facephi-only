import 'dart:convert';

class StClientDocumentData {
  String docIdNumber;
  String docIdComplement;
  String docIdIssuePlace;
  String names;
  String firstLastName;
  String secondLastName;
  String birthDate;
  StClientDocumentData({
    this.docIdNumber,
    this.docIdComplement,
    this.docIdIssuePlace,
    this.names,
    this.firstLastName,
    this.secondLastName,
    this.birthDate,
  });

  StClientDocumentData copyWith({
    String docIdNumber,
    String docIdComplement,
    String docIdIssuePlace,
    String names,
    String firstLastName,
    String secondLastName,
    String birthDate,
  }) {
    return StClientDocumentData(
      docIdNumber: docIdNumber ?? this.docIdNumber,
      docIdComplement: docIdComplement ?? this.docIdComplement,
      docIdIssuePlace: docIdIssuePlace ?? this.docIdIssuePlace,
      names: names ?? this.names,
      firstLastName: firstLastName ?? this.firstLastName,
      secondLastName: secondLastName ?? this.secondLastName,
      birthDate: birthDate ?? this.birthDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'docIdNumber': docIdNumber,
      'docIdComplement': docIdComplement,
      'docIdIssuePlace': docIdIssuePlace,
      'names': names,
      'firstLastName': firstLastName,
      'secondLastName': secondLastName,
      'birthDate': birthDate,
    };
  }

  factory StClientDocumentData.fromMap(Map<String, dynamic> map) {
    return StClientDocumentData(
      docIdNumber: map['docIdNumber'] ?? '',
      docIdComplement: map['docIdComplement'] ?? '',
      docIdIssuePlace: map['docIdIssuePlace'] ?? '',
      names: map['names'] ?? '',
      firstLastName: map['firstLastName'] ?? '',
      secondLastName: map['secondLastName'] ?? '',
      birthDate: map['birthDate'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory StClientDocumentData.fromJson(String source) =>
      StClientDocumentData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StClientDocumentData(docIdNumber: $docIdNumber, docIdComplement: $docIdComplement, docIdIssuePlace: $docIdIssuePlace, names: $names, firstLastName: $firstLastName, secondLastName: $secondLastName, birthDate: $birthDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is StClientDocumentData &&
        other.docIdNumber == docIdNumber &&
        other.docIdComplement == docIdComplement &&
        other.docIdIssuePlace == docIdIssuePlace &&
        other.names == names &&
        other.firstLastName == firstLastName &&
        other.secondLastName == secondLastName &&
        other.birthDate == birthDate;
  }

  @override
  int get hashCode {
    return docIdNumber.hashCode ^
        docIdComplement.hashCode ^
        docIdIssuePlace.hashCode ^
        names.hashCode ^
        firstLastName.hashCode ^
        secondLastName.hashCode ^
        birthDate.hashCode;
  }
}
