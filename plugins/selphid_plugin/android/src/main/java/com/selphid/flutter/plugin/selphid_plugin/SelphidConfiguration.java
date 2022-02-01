package com.selphid.flutter.plugin.selphid_plugin;

import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.lifecycle.Observer;

import com.facephi.fphiselphidwidgetcore.WidgetSelphIDConfiguration;

import org.json.JSONException;
import org.json.JSONObject;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.BasicMessageChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.StringCodec;

public class SelphidConfiguration
{
    /**
     * CONSTANTS
     **/
    private static final String SELPHID_LOG_EVENT_NAME = "onSelphidLogEvent";
    private static final String SELPHID_LOG_PARAM_NAME = "selphidLogInfo";

    protected enum ConfigurationParams {
        CONF_DEBUG("debug"),
        CONF_FULLSCREEN("fullscreen"),
        CONF_FRONTAL_CAMERA_PREFERRED("frontalCameraPreferred"),
        CONF_LOCALE("locale"),
        CONF_OCR_RESULTS("tokenImageQuality"),
        CONF_RESULT_AFTER_CAPTURE("showResultAfterCapture"),
        CONF_SCAN_MODE("scanMode"),
        CONF_SPECIFIC_DATA("specificData"),
        CONF_DOCUMENT_TYPE("documentType"),
        CONF_SHOW_TUTORIAL("showTutorial"),
        CONF_TOKEN_IMAGE_QUALITY("tokenImageQuality"),
        CONF_WIDGET_TIMEOUT("timeout"),
        CONF_VIDEO_FILENAME("videoFilename"),
        CONF_DOCUMENT_MODELS("documentModels"),
        CONF_ENABLE_EVENT_LISTENER("enableWidgetEventListener"),
        CONF_GENERATE_RAW_IMAGES("generateRawImages");

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
     */
    public static WidgetSelphIDConfiguration createWidgetConfiguration(String mode, String resourcesPath, String license, String ocrPreviousData, JSONObject config, PluginRegistry.Registrar mRegistrar, FlutterActivity mFlutterActivity) throws Exception {
        try { 
            WidgetSelphIDConfiguration conf = new WidgetSelphIDConfiguration();
            conf.setLicense(license);

            for (SelphidDocumentSide documentSide : SelphidDocumentSide.values())
                if(documentSide.getName().equals(mode)) {
                    conf.setDocumentSide(documentSide.getDocumentSide());
                    conf.setWizardMode(documentSide.getIsWizardMode());
                    break;
                }
            if(!conf.getWizardMode() && ocrPreviousData != null && !ocrPreviousData.isEmpty())
                conf.setTokenPreviousCaptureData(ocrPreviousData);
            conf.setResourcesPath(resourcesPath + ".zip");
            return processJSONConfiguration(conf, ocrPreviousData, config, mRegistrar, mFlutterActivity);
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
  private static WidgetSelphIDConfiguration processJSONConfiguration(WidgetSelphIDConfiguration widgetConfiguration, String ocrPreviousData, JSONObject hybridConfiguration, PluginRegistry.Registrar mRegistrar, FlutterActivity mFlutterActivity) throws Exception {
      try
      {
          JSONObject actualObject = hybridConfiguration;

          if (actualObject.length() == 0) return widgetConfiguration;

          if (actualObject.has(ConfigurationParams.CONF_DEBUG.getName())) widgetConfiguration.setDebug(actualObject.getBoolean(ConfigurationParams.CONF_DEBUG.getName()));
          if (actualObject.has(ConfigurationParams.CONF_FULLSCREEN.getName())) widgetConfiguration.setFullscreen(actualObject.getBoolean(ConfigurationParams.CONF_FULLSCREEN.getName()));
          if (actualObject.has(ConfigurationParams.CONF_LOCALE.getName())) widgetConfiguration.setLocale(actualObject.getString(ConfigurationParams.CONF_LOCALE.getName()));
          if (actualObject.has(ConfigurationParams.CONF_RESULT_AFTER_CAPTURE.getName())) widgetConfiguration.setShowAfterCapture(actualObject.getBoolean(ConfigurationParams.CONF_RESULT_AFTER_CAPTURE.getName()));
          if (actualObject.has(ConfigurationParams.CONF_SHOW_TUTORIAL.getName())) widgetConfiguration.setTutorialFlag(actualObject.getBoolean(ConfigurationParams.CONF_SHOW_TUTORIAL.getName()));
          if (actualObject.has(ConfigurationParams.CONF_TOKEN_IMAGE_QUALITY.getName())) widgetConfiguration.setTokenImageQuality((float)actualObject.optDouble(ConfigurationParams.CONF_TOKEN_IMAGE_QUALITY.getName(), 0.8));
          if (actualObject.has(ConfigurationParams.CONF_SPECIFIC_DATA.getName())) widgetConfiguration.setSpecificData(actualObject.optString(ConfigurationParams.CONF_SPECIFIC_DATA.getName()));
          if (actualObject.has(ConfigurationParams.CONF_DOCUMENT_MODELS.getName())) widgetConfiguration.setDocumentModels(actualObject.optString(ConfigurationParams.CONF_DOCUMENT_MODELS.getName()));
          if (actualObject.has(ConfigurationParams.CONF_VIDEO_FILENAME.getName())) widgetConfiguration.setVideoFilename(actualObject.optString(ConfigurationParams.CONF_VIDEO_FILENAME.getName()));

          if(widgetConfiguration.getWizardMode() && ocrPreviousData != null && !ocrPreviousData.isEmpty())
            if (actualObject.has(ConfigurationParams.CONF_OCR_RESULTS.getName())) widgetConfiguration.setTokenPreviousCaptureData(ocrPreviousData);

          if (actualObject.has(ConfigurationParams.CONF_FRONTAL_CAMERA_PREFERRED.getName())) {
              boolean isFrontalCamera = actualObject.optBoolean(ConfigurationParams.CONF_FRONTAL_CAMERA_PREFERRED.getName(), true);
              if (isFrontalCamera) widgetConfiguration.setFrontFacingCameraAsPreferred();
              else widgetConfiguration.setBackFacingCameraAsPreferred();
          }

          if (actualObject.has(ConfigurationParams.CONF_ENABLE_EVENT_LISTENER.getName()) &&
                  actualObject.getBoolean(ConfigurationParams.CONF_ENABLE_EVENT_LISTENER.getName())) {
              StartEventListener(widgetConfiguration, mRegistrar, (FlutterActivity) mFlutterActivity);
          }

          if (actualObject.has(ConfigurationParams.CONF_SCAN_MODE.getName())) {
              String scanModeParam = actualObject.optString(ConfigurationParams.CONF_SCAN_MODE.getName());
              for (SelphidScanMode scanMode : SelphidScanMode.values())
                  if(scanMode.getName().equals(scanModeParam)) {
                      widgetConfiguration.setScanMode(scanMode.getScanMode());
                      break;
                  }
          }

          if (actualObject.has(ConfigurationParams.CONF_DOCUMENT_TYPE.getName())) {
              String documentTypeParam = actualObject.optString(ConfigurationParams.CONF_DOCUMENT_TYPE.getName());
              for (SelphidDocumentType docType : SelphidDocumentType.values())
                  if(docType.getName().equals(documentTypeParam)) {
                      widgetConfiguration.setDocumentType(docType.getDocumentType());
                      break;
                  }
          }

          if (actualObject.has(ConfigurationParams.CONF_WIDGET_TIMEOUT.getName())) {
              String timeoutParam = actualObject.optString(ConfigurationParams.CONF_WIDGET_TIMEOUT.getName());
              for (SelphidWidgetTimeout timeout : SelphidWidgetTimeout.values())
                  if(timeout.getName().equals(timeoutParam)) {
                      widgetConfiguration.setTimeout(timeout.getWidgetTimeout());
                      break;
                  }
          }

          if (actualObject.has(ConfigurationParams.CONF_GENERATE_RAW_IMAGES.getName())) {
              boolean generateRawImages = actualObject.optBoolean(ConfigurationParams.CONF_GENERATE_RAW_IMAGES.getName(), false);
              if (generateRawImages) widgetConfiguration.setGenerateRawImages(true);
          }
      }
      catch(Exception exc) {
          throw exc;
      }
    return widgetConfiguration;
  }

    private static void StartEventListener(WidgetSelphIDConfiguration widgetConfiguration, final PluginRegistry.Registrar mRegistrar, final FlutterActivity mFlutterActivity) {
        widgetConfiguration.setIFPhiWidgetSelphIDEventListener_classname("com.selphid.flutter.plugin.selphid_plugin.SelphidEventListener");
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                SelphidFaceLogModel.getLogModel().getCurrentLog().observe(mFlutterActivity, new Observer<String>() {
                    @Override
                    public void onChanged(String logData) {
                        JSONObject params = new JSONObject();
                        try {
                            params.put(SELPHID_LOG_PARAM_NAME, logData);
                        } catch (JSONException e) {
                            Log.d("Event Exception:", e.getMessage());
                        }

                        BasicMessageChannel channel = new BasicMessageChannel(mRegistrar.messenger(), SELPHID_LOG_EVENT_NAME, StringCodec.INSTANCE);
                        channel.send(params.toString());
                    }
                });
            }
        });
    }
}
