
# Flutter Selphi Plugin

## 1. Introduction

### 1.1 Widget version

The widget version can be viewed as follows:

- We look for the file `pubspec.yaml` in the root of the plugin.
- On the tag *version* the version is indicated.

### 1.2 Instalation of the plugin

**Note:** Consider the following values:

- `<%PLUGIN_SELPHI_FACE_PATH%> = /lib/selphi-face-plugin`

To install the plugin you must perform the following steps:

Access <%APPLICATION_PATH%> and in the file `pubspec.yaml` add:

    dependencies:
        selphi_face_plugin:
            path: <%PLUGIN_SELPHI_FACE_PATH%>

#### 1.2.1 Installation for iOS environment

- In the case of iOS, it should be checked that in the `Info.plist` the application has the camera permission `Privacy - Camera Usage Description`.
- From the path ***<%APPLICATION_PATH%>/ios*** the following should be executed:
  - `pod update`

#### 1.2.2 Installation for Android environment

- Add to file ***<%APPLICATION_PATH%>/android/settings.gradle***:

        include ':selphi_face_plugin', ':selphi_face_plugin', ':fphi-core-widget-android', ':fphi-selphi-widget-android'
        project(':selphi_face_plugin').projectDir = file('../../selphi_face_plugin/android')
        project(':fphi-core-widget-android').projectDir = file('../../selphi_face_plugin/android/fphi-core-widget-android')
        project(':fphi-selphi-widget-android').projectDir = file('../../selphi_face_plugin/android/fphi-selphi-widget-android')

In the file AndroidManifest.xml add the reference to the main activity of the plugin:

    <activity android:configChanges="orientation" android:label="WidgetSelphi" android:name="com.facephi.selphi.Widget" android:screenOrientation="portrait" />

After running the above steps you can launch the applications with the plugin installed. To launch the project there are two options:
  
Finally run the application either by the command `flutter run` or by loading the **Android** from the ***Android Studio*** or that of **iOS** from ***XCode***.

***

## 2. API (Application programming interface)

The Selphi widget for Flutter contains a series of Dart classes included in the lib folder, with the necessary API for communication between the application and the native libraries. The following explains what each of these classes and their properties are for.

### 2.1. SelphiFaceOperation Class

When calling the widget there are a number of parameters that must be included. These will be discussed briefly below:

#### 2.1.1. Authenticate

Sets the mode in which the widget behaves, having a specific mode for each possible scenario.

The widget is configured to perform best image and template extraction processes required for authentication.

### 2.1.2. SelphiFaceConfiguration Class

It is in the folder *lib* of the plugin, and contains a number of properties that configure the operation of the widget. In the section **2.2** it is explained in more detail what these properties consist of.

#### 2.1.3. ResourcesPath

Sets the name of the resource file the widget will use for its graphical configuration. This file is customizable and can be found in the plugin in the path *Resources* for the platform **iOS** and on the path *assets* in the case of **Android**.

### 2.2. Configuration

The parameter passing between the main class of the project and the plugin is done by a class called `SelphiFaceConfiguration`. An example of initialization is shown below:

    SelphiFaceConfiguration configurationWidget = SelphiFaceConfiguration();
    configurationWidget.livenessMode = SelphiFaceLivenessMode.LM_PASSIVE;
    configurationWidget.fullscreen = true;
    configurationWidget.enableImages = true;
    configurationWidget.jpgQuality = 0.8;
    configurationWidget.templateRawOptimized = false;
    configurationWidget.stabilizationMode = true;

Next, all the properties that can be defined in this object `SelphiFaceConfiguration` will be discussed:

#### 2.2.1. Crop (*bool*)

    configurationWidget.crop = false

Indicates whether the images returned in the completion event contain only the area of the detected face, with a magnification given by “CropPercent” or else the entire image is returned.

#### 2.2.2. CropPercent (*double*)

    configurationWidget.cropPercent = 1.0

Specifies the percentage that the area of the detected face is enlarged by to compose the image that is returned.

#### 2.2.3. Debug (*bool*)

    configurationWidget.debug = false

Sets the debugging mode for the widget.

#### 2.2.4. LivenessMode (*SelphiFaceLivenessMode*)

    configurationWidget.livenessMode = SelphiFaceLivenessMode.LM_PASSIVE

Sets the liveness mode of the widget. The allowed values are:

- **LM_NONE**: Indicates that the photo detection mode should not be enabled in the authentication processes.
- **LM_PASSIVE**: It indicates that the passive liveness test is performed on the server, sending the corresponding “BestImage”.

#### 2.2.5. StabilizationMode (*bool*)

    configurationWidget.stabilizationMode = true

Property that allows the activation or deactivation of the stabilized mode before the face detection process. In case it is activated it will give some guidelines to know if it is correctly located or not.

#### 2.2.6. UTags (*String*)

    configurationWidget.uTags = string

Establishes 4 bytes formatted to string base64 with data that can be configured by the main application and that will be incorporated into the templates generated by the extractor.

#### 2.2.7 Locale (*String*)

    configurationWidget.locale = 'ES'

It forces the widget to use the language setting indicated by the locale parameter.
This parameter accepts both a language code (e.g. *en*) and a regional identification code (e.g. *en_US*). If the widget resource file does not have a location for the *locale* by selecting its configuration, it will use the default language.

#### 2.2.8. FullScreen (*bool*)

    configurationWidget.fullscreen = true

Establishes if you want the widget to start in full screen mode, hiding the status bar.

#### 2.2.9. EnableImages (*bool*)

    configurationWidget.enableImages = false

Indicates whether the widget returns to the application the images used during extraction or not. Please note that returning the images may result in a considerable increase in the use of device resources.

#### 2.2.10 FrontalCameraPreferred (*bool*)

    configurationWidget.frontalCameraPreferred = true

Property that allows you to select the front camera as your preferred camera.

#### 2.2.11 JPGQuality (*double*)

    configurationWidget.jpgQuality = 0.95

Property that allows setting a percentage of quality to the return image (bestImage). The value must be between 0 y 1 (float).

#### 2.2.12 sceneTimeout (*double*)

    configurationWidget.sceneTimeout = 15.0;

Sets a timeout value in seconds for each scene in the widget.

#### 2.2.13 enableGenerateTemplateRaw (*boolean*)

    enableGenerateTemplateRaw: true
    
Forces the call of the generateTemplateRaw method. Returning the result in the bestImageTemplateRaw parameter.

## 3. Flutter plugin integration

### 3.1 Calling the widget in Passive Liveness mode

To be able to run the passive mode, the call to the StartWidget method contained in the `SelphiFacePlugin`  must be performed as specified below:

     Map resultJson;
    _livenessMode = SelphiFaceLivenessMode.LM_PASSIVE;
    _configurationWidget = SelphiFaceConfiguration();
    _configurationWidget.livenessMode = _livenessMode; // Liveness mode
    _configurationWidget.fullscreen = true;
    _configurationWidget.enableImages = true;
    _configurationWidget.jpgQuality = 0.8;
    _configurationWidget.templateRawOptimized = false;
    _configurationWidget.stabilizationMode = true;
       
    resultJson = await SelphiFacePlugin.startSelphiFaceWidget(resourcesPath: _resourcesPath,
        widgetConfigurationJSON: _configurationWidget);

In order to make use of this call, the following imports need to be made:

    import 'package:selphi_face_plugin/SelphiFaceConfiguration.dart';
    import 'package:selphi_face_plugin/SelphiFaceOperation.dart';
    import 'package:selphi_face_plugin/SelphiFaceLivenessMode.dart';
    import 'package:selphi_face_plugin/selphi_face_plugin.dart';
    import 'package:selphi_face_plugin/SelphiFaceFinishStatus.dart';
    import 'package:selphi_face_plugin/SelphiFaceLivenessDiagnostic.dart';
    import 'package:selphi_face_plugin/SelphiFaceErrorType.dart';

### 3.2 Passive Mode Widget Call Result

As shown in the example above, the results are returned using a ***Map*** with all parameters returned by the plugin in key-value format:

    Map<dynamic, dynamic> resultJson

If the process was successful, the result will return the following:

    {
        finishStatus: SelphiFaceFinishStatus,
        template: stringBase64,
        images: Array(stringBase64),
        errorType: SelphiFaceErrorType,
        errorMessage: string,
        templateRaw: stringBase64,
        bestImage: stringBase64,
        bestImageCropped: stringBase64,
        eyeGlassesScore: double,
        templateScore: double,
        qrData: string
    }

The parameters received are as follows:

- **finishStatus**: Returns the global diagnostic of the operation. The possible values for the type of exception are:
  - **WidgetFinishStatus.StoppedManually**: Exception that occurs when the user stops the extraction manually.
  - **WidgetFinishStatus.Timeout**: Exception that occurs when a maximum time passes without being able to finish the extraction successfully.
  - **WidgetExceptionType.Ok**: The exception is when the widget is not allowed to access the camera.
  - **WidgetExceptionType.Error**: An error has occurred, which will be indicated in the enumerator `errorType` and, optionally, an extra information message will be displayed on the `errorMessage`.
- **template**: Returns the user template that is generated after the extraction process.
- **templateRaw**: Returns the raw template generated after the extraction process.
- **images**: If the flag `enableImages` was activated in the setup, returns the images obtained during the extraction process. The images are returned sorted by the moment in time they were taken.
- **errorType**: Returns the type of error that has occurred (in the case that there has been one, which is indicated in the `finishStatus` with the value `error`). The values it can have are the following:
  - **TE_UNKNOWN_ERROR**. Error not managed. Possibly caused by an error in the resource bundle.
  - **TE_NO_ERROR**: No error has occurred. The process can continue.
  - **TE_CAMERA_PERMISSION_DENIED**: The exception is when the widget is not allowed to access the camera.
  - **TE_SETTINGS_PERMISSION_ERROR**: Exception that occurs when the widget is not allowed to access the system settings (*deprecated*).
  - **TE_HARDWARE_ERROR**: Exception that arises when there is a hardware issue with the device, usually caused because the available resources are very scarce.
  - **TE_EXTRACTION_LICENSE_ERROR**: Exception that occurs when there has been a licensing problem on the server.
  - **TE_UNEXPECTED_CAPTURE_ERROR**: Exception that occurs during the capture of frames by the camera.
  - **TE_CONTROL_NOT_INITIALIZATED_ERROR**: The widget configuration has not been initialized.
  - **TE_BAD_EXTRACTOR_CONFIGURATION_ERROR**: Problem encountered during widget setup.
- **errorMessage**: Indicates an additional error message if necessary. It is an optional value.
- **bestImage**: Returns the best image extracted from the registration or authentication process. This image is the original size image extracted from the camera.
- **bestImageCropped**: Returns a cropped image centered on the user's face. This image is obtained from the "bestImage". This is the image that should be used as the characteristic image of the user who performed the registration or authentication process as ‘avatar’
- **eyeGlassesScore**: Returns the quality score of the template.
- **templateScore**: Returns the score for the probability of the user wearing glasses.
- **qrData**: Returns the data of the captured QR code.
- **statistics**: Returns the data of the captured statistics. Returns a json with info about the execution of the movement liveness.
- **facialScoreDiagnostic**: Returns 0, 1, or 2. Where 0 is the best possible quality obtained for bestimage.
- **bestImageTemplateRaw**: Optional parameter. Only visible if the enableGenerateTemplateRaw parameter is set to true. The widget will return the `templateRaw` in ***stringBase64*** format.

### 3.3 Calling the generateTemplateRaw method

Generates a `templateRaw` from a URI image (with header) or an image in ***stringBase64***. The plugin transforms it to native image (***Bitmap*** in **Android** and ***UIImage*** en **IOS**) and sends it to the widget to generate the `templateRaw`. The widget will return the `templateRaw` in the form of ***stringBase64***. This call is static so no widget configuration is required. To make the call you must execute the following code:

    String resultJson = await SelphiFacePlugin.generateTemplateRaw(imageBase64: _imageBase64);

***

## 4. Widget Customization

The widget allows the customization of text, images, fonts and colors. Customization is done using the .zip file supplied with the widget. This zip is composed of a file called `widget.xml` which contains the definition of all the screens in the widget, each one of them with a series of elements which allows the customization to be performed. The zip file also contains a folder with graphic resources and another folder with the translations of the texts.

### 4.1. Basic description

#### 4.1.1. Customization of texts

Text customization is done by editing the texts in the existing translation files in the .zip resource.

    /strings/strings.es.xml
    /strings/strings.xml

#### 4.1.2. Image customization

To customize the images that the widget uses, you must add the images to the resource .zip file. In the zip you will find 3 folders:

    /resources/163dpi
    /resources/326dpi
    /resources/489dpi

These folders correspond to the different screen densities and you can create as many density folders as you want. In these folders are the versions of the images for each of the resolutions.

It is necessary to add the images in all the folders, because once the optimal resolution for the device is determined, the widget only loads images from the folder with the chosen resolution.
The images are referenced from the `widget.xml`.

#### 4.1.3. Color customization

Button color customization is done from the `widget.xml`. You can customize any color of any graphic element that appears in the widget. Simply change the color of the desired property.

#### 4.1.4. Font type customization

Typography files should be placed in the `/resources/163dpi` and once there they can be referenced from the `widget.xml`. To change the font of a text element it would be enough to modify the property 'font' and put in the name of the corresponding file.

The following section will provide more information about the content of the resource bundle and how to modify it.

### 4.2. Advanced description

#### 4.2.1. Widget.xml

This file contains the definition of all the properties that are configurable in the authentication and registration processes. It is divided into navigation screens and within each screen label are all the properties that can be modified.

#### 4.2.2. Strings folder

This folder contains a file `strings.xml` for each translation you wish to support. The name must be formed as follows:

    strings.(language).xml

(language) being the language code. For example, `strings.es.xml` would be the Spanish translation, `strings.en.xml` the translation into English, `strings.es_ES.xml` Spanish from Spain or `strings.es_AR.xml` the Spanish of Argentina.

You can force the language or let the widget choose it depending on the device settings. When deciding which language to apply, the following order is followed:

- Search by location code (for example, “es_AR”).
- If you don't find one that matches, you would look for one for the generic language (that is, in this case it would be “es”).
- If there are no results either, then it uses the default language.

At the code level it is possible to select the location through the locale property. This parameter accepts a string with the language code you want to use (for example, “es” o “es_ES”).

#### 4.2.3. Resources folder

It contains the folders with all the necessary resources to be able to modify, divided in densities. It is mandatory to generate the images in all densities as the widget expects to find them in the folder corresponding to the density of the device. You can also create new folders with the desired density.

#### 4.2.4. Element BACKGROUND

The element `background` consists of 4 segments that can be colored independently:

- **top**: defines the background color of the top segment or panel.
- **middle_top**: defines the background color of the segment or panel where the camera image is located.
- **middle_bottom**: defines the background color of the segment or panel below the camera image.
- **bottom**: defines the background color of the lower segment or panel.

You can also set certain properties that are used only on specific screens. We list them below with reference to the screens on which they are used:

- **pagination_separator (RegistrationTips, FaceMovementTips)**: defines the color of the separation between the bottom panel and the panel underneath the camera.
- **mirror_border_color (RegistrationTips, FaceMovementTips)**: defines the color of the edge of the circle surrounding the camera or video image from the registration tips. This element is also called mirror.
- **mirror_border_width (RegistrationTips, FaceMovementTips)**: defines the width of the edge of the circle surrounding the camera or video image in the registration tips. If we did not want to show a border, we would have to assign a 0.0 to this property.
- **mirror_mist_color (StartExtractor)**: defines the color of the central circle on the screen prior to extraction. This color should always have a transparency value since we must let the camera image be seen so that the user can position himself correctly before starting the extraction. The color format when a transparency value is included is RGBA (The alpha value will be indicated with the last byte).
- **mirror_color (Results)**: defines the background color of the circle showing the results of the registration process.

#### 4.2.5. BUTTON element

- **background**: defines the background color of the button
- **decorator**: defines the color of the shadow of the button
- **foreground**: defines the color of the button's font in case the content is a text
- **content_type**: defines the type of content of the button. There are 2 different types:
- **resource_id**: Content must contain the name of a file in the resource bundle
- **text_id**: Content must contain the identifier of a literal from the translation file of the resource bundle
- **content**: defines the content of the button. It can be either an image or the identifier of a literal.
- **align**: Defines the alienation of the button's content, either an image or text
- **font**: Defines the font used if the button's content is a text
- **font_size**: Defines the font size if the button's content is text

#### 4.2.6. TEXT element

The elements `text` are used to define the graphic appearance of the texts on each of the widget's screens. These are the properties that can be modified:

- **color**: defines the color of the text.
- **font**: defines the type of font used to display the text.
- **font_size**: defines the size of the font.

It should be noted that on the screen of registry results the two texts that define the quality of the registry have their color forced to the color of the bar that indicates the score.

#### 4.2.7. IMAGE element

- **value**: defines the name of the file containing the image to be displayed.

The elements `image` only have the property that defines the file where the image is physically located in the resource bundle. Images are obtained from the bundle by searching the appropriate folder according to the density of the device.

#### 4.2.8. VIDEO element

- **value**: defines the name of the file containing the video to be displayed.

The elements `video` only have the property that defines the file where the video is physically located in the resource bundle.

***

## 5. Requirements

### 5.1. Minimum requirements for Android environment

For proper integration of the facial recognition widget into an Android device, the following version of the Android operating system is required:

- API level 14 (Android 4.0)

As for the architecture of the mobile device:

- armeabi-v7, x86, arm64 y x64

***

## 6. Contact Information

For any general questions, please contact us through the following means:

- info@facephi.com
- <http://www.facephi.com>
- Avenida México, 20. Alicante 03008. España.
- (+34) 965 10 80 08

If you wish to make commercial inquiries, please use the means provided below:

- sales@facephi.com
- (+34) 965 10 80 08

If you have any technical questions, suggestions or reports, please contact:

- support@facephi.com
- (+34) 965 10 80 08

If you wish to make or send us any type of suggestion or detect any type of error, please contact:

- feedback@facephi.com
- (+34) 965 10 80 08
