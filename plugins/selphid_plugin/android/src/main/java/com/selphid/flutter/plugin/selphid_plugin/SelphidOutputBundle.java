package com.selphid.flutter.plugin.selphid_plugin;

import android.graphics.Bitmap;
import com.facephi.fphiselphidwidgetcore.WidgetSelphIDResult;
import org.json.JSONException;
import org.json.JSONObject;
import java.util.HashMap;

public class SelphidOutputBundle {
    public int _finishStatus = 1;
    private int _errorDiagnostic = 2;
    private int _timeoutStatus = -1;

    private String _errorMessage = null;
    private String _documentCaptured = null;
    private String _frontDocumentImage = null;
    private String _backDocumentImage = null;
    private String _faceImage = null;
    private String _rawFrontDocument = null;
    private String _rawBackDocument = null;
    private String _signatureImage = null;
    private String _fingerprintImage = null;
    private String _tokenOCR = null;
    private String _tokenFaceImage = null;
    private String _tokenFrontDocument = null;
    private String _tokenBackDocument = null;
    private String _tokenRawFrontDocument = null;
    private String _tokenRawBackDocument = null;
    private String _documentData = null;

    private float _matchingSidesScore = 0.0f;

    /**
     * @param result Control result
     * @description Default constructor. Process the User Control result and encapsulates his values
     */
    public SelphidOutputBundle(WidgetSelphIDResult result, String compressFormat, int imageQuality)
    {
        Bitmap.CompressFormat format = Bitmap.CompressFormat.JPEG;

        if (result.getException() != null) {
            if (result.getException().getExceptionType() != null) {
                switch (result.getException().getExceptionType()) {
                    case StoppedManually:
                        _finishStatus = 3; // CancelByUser
                        _errorDiagnostic = 2; // NoError
                        return;
                    case Timeout:
                        _finishStatus = 4; // Timeout
                        _errorDiagnostic = 2; // NoError
                        return;
                    case None:
                        _finishStatus = 1; // Ok
                        _errorDiagnostic = 2; // NoError
                        break;
                    case CameraPermissionDenied:
                        _finishStatus = 2; // Error
                        _errorDiagnostic = 3; // CameraPermissionDenied
                        return;
                    case SettingsPermissionDenied:
                        _finishStatus = 2; // Error
                        _errorDiagnostic = 4; // SettingsPermissionDenied
                        return;
                    case HardwareError:
                        _finishStatus = 2; // Error
                        _errorDiagnostic = 5; // HardwareError
                        return;
                    /** NUEVOS CASES **/
                    case ExtractionLicenseError:
                        _finishStatus = 2; // Error
                        _errorDiagnostic = 6; // ExtractionLicenseError
                        return;
                    case UnexpectedCaptureError:
                        _finishStatus = 2; // Error
                        _errorDiagnostic = 7; // UnexpectedCaptureError
                        return;
                    case ControlNotInitializedError:
                        _finishStatus = 2; // Error
                        _errorDiagnostic = 8; // ControlNotInitializedError
                        return;
                    case BadExtractorConfiguration:
                        _finishStatus = 2; // Error
                        _errorDiagnostic = 9; // ControlNotInitializedError
                        return;
                    default:
                        _finishStatus = 2; // Error
                        _errorDiagnostic = 1; // UnknownError
                        return;
                }
            } else {
                _finishStatus = 2; // Error
                _errorDiagnostic = 1; // UnknownError
                _errorMessage = result.getException().getMessage();
                return;
            }
        }

        if (compressFormat.toUpperCase().contains("PNG")) {
            format = Bitmap.CompressFormat.PNG;
        }

        _timeoutStatus = result.getCaptureProgress();

        _frontDocumentImage = SelphidUtils.processPicture(result.getDocumentFrontImage(), format, imageQuality);
        _backDocumentImage = SelphidUtils.processPicture(result.getDocumentBackImage(), format, imageQuality);
        _faceImage = SelphidUtils.processPicture(result.getFaceImage(), format, imageQuality);
        _signatureImage = SelphidUtils.processPicture(result.getSignatureImage(), format, imageQuality);
        _fingerprintImage = SelphidUtils.processPicture(result.getFingerprintImage(), format, imageQuality);
        _rawFrontDocument = SelphidUtils.processPicture(result.getRawDocumentFrontImage(), format, imageQuality);
        _rawBackDocument = SelphidUtils.processPicture(result.getRawDocumentBackImage(), format, imageQuality);

        // TODO TESTING STUB
        _tokenOCR = result.getTokenOCR();
        _tokenFaceImage = result.getTokenFaceImage();
        _tokenFrontDocument = result.getTokenFrontDocument();
        _tokenBackDocument = result.getTokenBackDocument();
        _tokenRawFrontDocument = result.getTokenRawFrontDocument();
        _tokenRawBackDocument = result.getTokenRawBackDocument();

        if (result.ocrResults != null)
            _documentData = (new JSONObject(result.ocrResults)).toString();

        _documentCaptured = result.getDocumentCaptured();
        _matchingSidesScore = result.getMatchingSidesScore();
    }


    /**
     * @param errorMessage The error message.
     * @description Sets the results message.
     */
    public void setResultMessage(String errorMessage) {
        _errorMessage = errorMessage;
    }

    /**
     * @description Result output values in JSON format.
     */
    public HashMap<String, Object> ReturnOutputJSON(int timeoutStatus) throws JSONException {
        HashMap<String, Object> result = new HashMap<>();

        result.put("finishStatus", _finishStatus);
        result.put("errorType", _errorDiagnostic);
        result.put("errorMessage", _errorMessage);
        result.put("timeoutStatus", timeoutStatus);

        if (_frontDocumentImage != null) result.put("frontDocumentImage", _frontDocumentImage);
        if (_backDocumentImage != null) result.put("backDocumentImage", _backDocumentImage);
        if (_faceImage != null) result.put("faceImage", _faceImage);
        if (_signatureImage != null) result.put("signatureImage", _signatureImage);
        if (_fingerprintImage != null) result.put("fingerprintImage", _fingerprintImage);
        if (_rawFrontDocument != null) result.put("rawFrontDocument", _rawFrontDocument);
        if (_rawBackDocument != null) result.put("rawBackDocument", _rawBackDocument);
        if (_tokenFrontDocument != null) result.put("tokenFrontDocument", _tokenFrontDocument);
        if (_tokenBackDocument != null) result.put("tokenBackDocument", _tokenBackDocument);

        // TODO TESTING STUB
        if (_tokenOCR != null) result.put("tokenOCR", _tokenOCR);
        if (_tokenFaceImage != null) result.put("tokenFaceImage", _tokenFaceImage);
        if (_tokenRawFrontDocument != null)
            result.put("tokenRawFrontDocument", _tokenRawFrontDocument);
        if (_tokenRawBackDocument != null)
            result.put("tokenRawBackDocument", _tokenRawBackDocument);
        if (_documentData != null) result.put("documentData", _documentData);
        if (_documentCaptured != null) result.put("lastDocumentCaptured", _documentCaptured);

        result.put("matchingSidesScore", _matchingSidesScore);
        return result;
    }
}