import 'dart:convert';

class StOnboardingRequestData {
  String fullName;
  String names;
  String firstLastName;
  String secondLastName;
  String thirdLastName;
  String address;
  String profession;
  String maritalStatus;
  String birthDate;
  String phoneNumber;
  String docIdNumber;
  String docIdExtension;
  String docIdComplement;
  String docIdDueDate;
  String onboardingCountry;
  String onboardingState;
  String onboardingCity;
  String geoBranch;
  String geoOffice;
  String birthplaceState;

  StOnboardingRequestData({
    this.fullName,
    this.names,
    this.firstLastName,
    this.secondLastName,
    this.thirdLastName,
    this.address,
    this.profession,
    this.maritalStatus,
    this.birthDate,
    this.phoneNumber,
    this.docIdNumber,
    this.docIdExtension,
    this.docIdComplement,
    this.docIdDueDate,
    this.onboardingCountry,
    this.onboardingState,
    this.onboardingCity,
    this.geoBranch,
    this.geoOffice,
    this.birthplaceState,
  });

  StOnboardingRequestData copyWith({
    String fullName,
    String names,
    String firstLastName,
    String secondLastName,
    String thirdLastName,
    String address,
    String profession,
    String maritalStatus,
    String birthDate,
    String phoneNumber,
    String docIdNumber,
    String docIdExtension,
    String docIdComplement,
    String docIdDueDate,
    String onboardingCountry,
    String onboardingState,
    String onboardingCity,
    String geoBranch,
    String geoOffice,
    String birthplaceState,
  }) {
    return StOnboardingRequestData(
      fullName: fullName ?? this.fullName,
      names: names ?? this.names,
      firstLastName: firstLastName ?? this.firstLastName,
      secondLastName: secondLastName ?? this.secondLastName,
      thirdLastName: thirdLastName ?? this.thirdLastName,
      address: address ?? this.address,
      profession: profession ?? this.profession,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      birthDate: birthDate ?? this.birthDate,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      docIdNumber: docIdNumber ?? this.docIdNumber,
      docIdExtension: docIdExtension ?? this.docIdExtension,
      docIdComplement: docIdComplement ?? this.docIdComplement,
      docIdDueDate: docIdDueDate ?? this.docIdDueDate,
      onboardingCountry: onboardingCountry ?? this.onboardingCountry,
      onboardingState: onboardingState ?? this.onboardingState,
      onboardingCity: onboardingCity ?? this.onboardingCity,
      geoBranch: geoBranch ?? this.geoBranch,
      geoOffice: geoOffice ?? this.geoOffice,
      birthplaceState: birthplaceState ?? this.birthplaceState,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fullName': fullName,
      'names': names,
      'firstLastName': firstLastName,
      'secondLastName': secondLastName,
      'thirdLastName': thirdLastName,
      'address': address,
      'profession': profession,
      'maritalStatus': maritalStatus,
      'birthDate': birthDate,
      'phoneNumber': phoneNumber,
      'docIdNumber': docIdNumber,
      'docIdExtension': docIdExtension,
      'docIdComplement': docIdComplement,
      'docIdDueDate': docIdDueDate,
      'onboardingCountry': onboardingCountry,
      'onboardingState': onboardingState,
      'onboardingCity': onboardingCity,
      'geoBranch': geoBranch,
      'geoOffice': geoOffice,
      'birthplaceState': birthplaceState,
    };
  }

  factory StOnboardingRequestData.fromMap(Map<String, dynamic> map) {
    return StOnboardingRequestData(
      fullName: map['fullName'] ?? '',
      names: map['names'] ?? '',
      firstLastName: map['firstLastName'] ?? '',
      secondLastName: map['secondLastName'] ?? '',
      thirdLastName: map['thirdLastName'] ?? '',
      address: map['address'] ?? '',
      profession: map['profession'] ?? '',
      maritalStatus: map['maritalStatus'] ?? '',
      birthDate: map['birthDate'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      docIdNumber: map['docIdNumber'] ?? '',
      docIdExtension: map['docIdExtension'] ?? '',
      docIdComplement: map['docIdComplement'] ?? '',
      docIdDueDate: map['docIdDueDate'] ?? '',
      onboardingCountry: map['onboardingCountry'] ?? '',
      onboardingState: map['onboardingState'] ?? '',
      onboardingCity: map['onboardingCity'] ?? '',
      geoBranch: map['geoBranch'] ?? '',
      geoOffice: map['geoOffice'] ?? '',
      birthplaceState: map['birthplaceState'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory StOnboardingRequestData.fromJson(String source) => StOnboardingRequestData.fromMap(json.decode(source));

  @override
  String toString() {
    return 'StOnboardingRequestData(fullName: $fullName, names: $names, firstLastName: $firstLastName, secondLastName: $secondLastName, thirdLastName: $thirdLastName, address: $address, profession: $profession, maritalStatus: $maritalStatus, birthDate: $birthDate, phoneNumber: $phoneNumber, docIdNumber: $docIdNumber, docIdExtension: $docIdExtension, docIdComplement: $docIdComplement, docIdDueDate: $docIdDueDate, onboardingCountry: $onboardingCountry, onboardingState: $onboardingState, onboardingCity: $onboardingCity, geoBranch: $geoBranch, geoOffice: $geoOffice, birthplaceState: $birthplaceState)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is StOnboardingRequestData &&
      other.fullName == fullName &&
      other.names == names &&
      other.firstLastName == firstLastName &&
      other.secondLastName == secondLastName &&
      other.thirdLastName == thirdLastName &&
      other.address == address &&
      other.profession == profession &&
      other.maritalStatus == maritalStatus &&
      other.birthDate == birthDate &&
      other.phoneNumber == phoneNumber &&
      other.docIdNumber == docIdNumber &&
      other.docIdExtension == docIdExtension &&
      other.docIdComplement == docIdComplement &&
      other.docIdDueDate == docIdDueDate &&
      other.onboardingCountry == onboardingCountry &&
      other.onboardingState == onboardingState &&
      other.onboardingCity == onboardingCity &&
      other.geoBranch == geoBranch &&
      other.geoOffice == geoOffice &&
      other.birthplaceState == birthplaceState;
  }

  @override
  int get hashCode {
    return fullName.hashCode ^
      names.hashCode ^
      firstLastName.hashCode ^
      secondLastName.hashCode ^
      thirdLastName.hashCode ^
      address.hashCode ^
      profession.hashCode ^
      maritalStatus.hashCode ^
      birthDate.hashCode ^
      phoneNumber.hashCode ^
      docIdNumber.hashCode ^
      docIdExtension.hashCode ^
      docIdComplement.hashCode ^
      docIdDueDate.hashCode ^
      onboardingCountry.hashCode ^
      onboardingState.hashCode ^
      onboardingCity.hashCode ^
      geoBranch.hashCode ^
      geoOffice.hashCode ^
      birthplaceState.hashCode;
  }
}
