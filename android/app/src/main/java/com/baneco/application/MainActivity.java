package com.baneco.application;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.app.NotificationManager;
import android.content.Context;
import android.os.Environment;
import android.util.Log;
import android.app.NotificationChannel;
import android.widget.EditText;
import android.widget.Toast;
import androidx.core.app.ActivityCompat;
import androidx.core.content.ContextCompat;

import io.flutter.plugins.GeneratedPluginRegistrant;
//import io.flutter.app.FlutterFragmentActivity;
import io.flutter.embedding.android.FlutterFragmentActivity;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Iterator;

import io.flutter.plugin.common.MethodChannel;
import androidx.annotation.NonNull;
import android.provider.Settings;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
// import com.example.vumodule.VUActivity;

// import retrofit2.Response;

import android.app.Dialog;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.drawable.ColorDrawable;
import android.os.Build;
import android.util.Base64;
import android.util.Log;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.Spinner;
import android.widget.Toast;
import androidx.appcompat.app.AppCompatActivity;
import java.io.IOException;
import java.util.HashMap;
import java.util.Objects;


import static android.content.ContentValues.TAG;

public class MainActivity extends FlutterFragmentActivity {

  private static final String REGISTER_NOTIFICATION_CHANNEL = "RegisterNotificationChannel";
  private static final String NOTIFICATION_CHANNEL = "MyNotificationChannel";
  private static final String FACEBOOK_EVENTS_CHANNEL = "FacebookInstallEventChannel";
  private static final String SHARED_IMAGE_CHANNEL = "SharedImageChannel";
  private static final String PERMISSIONS_CHANNEL = "PermissionsChannel";
  private static final String VU_CHANNEL = "com.baneco.application/vu";
  private static final String LOG_INTENTS = "LOG_INTENTS";
  private static final String INTENT_CHANNEL = "intentHandleChannel";
  private static final String FIREBASE_TEST_LAB_CHANNEL = "firebaseTestLabChannel";
  MethodChannel.Result vuResult;
  private byte[] inputData;
  private static final int MY_PERMISSIONS_REQUEST_WRITE_EXTERNAL_STORAGE = 1234;
  Activity thisActivity = this;
  MethodChannel.Result permissionsResult;


  @Override
   public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
      GeneratedPluginRegistrant.registerWith(flutterEngine);
    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), REGISTER_NOTIFICATION_CHANNEL).setMethodCallHandler((call, result) -> {
      if(call.method.equals("registerChannel")) {
        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
          String id = getResources().getString(R.string.notification_channel_id);
          String name = getResources().getString(R.string.notification_channel_name);
          String description = getResources().getString(R.string.notification_channel_desc);

          NotificationManager notificationManager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
          NotificationChannel mChannel = new NotificationChannel(id, name, NotificationManager.IMPORTANCE_HIGH);
          mChannel.setDescription(description);

          notificationManager.createNotificationChannel(mChannel);
          result.success("Notification channel " + name + " created");
        } else {
          result.success("Android version is less than Oreo");
        }
      }
    });

    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), NOTIFICATION_CHANNEL).setMethodCallHandler((call, result) -> {
      if (call.method.equals("clearNotifications")) {
        cancelAllNotifications();
        result.success("Success!");
      } else {
        result.notImplemented();
      }
    });

    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), SHARED_IMAGE_CHANNEL).setMethodCallHandler((call, result) -> {
      if (call.method.contentEquals("getSharedImage")) {
        result.success(inputData);
        inputData = null;
        return ;
      }
    });

    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), PERMISSIONS_CHANNEL).setMethodCallHandler((call, result) -> {
      if (call.method.contentEquals("checkWriteExternalStoragePermission")) {
        boolean response = isAPI23Up()? checkPermission(thisActivity) : true;
        result.success(response);
        return;
      }
      if (call.method.equals("requestWriteExternalStoragePermission")) {
        permissionsResult = result;
        if (isAPI23Up()) {
          requestPermission(thisActivity);
        }
        else {
          result.success(true);
        }
        return;
      }
    });

    new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), FIREBASE_TEST_LAB_CHANNEL).setMethodCallHandler((call, result) -> {
          if (call.method.contentEquals("isCurrentlyRunningFirebaseTestLab")) {
              boolean response = isRunningFirebaseTestLab();
              result.success(response);
          }

      });
      new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), INTENT_CHANNEL).setMethodCallHandler((call, result) -> {
          System.out.println("CALL METHOD ===> " + call.method);
          if (call.method.contentEquals("launchThirdPartyApp")) {

              String packageName = call.argument("packageName");
              Map args =  call.argument("args");
              System.out.println("PACKAGE NAME ===> " + call.argument("packageName"));
              if(packageName != null)
              openApp(packageName, result, args);


          } 
          if (call.method.contentEquals("launchThirdPartyLinkserApp")) {


            String base64 =  call.argument("payload");
            System.out.println("BASE 64 payload ===> " + base64);

            openLinkserApp(result, base64);

          }
          if (call.method.contentEquals("launchFileExplorer")) {


              String filePath =  call.argument("filePath");

              launchFileExplorer(result, filePath);

          }
      });
    // new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), VU_CHANNEL).setMethodCallHandler((call, result) -> {
    //   if (call.method.contentEquals("VU_SDK")) {

    //     Intent getVUScreenIntent = new Intent(this,VUActivity.class);
    //     String mode = call.argument("mode");
    //     Log.i("REGFront", "Received from flutter..... "+mode);
    //     getVUScreenIntent.putExtra("MODE",mode);
    //     vuResult = result;
    //     startActivityForResult(getVUScreenIntent, 100);

    //   }
    // });

    Intent intent = getIntent();
    onNewIntent(intent);
    String action = intent.getAction();
    String type = intent.getType();
    String TAG = "intentTest";
    if ((Intent.ACTION_SEND.equals(action) || Intent.ACTION_SEND_MULTIPLE.equals(action)) && type != null) {
      Log.d(TAG, "handleSendIntent: Intent type: " + type);
      if ("image/*".equals(type)||"image/jpg".equals(type)||"image/jpeg".equals(type)||"image/png".equals(type)) {
        handleSendText(intent, action); // Handle text being sent
      }
    }
 }



  @Override
  protected void onNewIntent(Intent intent) {
    super.onNewIntent(intent);
    Log.d("intentTest", "onNewIntent()...");
    String action = intent.getAction();
    String type = intent.getType();
    String TAG = "intentTest";
    Log.d(TAG, "handleSendIntent: action type: " + action);
    if ((Intent.ACTION_SEND.equals(action) || Intent.ACTION_SEND_MULTIPLE.equals(action)) && type != null) {
      Log.d(TAG, "handleSendIntent: Intent type: " + type);
      if ("image/*".equals(type)||"image/jpg".equals(type)||"image/jpeg".equals(type)||"image/png".equals(type)) {
        handleSendText(intent, action); // Handle text being sent
      }
    }
    new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), SHARED_IMAGE_CHANNEL).setMethodCallHandler((call, result) -> {
      if (call.method.contentEquals("getSharedImage")) {
        result.success(inputData);
        inputData = null;
      }
    });
  }


  public void handleSendText(Intent intent, String action) {
    String TAG = "intentTest";
    Uri selectedImageUri;
    if (Intent.ACTION_SEND_MULTIPLE.equals(action)){
      ArrayList arrayInt = intent.getParcelableArrayListExtra(Intent.EXTRA_STREAM);
      Log.d(TAG, "handleSendIntent: Object is: "+arrayInt.get(0));
      Log.d(TAG, "handleSendIntent: Object name is: "+arrayInt.get(0).getClass().getName());
      selectedImageUri = (Uri) arrayInt.get(0);
    } else{
      selectedImageUri= intent.getParcelableExtra(Intent.EXTRA_STREAM);
      Log.d(TAG, "handleSendIntent: Object is: "+selectedImageUri);
      Log.d(TAG, "handleSendIntent: Object name is: "+selectedImageUri.getClass().getName());
    }

    try {
      Log.d(TAG, "handleSendIntent: Fetching image data...");
      InputStream iStream =   getContentResolver().openInputStream(selectedImageUri);
      inputData = getBytes(iStream);
    } catch (FileNotFoundException e) {
      if (e.getMessage().contains("permission denied")){
        inputData = new byte[] {(byte)0xe0};
      }
      e.printStackTrace();
      Log.e(TAG, "handleSendIntent: ERROR: "+e);
    }
//    catch (IOException e) {
//      e.printStackTrace();
//      Log.e(TAG, "handleSendIntent: ERROR: "+e);
//    }
    catch(Exception e) {
      e.printStackTrace();
      Log.e(TAG, "handleSendIntent: ERROR: "+e);
    }
  }

  public byte[] getBytes(InputStream inputStream) throws IOException {
    ByteArrayOutputStream byteBuffer = new ByteArrayOutputStream();
    int bufferSize = 1024;
    byte[] buffer = new byte[bufferSize];

    int len = 0;
    while ((len = inputStream.read(buffer)) != -1) {
      byteBuffer.write(buffer, 0, len);
    }
    return byteBuffer.toByteArray();
  }

  private boolean isRunningFirebaseTestLab(){
      boolean result = false;
      String testLabSetting = Settings.System.getString(getContentResolver(), "firebase.test.lab");
      if ("true".equals(testLabSetting)) {
          result = true;
      }

      return result;
  }

  private boolean isAPI23Up () {
    return android.os.Build.VERSION.SDK_INT >= Build.VERSION_CODES.M;
  }

  private boolean checkPermission (Activity thisActivity) {
    return ContextCompat.checkSelfPermission(thisActivity,Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED;
  }

  private void requestPermission (Activity thisActivity) {
    Log.i(TAG, "requestPermission: REQUESTING");
    ActivityCompat.requestPermissions(thisActivity, new String[]{Manifest.permission.WRITE_EXTERNAL_STORAGE}, MY_PERMISSIONS_REQUEST_WRITE_EXTERNAL_STORAGE);
  }

  private void cancelAllNotifications() {
    NotificationManager notificationManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
    notificationManager.cancelAll();
  }
    private boolean openApp(@NonNull String packageName, @NonNull MethodChannel.Result result, Map args) {
        if (!isAppInstalled(packageName)) {
            Log.w(LOG_INTENTS, "Application with package name \"" + packageName + "\" is not installed on this device");
            result.error("UNAVAILABLE", "Application with package name \"" + packageName + "\" is not installed on this device", null);
            return false;
        }

        Intent launchIntent = this.getPackageManager().getLaunchIntentForPackage(packageName);

        // Adding extras to intent

        if(args != null){
            Iterator it = args.entrySet().iterator();



            while (it.hasNext()) {
                Map.Entry pair = (Map.Entry)it.next();
                String key = ""+pair.getKey();
                String value = "" + pair.getValue();
                launchIntent.putExtra(key, value);
                System.out.println(pair.getKey() + " = " + pair.getValue());
                it.remove(); // avoids a ConcurrentModificationException
            }
        }


        //



        if (IntentUtils.isIntentOpenable(launchIntent, this)) {
            this.startActivity(launchIntent);
            result.success(true);
            return true;
        }
        result.error("UNAVAILABLE", "intent is not openable", null);
        return false;
    }

    private void launchFileExplorer(@NonNull MethodChannel.Result result, String path){
      String stringResult = "NOT_FINISHED";
        try {
//            String nativeStoragePath = Environment.getExternalStorageDirectory()+"/"+"Download"+"/";
            Uri uri = Uri.parse(path);

        Log.i(TAG, "GALLERY image: opening ==> "+uri.getPath());


            Intent intent = new Intent(Intent.ACTION_VIEW);
            intent.setDataAndType(uri, "image/*");


// Check that there is an app activity handling that intent on our system
//            if (intent.resolveActivityInfo(this.getPackageManager(), 0) != null) {
                // Yes there is one start it then
                startActivity(intent);
                stringResult = "FINISHED_SUCCESFULLY";
                result.success(stringResult);
//            } else {
//                // Did not find any activity capable of handling that intent on our system
//                stringResult = "Did not find any activity capable of handling that intent on our system";
//                result.error("ERROR", stringResult, null);
//            }


        }
        catch (Exception e)
        {
            stringResult = e.getMessage();
            result.error("ERROR", stringResult, null);

        }

    }



    private boolean openLinkserApp(@NonNull MethodChannel.Result result, String base64) {
      if (!isAppInstalled("linkser.movilink")) {
          
          result.error("UNAVAILABLE", "Application with package name linkser.movilink is not installed on this device", null);
          return false;
      }

        System.out.println("Package linkser.movilink installed ====>" +isAppInstalled("linkser.movilink"));
        System.out.println("Package com.issuer.digital.wallet installed ====>" +isAppInstalled("com.issuer.digital.wallet"));



     

      final int A2A_RESULT = 1234;
      final String A2A_KEY = "a2a";
      String payload = base64; // en vez de String payload = getBase64PayloadFromBackend();
      Intent intent = this.getPackageManager().getLaunchIntentForPackage("linkser.movilink"); // Utilizando import android.content.pm.PackageManager;
      System.out.println("PAYLOAD ====>" +payload);
      if(payload != null) intent.putExtra(A2A_KEY, payload); // en vez de intent.putString(A2A_KEY, payload); ya que el metodo putString() es para objeto bundle

      // intent.setPackage("linkser.movilink"); // Se hizo el intent de otra manera, y vinculo el nombre de paquete

      //

//        intent.setFlags(Intent.FLAG_ACTIVITY_BROUGHT_TO_FRONT); // sigue dentro de la app bec
//        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TASK); // sigue dentro de la app bec
//        intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP); // sigue dentro de la app bec
//        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_DOCUMENT); // sigue dentro de la app bec
//        intent.setFlags(Intent.FLAG_ACTIVITY_MULTIPLE_TASK); // sigue dentro de la app bec
//        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK); // esta en la activity del movilink, pero no resetea si esta en background
        if(payload != null) intent.setFlags(Intent.FLAG_ACTIVITY_EXCLUDE_FROM_RECENTS); //
      if (IntentUtils.isIntentOpenable(intent, this)) {
          System.out.println("INTENT OPENABLE ===> OPENING");
//           this.startActivity(intent);

          this.startActivityForResult(intent, A2A_RESULT);

          result.success(true);
          return true;
      }
      result.error("UNAVAILABLE", "intent is not openable", null);
      return false;
  }
    private boolean isAppInstalled(@NonNull String packageName) {
        try {
            this.getPackageManager().getPackageInfo(packageName, 0);
            return true;
        } catch (PackageManager.NameNotFoundException ignored) {
            return false;
        }
    }


}
