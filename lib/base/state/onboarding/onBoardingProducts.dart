import '../../../base/state/allState.dart';

class StOnboardingProducts {
  List<StOnboardingProduct> onboardingProducts = [];
  void clearProducts() {
    onboardingProducts.clear();
  }

  void addProduct(StOnboardingProduct newProduct) {
    if (newProduct != null) onboardingProducts.add(newProduct);
  }

  List<StOnboardingProduct> getData() {
    return onboardingProducts;
  }
}

class StOnboardingProduct {
  String code;
  String type;
  String processType;
  String name;
  String status;
  String description;
  String features;
  String imgURL;
  String imageBase64;
  String validSinceDate;
  String terms;
  int geoFenceId;
  bool requiresDelivery;
  String deliveryTitle;
  bool selectPickupOffice;
  String selectPickupBankOffice;
  List<StAccountDocument> documentList;

  List<StPickupBranch> pickupBranchList = [];
  int maxAssociatedAccounts;
  bool withCustomImage;
  String costCurrency;
  String costCurrencyDisplay;
  double amountNewProduct;
  double amountRenewProduct;
  String pickupOfficeMessageLabel;
  String deliveryMessageLabel;
  StOnboardingProduct({
    this.code,
    this.type,
    this.processType,
    this.description,
    this.features,
    this.imgURL,
    this.name,
    this.status,
    this.validSinceDate,
    this.terms,
    this.geoFenceId,
    this.requiresDelivery,
    this.selectPickupOffice,
    this.deliveryTitle,
    this.documentList,
    this.selectPickupBankOffice,
    this.pickupBranchList,
    this.maxAssociatedAccounts,
    this.withCustomImage,
    this.amountNewProduct,
    this.amountRenewProduct,
    this.costCurrency,
    this.costCurrencyDisplay,
    this.imageBase64,
    this.deliveryMessageLabel,
    this.pickupOfficeMessageLabel,
  });

  List<Map> getPickupBranchOptions(bool defaullOpt) {
    List<Map> res = [];
    if (defaullOpt == true) {
      res.add({"text": "Seleccione una sucursal", "value": ""});
    }

    res.addAll(pickupBranchList.map((StPickupBranch pb) {
      return pb.getDataOption();
    }).toList());
    return res;
  }

  List<Map> getPickupOfficeOptions(String branchCode, bool defaullOpt) {
    if (branchCode == null || branchCode == "") {
      return [];
    }

    StPickupBranch pb = findBranch(branchCode);
    if (pb != null) {
      return pb.getPickupOfficeOptions(defaullOpt);
    }
    return null;
  }

  StPickupBranch findBranch(String branchCode) {
    return pickupBranchList.singleWhere((StPickupBranch sfd) {
      return sfd.branchCode == branchCode;
    }, orElse: () {
      return StPickupBranch(
        branchCode: branchCode,
        branchDescription: "Desconocido",
      );
    });
  }
}

class StAccountDocument {
  String type;
  String name;
  StAccountDocument({
    this.name,
    this.type,
  });
}

class StPickupOffice {
  String officeCode;
  String officeDescription;
  StPickupOffice({
    this.officeCode,
    this.officeDescription,
  });

  Map getDataOption() {
    return {"text": officeDescription, "value": officeCode};
  }
}

class StPickupBranch {
  String branchCode; //string	Código de la sucursal
  String branchDescription; // Descripción/nombre de la sucursal
  List<StPickupOffice> pickupOfficeList =
      []; //	Opcional:  Lista de oficinas en las que se puede retirar el producto.

  List<Map> getPickupOfficeOptions(bool defaullOpt) {
    List<Map> res = [];
    if (defaullOpt == true) {
      res.add({"text": "Seleccione una sucursal", "value": ""});
    }

    res.addAll(pickupOfficeList.map((StPickupOffice po) {
      return po.getDataOption();
    }).toList());
    return res;
  }

  StPickupBranch({
    this.branchCode,
    this.branchDescription,
    this.pickupOfficeList,
  });
  Map getDataOption() {
    return {"text": branchDescription, "value": branchCode};
  }
}
