package com.selphi.flutter.plugin.selphi_face_plugin;

import android.os.Handler;
import android.os.Looper;
import android.util.Base64;
import android.util.Log;
import androidx.annotation.Nullable;
import androidx.lifecycle.Observer;
import com.facephi.fphiwidgetcore.WidgetConfiguration;
import com.facephi.fphiwidgetcore.WidgetLivenessMode;
import org.json.JSONException;
import org.json.JSONObject;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.StringCodec;

public class SelphiFaceConfiguration {
    /**
     * CONSTANTS
     **/
    private static final String SELPHI_LOG_EVENT_NAME = "onSelphiLogEvent";
    private static final String SELPHI_LOG_PARAM_NAME = "selphiLogInfo";
    private static final String SELPHI_LOG_QR_EVENT_NAME = "onSelphiLogQREvent";
    private static final String SELPHI_LOG_QR_PARAM_NAME = "qrData";

    private static final SelphiFaceObservableQR s = new SelphiFaceObservableQR(false);
    private static final SelphiFaceEventQRListener obs = new SelphiFaceEventQRListener();

    protected enum ConfigurationParams {
        CONF_DEBUG("debug"),
        CONF_FULLSCREEN("fullscreen"),
        CONF_FRONTAL_CAMERA_PREFERRED("frontalCameraPreferred"),
        CONF_LOCALE("locale"),
        CONF_LIVENESS_MODE("livenessMode"),
        CONF_ENABLE_IMAGES("enableImages"),
        CONF_SCENE_TIMEOUT("sceneTimeout"),
        CONF_JPG_QUALITY("jpgQuality"),
        CONF_U_TAGS("uTags"),
        CONF_DESIRED_CAMERA_WIDTH("desiredCameraWidth"),
        CONF_DESIRED_CAMERA_HEIGHT("desiredCameraHeight"),
        CONF_STABILIZATION_MODE("stabilizationMode"),
        CONF_TEMPLATE_RAW_OPTIMIZED("templateRawOptimized"),
        CONF_QR_FLAG("qrMode"),
        CONF_CROP_PERCENT("cropPercent"),
        CONF_CROP("crop"),
        CONF_ENABLE_EVENT_LISTENER("enableWidgetEventListener"),
        CONF_TRANSLATIONS_CONTENT("translationsContent"),
        CONF_VIEWS_CONTENT("viewsContent");

        private final String name;

        ConfigurationParams(String name) {
            this.name = name;
        }

        public String getName() {
            return this.name;
        }
    }

    /**
     * Configures the user control operation and launches the activity that will execute it.
     *
     * @return
     */
    public static WidgetConfiguration createWidgetConfiguration(String resourcesPath, JSONObject config, PluginRegistry.Registrar mRegistrar, FlutterActivity mFlutterActivity) throws Exception {
        try {
            WidgetConfiguration conf = new WidgetConfiguration();

            conf.setResourcesPath(resourcesPath + ".zip");

            return processJSONConfiguration(conf, config, mRegistrar, mFlutterActivity);
        } catch (Exception exc) {
            throw exc;
        }
    }

    /**
     * Processes the JSON input argument and sets the configuration of the User Control.
     *
     * @param hybridConfiguration ReadableMap with input JS arguments.
     * @param mRegistrar
     * @param mFlutterActivity
     * @return Configuration of the widget
     */
    private static WidgetConfiguration processJSONConfiguration(WidgetConfiguration widgetConfiguration, JSONObject hybridConfiguration, final PluginRegistry.Registrar mRegistrar, final FlutterActivity mFlutterActivity) throws Exception {
        try {
            JSONObject actualObject = hybridConfiguration;

            if (actualObject.length() == 0) return widgetConfiguration;

            if (actualObject.has(ConfigurationParams.CONF_DEBUG.getName()))
                widgetConfiguration.setDebug(actualObject.getBoolean(ConfigurationParams.CONF_DEBUG.getName()));
            if (actualObject.has(ConfigurationParams.CONF_FULLSCREEN.getName()))
                widgetConfiguration.setFullscreen(actualObject.getBoolean(ConfigurationParams.CONF_FULLSCREEN.getName()));
            if (actualObject.has(ConfigurationParams.CONF_LOCALE.getName()))
                widgetConfiguration.setLocale(actualObject.getString(ConfigurationParams.CONF_LOCALE.getName()));
            if (actualObject.has(ConfigurationParams.CONF_ENABLE_IMAGES.getName()))
                widgetConfiguration.logImages(actualObject.optBoolean(ConfigurationParams.CONF_ENABLE_IMAGES.getName(), true));
            if (actualObject.has(ConfigurationParams.CONF_SCENE_TIMEOUT.getName()))
                widgetConfiguration.setSceneTimeout((float) actualObject.optDouble(ConfigurationParams.CONF_SCENE_TIMEOUT.getName(), 0.0));
            if (actualObject.has(ConfigurationParams.CONF_JPG_QUALITY.getName()))
                widgetConfiguration.setJPGQuality((float) actualObject.optDouble(ConfigurationParams.CONF_JPG_QUALITY.getName(), 0.8f));
            if (actualObject.has(ConfigurationParams.CONF_DESIRED_CAMERA_WIDTH.getName()))
                widgetConfiguration.setParam("DesiredCameraWidth", String.valueOf(actualObject.optInt(ConfigurationParams.CONF_DESIRED_CAMERA_WIDTH.getName())));
            if (actualObject.has(ConfigurationParams.CONF_DESIRED_CAMERA_HEIGHT.getName()))
                widgetConfiguration.setParam("DesiredCameraHeight", String.valueOf(actualObject.optInt(ConfigurationParams.CONF_DESIRED_CAMERA_HEIGHT.getName())));
            if (actualObject.has(ConfigurationParams.CONF_STABILIZATION_MODE.getName()))
                widgetConfiguration.setStabilizationMode(actualObject.optBoolean(ConfigurationParams.CONF_STABILIZATION_MODE.getName(), false));
            if (actualObject.has(ConfigurationParams.CONF_TEMPLATE_RAW_OPTIMIZED.getName()))
                widgetConfiguration.setTemplateRawOptimized(actualObject.optBoolean(ConfigurationParams.CONF_TEMPLATE_RAW_OPTIMIZED.getName(), false));
            if (actualObject.has(ConfigurationParams.CONF_QR_FLAG.getName()) &&
                    actualObject.getBoolean(ConfigurationParams.CONF_QR_FLAG.getName())) {
                widgetConfiguration.setQRFlag(actualObject.optBoolean(ConfigurationParams.CONF_QR_FLAG.getName(), false));
                StartEventQRListener(widgetConfiguration, mRegistrar, mFlutterActivity);
            }
            if (actualObject.has(ConfigurationParams.CONF_FRONTAL_CAMERA_PREFERRED.getName())) {
                boolean isFrontalCamera = actualObject.optBoolean(ConfigurationParams.CONF_FRONTAL_CAMERA_PREFERRED.getName(), true);
                if (isFrontalCamera) widgetConfiguration.setFrontFacingCameraAsPreferred();
                else widgetConfiguration.setBackFacingCameraAsPreferred();
            }

            if (actualObject.has(ConfigurationParams.CONF_LIVENESS_MODE.getName())) {
                String livenessMode = actualObject.optString(ConfigurationParams.CONF_LIVENESS_MODE.getName());
                if (livenessMode.equalsIgnoreCase("PASSIVE")) {
                    widgetConfiguration.setParam("DesiredCameraWidth", "1280");
                    widgetConfiguration.setParam("DesiredCameraHeight", "720");
                    widgetConfiguration.setLivenessMode(WidgetLivenessMode.LIVENESS_PASSIVE);
                } else widgetConfiguration.setLivenessMode(WidgetLivenessMode.LIVENESS_NONE);
            }

            if (actualObject.has(ConfigurationParams.CONF_U_TAGS.getName())) {
                String userTagsStr = actualObject.optString("uTags", null);
                byte[] userTags;
                if (userTagsStr != null && !userTagsStr.isEmpty()) {
                    userTags = Base64.decode(userTagsStr, Base64.DEFAULT);
                    widgetConfiguration.setUserTags(userTags);
                }
            }

            if (actualObject.has(ConfigurationParams.CONF_ENABLE_EVENT_LISTENER.getName()) &&
                    actualObject.getBoolean(ConfigurationParams.CONF_ENABLE_EVENT_LISTENER.getName())) {
                StartEventListener(widgetConfiguration, mRegistrar, (FlutterActivity) mFlutterActivity);
            }

            if (actualObject.has(ConfigurationParams.CONF_VIEWS_CONTENT.getName())) {
                String viewsContent = actualObject.optString(ConfigurationParams.CONF_VIEWS_CONTENT.getName(), "");
                if (!viewsContent.equals(""))
                    widgetConfiguration.setViewsContent(viewsContent);
            }

            if (actualObject.has(ConfigurationParams.CONF_TRANSLATIONS_CONTENT.getName())) {
                String translationsContent = actualObject.optString(ConfigurationParams.CONF_TRANSLATIONS_CONTENT.getName(), "");
                if (!translationsContent.equals(""))
                    widgetConfiguration.setTranslationsContent(translationsContent);
            }

            if (actualObject.has(ConfigurationParams.CONF_CROP_PERCENT.getName()))
                if (widgetConfiguration.getExtractionConfig() != null)
                    widgetConfiguration.getExtractionConfig().setCropImagePercent((float) actualObject.getDouble(ConfigurationParams.CONF_CROP_PERCENT.getName()));
            if (actualObject.has(ConfigurationParams.CONF_CROP.getName()))
                if (widgetConfiguration.getExtractionConfig() != null)
                    widgetConfiguration.getExtractionConfig().setCropImageDebug(actualObject.getBoolean(ConfigurationParams.CONF_CROP.getName()));
        } catch (Exception exc) {
            throw exc;
        }
        return widgetConfiguration;
    }

    private static void StartEventQRListener(WidgetConfiguration widgetConfiguration, final PluginRegistry.Registrar mRegistrar, final FlutterActivity mFlutterActivity) {
        widgetConfiguration.setIFPhiWidgetQR_classname("com.selphi.flutter.plugin.selphi_face_plugin.SelphiFaceEventQRListener");

        s.addObserver(obs); // Add the Observer
        if (s.getIsValid()) {
            // IMPORTANT. // Make changes to the Subject.
            s.setIsValid(false);
        }

        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                SelphiFaceLogQRModel.getLogModel().getCurrentLog().observe(mFlutterActivity, new Observer<String>() {
                    @Override
                    public void onChanged(String logData) {
                        JSONObject params = new JSONObject();
                        try {
                            params.put(SELPHI_LOG_QR_PARAM_NAME, logData);
                        } catch (JSONException e) {
                            Log.d("Event Exception:", e.getMessage());
                        }

                        BasicMessageChannel channel = new BasicMessageChannel(mRegistrar.messenger(), SELPHI_LOG_QR_EVENT_NAME, StringCodec.INSTANCE);
                        channel.send(params.toString(), new BasicMessageChannel.Reply() {
                            @Override
                            public void reply(@Nullable Object reply) {
                                Log.i("obj", reply.toString());
                                if (reply.equals("true")) {
                                    // Make changes to the Subject.
                                    s.setIsValid(true);
                                }
                            }
                        });
                    }
                });
            }
        });
    }

    private static void StartEventListener(WidgetConfiguration widgetConfiguration, final PluginRegistry.Registrar mRegistrar, final FlutterActivity mFlutterActivity) {
        widgetConfiguration.setIFPhiWidgetEventListener_classname("com.selphi.flutter.plugin.selphi_face_plugin.SelphiFaceEventListener");
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                SelphiFaceLogModel.getLogModel().getCurrentLog().observe(mFlutterActivity, new Observer<String>() {
                    @Override
                    public void onChanged(String logData) {
                        JSONObject params = new JSONObject();
                        try {
                            params.put(SELPHI_LOG_PARAM_NAME, logData);
                        } catch (JSONException e) {
                            Log.d("Event Exception:", e.getMessage());
                        }

                        BasicMessageChannel channel = new BasicMessageChannel(mRegistrar.messenger(), SELPHI_LOG_EVENT_NAME, StringCodec.INSTANCE);
                        channel.send(params.toString());
                    }
                });
            }
        });
    }
}