class XNet {
  bool globalError;
  bool saveResponse;
  Function before;
  Function success;
  Function error;
  XNet(
      {this.success,
      this.error,
      this.before,
      this.globalError,
      this.saveResponse});
}
