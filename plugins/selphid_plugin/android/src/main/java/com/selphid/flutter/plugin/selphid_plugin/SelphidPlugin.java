package com.selphid.flutter.plugin.selphid_plugin;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.util.Log;

import com.facephi.fphiselphidwidgetcore.WidgetPersistentData;
import com.facephi.fphiselphidwidgetcore.WidgetSelphIDResult;
import org.json.JSONObject;
import java.util.HashMap;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * SelphidPlugin
 */
public class SelphidPlugin implements MethodCallHandler, PluginRegistry.ActivityResultListener {

    private static final int SELPHID_PLUGIN_OPERATION_FRONT = 19200;
    private static final int SELPHID_PLUGIN_OPERATION_BACK = 19201;
    private static final int SELPHID_PLUGIN_OPERATION_WIZARD = 19202;
    private static int imageQuality = 95;

    private static final String START_WIDGET = "startSelphIDWidget";
    private static final String START_TEST_WIDGET = "startSelphIDTestImageWidget";

    private static final String JSON_ERROR = "8200";
    private static final String GENERIC_ERROR = "8201";
    private static final String NATIVE_ERROR = "8202";
    private static final String NATIVE_RESULT_ERROR = "8203";
    private static String compressFormat = "JPEG";

    private static final String FRONT_MODE = "CaptureFront";
    private static final String BACK_MODE = "CaptureBack";

    private final Registrar mRegistrar;
    private Activity mActivity;
    private Result mResult = null;
    private FlutterActivity mFlutterActivity;

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "selphid_plugin");
        final SelphidPlugin instance = new SelphidPlugin(registrar);
        registrar.addActivityResultListener(instance);
        channel.setMethodCallHandler(instance);
    }

    private SelphidPlugin(Registrar registrar) {
        this.mRegistrar = registrar;
        this.mActivity = (Activity) getActiveContext();
        this.mFlutterActivity = (FlutterActivity) registrar.activity();
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        mResult = result;
        if (call.hasArgument("widgetConfigurationJSON")) {
            try {
                JSONObject config = new JSONObject((HashMap<String, Object>) call.argument("widgetConfigurationJSON"));
                String mode = "";
                String resourcesPath = "";
                String widgetLicense = "";
                String ocrPreviousData = "";
                String testImageName = call.hasArgument("testImageName") ? (String) call.argument("testImageName") : "";

                int operation = SELPHID_PLUGIN_OPERATION_WIZARD;

                if (call.hasArgument("operationMode")) {
                    mode = call.argument("operationMode");
                    if (mode.equals(FRONT_MODE)) {
                        operation = SELPHID_PLUGIN_OPERATION_FRONT;
                    }
                    if (mode.equals(BACK_MODE)) {
                        operation = SELPHID_PLUGIN_OPERATION_BACK;
                    }
                }
                if (call.hasArgument("resourcesPath")) {
                    resourcesPath = call.argument("resourcesPath");
                }
                if (call.hasArgument("widgetLicense")) {
                    widgetLicense = call.argument("widgetLicense");
                }
                if (call.hasArgument("previousOCRData")) {
                    ocrPreviousData = call.argument("previousOCRData");
                }
                if (call.method.equals(START_TEST_WIDGET)) {
                    Bitmap testing = SelphidUtils.getBitmapFromAsset(this.mActivity, testImageName);
                    WidgetPersistentData.getInstance().setTestingImage(testing);
                }
                launchWidgetCapture(operation, mode, resourcesPath, widgetLicense, ocrPreviousData, config);
            } catch (Exception e) {
                result.error(JSON_ERROR, "JSONException", e.getMessage());
            }
        }
    }

    /**
     * Processes the activity result from the User Control.
     *
     * @param operation       Index of the User Control operation
     * @param mode            Indicates the OCR scanning mode of documents. Depending on the choice, several or one specific document type will be scanned and searched.
     * @param resourcesPath   Sets the name of the resource file that the widget will use for its graphical configuration. This file is customizable and is in the plugin in the root path.
     * @param license         The SelphID widget is licensed and to use it a valid license (.lic file) will be required, which will be granted by Facephi.
     * @param ocrPreviousData Result of the ocrPreviousData
     * @param config          JSON array with input arguments.
     * @return True if plugin handles a particular action, and "false" otherwise. Note that this does indicate the success or failure of the handling.
     * Indicating success is failure is done by calling the appropriate method on the callbackContext. While our code only passes back a message
     */
    private boolean launchWidgetCapture(int operation, String mode, String resourcesPath, String license, String ocrPreviousData, JSONObject config) {
        try {
            checkImageParameters(config);

            Intent intent = new Intent(mActivity, com.facephi.selphid.Widget.class);
            intent.putExtra("configuration", SelphidConfiguration.createWidgetConfiguration(mode, resourcesPath, license, ocrPreviousData, config, mRegistrar, mFlutterActivity));
            mActivity.startActivityForResult(intent, operation);
        } catch (Exception exc) {
            System.err.println("Exception: " + exc.getMessage());
            mResult.error(NATIVE_ERROR, exc.getMessage(), null);
        }
        return true;
    }

    private void checkImageParameters(JSONObject config) {
        try {
            compressFormat = config.optString("compressFormat", "JPEG");
            imageQuality = config.optInt("imageQuality", 95);

            if (imageQuality > 0 && imageQuality < 90) {
                Log.w("Warning", "imageQuality selection not recommended");
            }
            if (imageQuality < 0 || imageQuality > 100) {
                imageQuality = 95;
            }
        }
        catch (Exception e) {
            System.err.println("Exception: " + e.getMessage());
        }
    }

    private Context getActiveContext() {
        return (mRegistrar.activity() != null) ? mRegistrar.activity() : mRegistrar.context();
    }

    /**
     * Processes the activity result from the User Control.
     *
     * @param requestCode Code Request
     * @param resultCode  Operation code
     * @param data        Result of the User Control
     */
    @Override
    public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
        try {
            if (requestCode != SELPHID_PLUGIN_OPERATION_FRONT &&
                    requestCode != SELPHID_PLUGIN_OPERATION_BACK &&
                    requestCode != SELPHID_PLUGIN_OPERATION_WIZARD) // Tutorial
                return false;

            if (requestCode == -1 || data == null) {
                //    this._callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.ERROR, new String()));
                mResult.error("Plugin Exception", "Can't perform native operation.", null);
                return false;
            }

            WidgetSelphIDResult ucResult = data.getParcelableExtra("result");
            SelphidOutputBundle output = new SelphidOutputBundle(ucResult, compressFormat, imageQuality);

            //  String result = output.ReturnOutputJSON().toString();
            //  this.mResult.success( result);
            this.mResult.success(output.ReturnOutputJSON(ucResult.getCaptureProgress()));

        } catch (Exception exc) {
            this.mResult.error(NATIVE_RESULT_ERROR, exc.getMessage(), null);
        }

        return true;
    }
}
