import 'dart:io';
import '../allUtils.dart';

class HttpOverridesCustom extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) {
    // tests that cert is self signed, correct subject and correct date(s) 
    DynamicLog.devPrint("Host: $host - Port: $port");
    return false;
  };
  }
}
