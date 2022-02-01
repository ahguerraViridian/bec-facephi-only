import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_svg/svg.dart';
import 'package:selphi_face_plugin/SelphiFaceFinishStatus.dart';
import '../../../services/services.dart';
import 'package:selphid_plugin/SelphIDFinishStatus.dart';
import '../../../config/config.dart';

import '../../../base/state/allState.dart';
import '../../../components/allComponents.dart';
import '../../../routes/onboarding/onboardingFacePhi/onboardingFacePhi_vm.dart';

import '../../../utils/allUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class VOnboardingFacePhi extends StatefulWidget {
  @override
  noSuchMethod(Invocation invocation) {
    return null;
  }

  _VOnboardingFacePhiState createState() => _VOnboardingFacePhiState();
}

class _VOnboardingFacePhiState extends State<VOnboardingFacePhi> {
  String _resourcesPath = "fphi-selphid-widget-resources-selphid-1.0";
  String _message = 'Preview selfie';
  Uint8List _frontDocumentImage;
  Uint8List _backDocumentImage;
  Uint8List _faceImage;
  String _rawFrontImage;
  String _rawBackImage;
  String _tokenFrontImage;
  String _tokenBackImage;
  String _fullName;
  String _documentNumber;
  String _dateOfBirth;
  String _address;
  String _expireDate;
  bool _noExpDate = false;

  Map<String, dynamic> _ocrResult;
  String license;
  String _selphiResourcesPath = "fphi-selphi-widget-resources-selphi-live-1.2";
  bool canContinue = false;
  Uint8List _bestImage;
  String _tokenBestImage;
  String _rawBestImage;
  Color _textColorMessage = Color(0xFF0099af);
  void _launchSelphIDCapture(VMOnboardingFacePhi vm) async {
    setState(() {
      _message = "Preview Selfie";
      _bestImage = null;
      _tokenBestImage = null;
      _rawBestImage = null;
      _frontDocumentImage = null;
      _backDocumentImage = null;
      _ocrResult = null;
      _faceImage = null;
      _ocrResult = null;
      _fullName = null;
      _documentNumber = null;
      _expireDate = null;
    });
    final selphIDWidgetResult = await Services.facePhiService
        .launchSelphIDCapture(_resourcesPath, license);
    return selphIDWidgetResult.fold((l) {
      setState(() {
        _message = l.toString();
        _frontDocumentImage = null;
        _backDocumentImage = null;
        _faceImage = null;
        _ocrResult = null;
        _fullName = null;
        _documentNumber = null;
      });
    }, (r) {
      final selphIDResult = r;
      // Manage Plugin process Status
      switch (selphIDResult.finishStatus) {
        case SelphIDFinishStatus.STATUS_OK: // OK
          setState(() {
            _message = 'Preview Selfie';
            _frontDocumentImage = selphIDResult.frontDocumentImage != null
                ? base64Decode(selphIDResult.frontDocumentImage)
                : null; // use _rawFrontImage instead
            _tokenFrontImage = selphIDResult.tokenFaceImage; // remove
            _rawFrontImage = selphIDResult
                .frontDocumentImage; // updated instead of selphIDResult.rawBackDocument
            _backDocumentImage = selphIDResult.backDocumentImage != null
                ? base64Decode(selphIDResult.backDocumentImage)
                : null; // use _rawBackImage instead
            _tokenBackImage = selphIDResult.tokenBackDocument; // remove
            _rawBackImage = selphIDResult
                .backDocumentImage; // updated instead of selphIDResult.rawBackDocument
            _faceImage = selphIDResult.faceImage != null
                ? base64Decode(selphIDResult.faceImage)
                : null;

            _ocrResult = json.decode(selphIDResult.documentData);

            _fullName = _ocrResult != null ? _ocrResult["FirstName"] : null;
            _documentNumber =
                _ocrResult != null ? _ocrResult["DocumentNumber"] : null;
            _expireDate = _ocrResult != null
                ? _ocrResult["DateOfExpiry"] != null
                    ? _ocrResult["DateOfExpiry"]
                    : null
                : null;
            _dateOfBirth = _ocrResult != null
                ? _ocrResult["DateOfBirth"] != null
                    ? _ocrResult["DateOfBirth"]
                    : null
                : null;
            _address = _ocrResult != null ? _ocrResult["Address"] : null;
          });
          _launchSelphiAuthenticate(vm);
          break;
        case SelphIDFinishStatus.STATUS_ERROR: // Error
          setState(() {
            _message = "${selphIDResult.errorMessage}";
            _frontDocumentImage = null;
            _backDocumentImage = null;
            _ocrResult = null;
            _faceImage = null;
            _ocrResult = null;
            _fullName = null;
            _documentNumber = null;
          });
          break;
        case SelphIDFinishStatus.STATUS_CANCEL_BY_USER: // CancelByUser
          setState(() {
            _message = 'The user cancelled the process';
            _frontDocumentImage = null;
            _backDocumentImage = null;
            _faceImage = null;
            _ocrResult = null;
            _fullName = null;
            _documentNumber = null;
          });
          break;
        case SelphIDFinishStatus.STATUS_TIMEOUT: // Timeout
          setState(() {
            _message = "${selphIDResult.errorMessage}";
            _frontDocumentImage = null;
            _backDocumentImage = null;
            _ocrResult = null;
            _faceImage = null;
            _ocrResult = null;
            _fullName = null;
            _documentNumber = null;
          });
          vm.showTimeoutDialog(true, () {
            _launchSelphIDCapture(vm);
          });
          break;
      }
    });
  }

  void _launchSelphiAuthenticate(VMOnboardingFacePhi vm) async {
    final selphiFaceWidgetResult = await Services.facePhiService
        .launchSelphiAuthenticate(_selphiResourcesPath);
    return selphiFaceWidgetResult.fold((l) {
      setState(() {
        _message = l.toString();
        _bestImage = null;
        _tokenBestImage = null;
        _rawBestImage = null;
        _frontDocumentImage = null;
        _backDocumentImage = null;
        _ocrResult = null;
        _faceImage = null;
        _ocrResult = null;
        _fullName = null;
        _documentNumber = null;
        _textColorMessage = Colors.red[800];
      });
    }, (r) async {
      final selphiFaceResult = r;
      // Manage Plugin process Status
      switch (selphiFaceResult.finishStatus) {
        case SelphiFaceFinishStatus.STATUS_OK: // OK
          vm.setLoadingState(true);
          String auxTokenImg = await Services.facePhiService
              .generateTemplateRaw(imageBase64: selphiFaceResult.bestImage);

          setState(() {
            _message = 'Preview Selfie';
            _bestImage =
                base64Decode(selphiFaceResult.bestImageCropped); // remove
            _tokenBestImage = auxTokenImg;
            _rawBestImage = selphiFaceResult.bestImage;
            _textColorMessage = Color(0xFF0099af);
          });

//////
          vm.setLoadingState(false);
          if (!true) {
            if (vm.onboardingData.docIDNumber != _documentNumber) {
              vm.showSnack(
                  "El número de documento no coincide con el que ingresaste.\nPor favor vuelve a realizar el proceso.\nDisculpa los inconvenientes");
              setState(() {
                _message =
                    "El número de documento no coincide con el que ingresaste.\nPor favor vuelve a realizar el proceso.\nDisculpa los inconvenientes";
                _bestImage = null;
                _tokenBestImage = null;
                _rawBestImage = null;
                _frontDocumentImage = null;
                _backDocumentImage = null;
                _ocrResult = null;
                _faceImage = null;
                _ocrResult = null;
                _fullName = null;
                _documentNumber = null;
              });
              return;
            }

            // vm.onCreate(
            //   backDocIdRawImage: _rawBackImage,
            //   frontDocIdFacePhiImage: _tokenFrontImage,
            //   frontDocIdRawIamge: _rawFrontImage,
            //   selfieFacePhiImage: _tokenBestImage,
            //   selfieRawImage: _rawBestImage,
            //   ocrDocIdNumber: _documentNumber,
            //   ocrFullname: _fullName,
            //   ocrDocIdDueDate: _expireDate,
            //   noExpireDate: _noExpDate,
            //   ocrBirthDate: _dateOfBirth,
            //   ocrAddress: _address,
            // );
          }

          break;
        case SelphiFaceFinishStatus.STATUS_ERROR: // Error
          setState(() {
            _message = "${selphiFaceResult.errorMessage}";
            _bestImage = null;
            _tokenBestImage = null;
            _rawBestImage = null;
            _frontDocumentImage = null;
            _backDocumentImage = null;
            _ocrResult = null;
            _faceImage = null;
            _ocrResult = null;
            _fullName = null;
            _documentNumber = null;
            _textColorMessage = Colors.red[800];
          });
          break;
        case SelphiFaceFinishStatus.STATUS_CANCEL_BY_USER: // CancelByUser
          setState(() {
            _message = 'The user cancelled the process';
            _bestImage = null;
            _tokenBestImage = null;
            _rawBestImage = null;
            _frontDocumentImage = null;
            _backDocumentImage = null;
            _ocrResult = null;
            _faceImage = null;
            _ocrResult = null;
            _fullName = null;
            _documentNumber = null;
            _textColorMessage = Colors.amber[800];
          });
          break;
        case SelphiFaceFinishStatus.STATUS_TIMEOUT: // Timeout
          setState(() {
            _message = 'Process finished by timeout';
            _bestImage = null;
            _tokenBestImage = null;
            _rawBestImage = null;
            _frontDocumentImage = null;
            _backDocumentImage = null;
            _ocrResult = null;
            _faceImage = null;
            _ocrResult = null;
            _fullName = null;
            _documentNumber = null;
            _textColorMessage = Colors.amber[800];
          });

          vm.showTimeoutDialog(false, () {
            _launchSelphIDCapture(vm);
          });
          break;
      }
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, VMOnboardingFacePhi>(
        distinct: true,
        converter: VMOnboardingFacePhi.fromStore,
        builder: (BuildContext context, VMOnboardingFacePhi vm) {
          DynamicLog.devPrint("////////--> StoreConnector - OnboardingFacePhi");
          canContinue = _tokenBestImage != null &&
              _rawBestImage != null &&
              _rawFrontImage != null &&
              _rawBackImage != null &&
              _documentNumber != null &&
              _fullName != null &&
              _tokenFrontImage != null;

          buildInitialView() {
            return Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  child: Card(
                      child: Center(
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.info,
                              color: Theme.of(context).primaryColor,
                              // color: Theme.of(context).textTheme.display2.color,
                            ),
                            Text(
                              "Instrucciones de uso",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                            '  - Ten listo tu Carnet de Identidad.'),
                                      ),
                                      // SvgPicture.asset(
                                      //   "assets/allContent/svg/front_ci_baneco.svg",
                                      //   semanticsLabel: 'ci logo',
                                      //   height: 30,
                                      // )
                                    ],
                                  ),
                                ),
                                Divider(),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                            '  - Prepárate para tomarte una selfie.'),
                                      ),
                                      // SvgPicture.asset(
                                      //   "assets/allContent/svg/selfie_baneco.svg",
                                      //   semanticsLabel: 'selfie logo',
                                      //   height: 30,
                                      // )
                                    ],
                                  ),
                                ),
                                Divider(),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text(
                                            '  - Busca un ambiente con buena iluminación'),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                        child: Text('  - Evita reflejos'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ]),
                    ),
                  )),
                ),
                Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(
                        width: double.infinity,
                        child: OutlineButtonBeco(
                          color: vm.viewState.isButtonLoading
                              ? "disabled"
                              : "enabled",
                          label: vm.viewState.isButtonLoading
                              ? "Cargando"
                              : "Iniciar Análisis de imágenes",
                          onTap: vm.viewState.isImageLoading
                              ? null
                              : () {
                                  _launchSelphIDCapture(vm);
                                },
                        ))),
              ],
            );
          }

          return WillPopScope(
            onWillPop: vm.onPop,
            child: SafeArea(
              top: true,
              bottom: true,
              child: Scaffold(
                key: vm.scaffoldKey,
                backgroundColor: Theme.of(context).bottomAppBarColor,
                appBar: AppBarBaneco.buildOnboardingAppBar(
                    context: context,
                    exitButton: true,
                    onExit: () {
                      vm.exitApp();
                    },
                    bankName: "BANCO ECONOMICO",
                    addLeading: Config.appFlavor != Flavor.PROD &&
                        Config.appFlavor != Flavor.STAGE &&
                        Config.appFlavor != Flavor.STAGE_V),
                body: Container(
                  child: ListView(
                    padding: EdgeInsets.only(left: 15.0, right: 15.0),
                    children: <Widget>[
                      SizedBox(height: 20.0),
                      !canContinue
                          ? Padding(
                              padding: EdgeInsets.only(top: 20, bottom: 10),
                              child: SvgPicture.asset(
                                "assets/allContent/svg/selfie_baneco.svg",
                                semanticsLabel: 'selfie logo',
                                height:
                                    MediaQuery.of(context).size.height * 0.125,
                              ),
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.only(
                          top: 10,
                        ),
                        child: SubtitleForm(
                          text: "Análisis de Carnet de Identidad y rostro",
                          align: TextAlign.center,
                          padding: EdgeInsets.symmetric(vertical: 0),
                        ),
                      ),
                      buildInitialView()
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        onInitialBuild: (vm) {
          // vm.onInit(context);

          if (Platform.isIOS)
            license = vm.config.selphidLicenseIos;
          else
            license = vm.config.selphidLicenseAndroid;
        },
        onWillChange: (vm, vm2) {});
  }
}
