package com.selphi.flutter.plugin.selphi_face_plugin;

import android.util.Base64;

import com.facephi.fphiwidgetcore.WidgetConfiguration;
import com.facephi.fphiwidgetcore.WidgetLivenessMode;

import org.json.JSONObject;

public class SelphiFaceConfiguration {
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
        CONF_QR_FLAG("qrFlag"),
        CONF_CROP_PERCENT("cropPercent"),
        CONF_CROP("crop");

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
    public static WidgetConfiguration createWidgetConfiguration(String resourcesPath, JSONObject config) throws Exception {
        try {
            WidgetConfiguration conf = new WidgetConfiguration();

            conf.setResourcesPath(resourcesPath + ".zip");

            return processJSONConfiguration(conf, config);
        } catch (Exception exc) {
            throw exc;
        }
    }

    /**
     * Processes the JSON input argument and sets the configuration of the User Control.
     *
     * @param hybridConfiguration ReadableMap with input JS arguments.
     * @return Configuration of the widget
     */
    private static WidgetConfiguration processJSONConfiguration(WidgetConfiguration widgetConfiguration, JSONObject hybridConfiguration) throws Exception {
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
            if (actualObject.has(ConfigurationParams.CONF_QR_FLAG.getName()))
                widgetConfiguration.setQRFlag(actualObject.optBoolean(ConfigurationParams.CONF_QR_FLAG.getName(), false));

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
}