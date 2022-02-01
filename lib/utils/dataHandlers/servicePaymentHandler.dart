class ServicePaymentHandler {
  static String getPickupAddress(Map invoiceDelivery) {
    String result = "";
    switch (invoiceDelivery["type"]) {
      case "BANKOFFICE":
        result = invoiceDelivery["invoiceDeliveryOffice"]["pickupBranch"] +
            " / " +
            invoiceDelivery["invoiceDeliveryOffice"]["pickupOffice"];
        break;
      case "ADDRESS":
        result = invoiceDelivery["invoiceDeliveryAddress"]["deliveryState"] +
            " / " +
            invoiceDelivery["invoiceDeliveryAddress"]["deliveryCity"] +
            " / " +
            invoiceDelivery["invoiceDeliveryAddress"]["deliveryArea"] +
            " / " +
            invoiceDelivery["invoiceDeliveryAddress"]["deliveryAddress"] +
            " / " +
            invoiceDelivery["invoiceDeliveryAddress"]["deliveryNumber"];
        break;
      default:
        result = "?";
    }
    return result;
  }
}
