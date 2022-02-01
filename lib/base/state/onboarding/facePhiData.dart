class StFacePhiData {
  String selfieFacePhiImage;
  String selfieRawImage;
  String frontDocIdFacePhiImage;
  String frontDocIdRawIamge;
  String backDocIdRawImage;
  String ocrDocIdNumber;
  String ocrFullname;
  String ocrDocIdDueDate;
  String ocrAddress;
  String ocrBirthDate;
  StFacePhiData({
    this.backDocIdRawImage,
    this.frontDocIdFacePhiImage,
    this.frontDocIdRawIamge,
    this.ocrDocIdNumber,
    this.ocrFullname,
    this.ocrDocIdDueDate,
    this.selfieFacePhiImage,
    this.selfieRawImage,
    this.ocrAddress,
    this.ocrBirthDate,
  });
  Map toMap() {
    return {
      "selfieFacePhiImage": selfieFacePhiImage,
      "selfieRawImage": selfieRawImage,
      "frontDocIdFacePhiImage": frontDocIdFacePhiImage,
      "frontDocIdRawImage": frontDocIdRawIamge,
      "backDocIdRawImage": backDocIdRawImage,
      "ocrDocIdNumber": ocrDocIdNumber,
      "ocrFullname": ocrFullname,
      "ocrDocIdDueDate": ocrDocIdDueDate,
      "ocrAddress": ocrAddress,
      "ocrBirthDate": ocrBirthDate,
    };
  }
}
