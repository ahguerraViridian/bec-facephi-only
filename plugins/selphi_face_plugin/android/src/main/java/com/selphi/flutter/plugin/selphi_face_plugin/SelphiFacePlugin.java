package com.selphi.flutter.plugin.selphi_face_plugin;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import com.facephi.fphiwidgetcore.WidgetConfiguration;
import com.facephi.fphiwidgetcore.WidgetResult;
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
 * SelphiFacePlugin
 */
public class SelphiFacePlugin implements MethodCallHandler, PluginRegistry.ActivityResultListener {

    private static final String START_WIDGET = "startSelphiFaceWidget";
    private static final String GENERATE_TEMPLATE = "generateTemplateRaw";
    private static final String JSON_ERROR = "8200";
    private static final String NATIVE_ERROR = "8202";
    private static final String NATIVE_RESULT_ERROR = "8203";

    private static final int SELPHI_FACE_PLUGIN_OPERATION_AUTHENTICATE = 19101;

    private float _jpgQuality = 0.8f;

    private final Registrar mRegistrar;
    private Activity mActivity;
    private Result mResult = null;
    private FlutterActivity mFlutterActivity;
    private boolean _enableGenerateTemplateRaw = false;

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "selphi_face_plugin");
        final SelphiFacePlugin instance = new SelphiFacePlugin(registrar);
        registrar.addActivityResultListener(instance);
        channel.setMethodCallHandler(instance);
    }

    private SelphiFacePlugin(Registrar registrar) {
        this.mRegistrar = registrar;
        this.mActivity = (Activity) getActiveContext();

        this.mFlutterActivity = (FlutterActivity) registrar.activity();
        //this.mRegistrar = registrar;
        //this.mActivity = (Activity) getActiveContext();
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        mResult = result;

        if (call.method.equals(START_WIDGET))
        {
            if (call.hasArgument("widgetConfigurationJSON"))
            {
                try {
                    launchWidget(call);
                } catch (Exception e) {
                    result.error(JSON_ERROR, "JSONException", e.getMessage());
                    return;
                }
            } else {
                this.mResult.error(NATIVE_RESULT_ERROR, "Parameter 'widgetConfigurationJSON' doesn't exist", null);
                return;
            }
        }
        else if (call.method.equals(GENERATE_TEMPLATE))
        {
            if (call.hasArgument("imageBase64")) {
                Bitmap bmpImage = SelphiFaceImageUtils.toBitmap((String) call.argument("imageBase64"));
                byte[] bmpTemplate = WidgetConfiguration.generateTemplateRawFromBitmap(bmpImage);
                result.success(SelphiFaceImageUtils.toBase64(bmpTemplate));
                return;
            } else {
                this.mResult.error(NATIVE_RESULT_ERROR, "Parameter 'imageBase64' doesn't exist", null);
                return;
            }
        }
        else {
            this.mResult.error(NATIVE_RESULT_ERROR, "Plugin not implemented", null);
            return;
        }
    }

    private void launchWidget(MethodCall call) throws Exception {
        JSONObject jsonObject = new JSONObject((HashMap<String, Object>) call.argument("widgetConfigurationJSON"));
        String resourcesPath = "";
        if (call.hasArgument("resourcesPath")) {
            resourcesPath = call.argument("resourcesPath");
        }
        if (jsonObject.length() > 0) {
            _enableGenerateTemplateRaw = jsonObject.optBoolean("enableGenerateTemplateRaw", false);
        }

        this.launchActivityUC(SelphiFaceConfiguration.createWidgetConfiguration(resourcesPath, jsonObject, mRegistrar, mFlutterActivity), SELPHI_FACE_PLUGIN_OPERATION_AUTHENTICATE);
    }

    /**
     * Launches the User Control Activity selected by the user.
     *
     * @param conf      The User Control configuration
     * @param operation Index of the User Control operation
     * @return True if plugin handles a particular action, and "false" otherwise. Note that this does indicate the success or failure of the handling.
     * Indicating success is failure is done by calling the appropriate method on the callbackContext. While our code only passes back a message
     */
    private boolean launchActivityUC(WidgetConfiguration conf, int operation) {
        try {
            Intent intent = new Intent(mActivity, com.facephi.selphi.Widget.class);
            intent.putExtra("configuration", conf);

            mActivity.startActivityForResult(intent, operation);
        } catch (Exception exc) {
            System.err.println("Exception: " + exc.getMessage());
            mResult.error(NATIVE_ERROR, exc.getMessage(), null);
        }
        return true;
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
            if (requestCode != SELPHI_FACE_PLUGIN_OPERATION_AUTHENTICATE)
                return false;

            if (this.mResult == null)
                throw new Exception("Data processing error.");

            if (data == null) {
                this.mResult.error(NATIVE_RESULT_ERROR, "The widget result is null.", null);
                return false;
            }

            WidgetResult ucResult = data.getParcelableExtra("result");
            SelphiFaceOutputBundle output = new SelphiFaceOutputBundle(ucResult, _jpgQuality, _enableGenerateTemplateRaw);

            this.mResult.success(output.ReturnOutputJSON());

        } catch (Exception exc) {
            this.mResult.error(NATIVE_RESULT_ERROR, exc.getMessage(), null);
            return false;
        }

        return true;
    }
}