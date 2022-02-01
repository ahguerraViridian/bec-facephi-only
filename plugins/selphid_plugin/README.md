
# Flutter SelphID Plugin

## 1. Introducción

En este manual se documenta la configuración y funcionamiento de **FacePhi SelphID Flutter Widget 1.2.0** en aplicaciones desarrolladas para el entorno Flutter. Se describen:

- Gestión interna de cámaras y resoluciones.
- Asistente en los procesos de captura de la parte frontal y trasera del documento.
- Extracción de la información contenida en el documento.
- Obtención de las imágenes de la parte frontal, trasera y otros datos relevantes.

### 1.1 Versión del widget

La versión del widget se puede consultar de la siguiente manera:

- Buscamos el fichero `pubspec.yaml` en la raíz del plugin.
- En la etiqueta *version* se indica la versión.

También se puede ver desde la línea de comandos:

- Accedemos a la ruta de la aplicación Flutter que tenga el plugin instalado.
- Ejecutamos el siguiente comando para listar todos los plugins instalados en el proyecto: `flutter --version`
- Al lado del nombre de cada plugin instalado aparecerá el número de versión.

### 1.2 Instalación del plugin

#### 1.2.1 Instalación para entorno iOS

- En el caso de iOS, se deberá comprobar que en el `Info.plist` la aplicación tiene el permiso de cámara `Privacy - Camera Usage Description`.
- Desde la ruta ***<%APPLICATION_PATH%>/ios*** 

#### 1.2.2 Instalación para entorno Android

- Añadir en fichero ***<%APPLICATION_PATH%>/android/settings.gradle***:

        include ':selphid_plugin', ':fphiselphidwidgetcore', ':selphid', ':LibBlinkID'
        project(':selphid_plugin').projectDir = file('../../selphid_plugin/android')
        project(':fphiselphidwidgetcore').projectDir = file('../../selphid_plugin/android/fphiselphidwidgetcore')
        project(':selphid').projectDir = file('../../selphid_plugin/android/selphid')
        project(':LibBlinkID').projectDir = file('../../selphid_plugin/android/LibBlinkID')

En el fichero AndroidManifest.xml añadir la referencia a la activity principal del plugin:

    <activity android:configChanges="orientation" android:label="WidgetSelphID" android:name="com.facephi.selphid.Widget" android:screenOrientation="portrait" />

#### 1.2.3 Instalación global

**Nota:** Considerar los siguientes valores:

`<%PLUGIN_SELPHID_PATH%> = “/path_to_selphid_plugin/selphid_plugin/”`

Para instalar el plugin se deberán realizar los siguientes pasos:

Acceder a <%APPLICATION_PATH%> y en el fichero `pubspec.yaml` añadir:

    dependencies:
        selphid_plugin:
            path: <%PLUGIN_SELPHID_PATH%>

Después de ejecutar los pasos anteriores ya se puede lanzar las aplicaciones con el comando `flutter run`.

***

## 2. Configurar el widget

El widget de SelphID para Flutter contiene una clase de dart `` incluidas en la carpeta *models*, con la API necesaria para la comunicación entre la aplicación y las librerías nativas. A continuación se explican para qué sirve cada una de esas clases y sus propiedades.

### 2.1. Clase SelphIDConfiguration

El paso de argumentos entre la clase principal del proyecto y el plugin realiza mediante una clase llamada `SelphIDConfiguration`. A continuación se muestra un ejemplo de inicialización:
    
    SelphIDConfiguration createStandardConfiguration() {
      SelphIDConfiguration configurationWidget;
      configurationWidget = SelphIDConfiguration();
      configurationWidget.enableWidgetEventListener = true;
      configurationWidget.documentType = SelphIDDocumentType.DT_IDCARD;
      configurationWidget.fullscreen = true;
      configurationWidget.scanMode = SelphIDScanMode.CAP_MODE_SEARCH;
      configurationWidget.specificData = 'AR|<ALL>';
      configurationWidget.showResultAfterCapture = true;
      configurationWidget.timeout = SelphIDTimeout.T_SHORT;
      return configurationWidget;
    }

A continuación se comentarán todas las propiedades que pueden definirse en este objeto `WidgetSelphIDConfig`:

#### 2.2.1. ShowResultAfterCapture (*boolean*)

    configurationWidget.showResultAfterCapture = false;

Indica si mostrar o no una pantalla con la imagen capturada del documento después del proceso de análisis. En esta pantalla se le da al usuario la posibilidad de repetir el proceso de captura si la imagen que se obtuvo del documento no fuera correcta.

#### 2.2.2. ScanMode (*SelphIDScanMode*)

    configurationWidget.scanMode = SelphIDScanMode.CAP_MODE_SEARCH;

Indica el modo de escaneo OCR de los documentos. Dependiendo de la elección, se escanearán y buscarán varios tipos de documentos o uno en concreto. Este modo puede ser de tres tipos:

- **SelphIDScanMode.CAP_MODE_GENERIC**: El modo genérico que permite escanear cualquier tipo de documento independiente del país o el tipo de documento. El resultado de este modo no es tan preciso como los siguientes pero permite escanear varios documentos estándar.
- **SelphIDScanMode.CAP_MODE_SEARCH**: El modo de búsqueda permitirá utilizar una whitelist y blacklist, y buscará en los documentos que cumplan dichas condiciones. Estas condiciones se indican en la variable "specificData". De este modo se permite realizar la búsqueda acotando el número de plantillas, y haciendo que la búsqueda sea mucho más afinada que en el caso genérico.
- **SelphIDScanMode.CAP_MODE_SPECIFIC**: Búsqueda de un documento específico. Estas condiciones se indican en la propiedad "specificData" que se muestra en lo sucesivo.

#### 2.2.3. SpecificData (*string*)

Esta propiedad permite definir qué documentos se escanearán durante el proceso, en caso de declarar el modo de escaneo (scanMode) a GenericMode, SpecificMode o SearchMode.

Un ejemplo de configuración que permita escanear todos los documentos de nacionalidad española sería el siguiente:

    configurationWidget.scanMode = SelphIDScanMode.CAP_MODE_SEARCH;
    configurationWidget.specificData = “ES|<ALL>”; // Código ISO de España (ES)

#### 2.2.4. Debug (*bool*)

    configurationWidget.debug = false;

Establece el modo de depuración del widget.

#### 2.2.5 Locale (*String*)

    configurationWidget.locale = "ES";

Es un string que permite cambiar la localización y el idioma del widget. Ejemplos de valores que pueden tener son los siguientes:

- “es” para español.
- “en” para inglés.
- “fr” para francés.

En definitiva, dependerá del nombre que aparezca en el fichero strings.xml del lenguaje que se desee seleccionar (strings-es.xml, strings-en.xml, strings-fr.xml).

En el zip de recursos, el cual se encuentra dentro de la carpeta strings, se pueden añadir los ficheros strings-xx.xml correspondientes a cada localización que se requiere incorporar en el widget.

#### 2.2.6. FullScreen (*bool*)

    configurationWidget.enableFullscreen = true;

Establece si se desea que el widget se arranque en modo pantalla completa, ocultando el status bar.

#### 2.2.7. DocumentType (*SelphIDDocumentType*)

    configurationWidget.documentType = SelphIDDocumentType.IDCard;

Especificado en la clase `SelphIDDocumentType`:

- **IDCard**: Establece que se capturarán documentos de identidad o tarjetas.
- **Passport**: Establece que se capturarán pasaportes.
- **DriverLicense**: Establece que se capturarán licencias de conducir.
- **CreditCard**: Establece que se capturarán tarjetas de crédito.

#### 2.2.8. TokenImageQuality (*double*)

    configurationWidget.tokenFaceImage = 0.9;

Especifica la calidad de compresión del tokenFaceImage.

#### 2.2.9 enableWidgetEventListener (*boolean*)

    configurationWidget.enableWidgetEventListener = true;
    
Habilita el logueo de eventos que ocurren mientras se esta ejecutando el widget. De ésta manera se puede recolectar información de lo que el usuario esta haciendo. Debe implementarse para que funcione. Véase ejemplo de implementación en el apartado pto 6.   

#### 2.2.10 generateRawImages (*boolean*)

    configurationWidget.generateRawImages = true;
    
Habilita en el resultado del widget 4 ouputs adicionales.
    - rawFrontDocument
    - rawBackDocument
    - tokenRawFrontDocument
    - tokenRawBackDocument

#### 2.2.11 compressFormat (*WidgetCompressFormat*)

    configurationWidget.compressFormat = SelphIDCompressFormat.T_JPEG;

Este enumerado se define en la clase `SelphIDCompressFormat.dart`. Especificado en la clase `SelphIDCompressFormat`:

- **T_JPEG**: Valor por default. Establece que el resultado de la captura será en formato JPEG.
- **T_PNG**: Establece que el resultado de la captura será en formato PNG.

#### 2.2.12 imageQuality (*int*)

    configurationWidget.imageQuality = 100;

Si se seleccionó la opcion JPEG se podrá setear el rango de calidad de la imagen. La misma podrá variar de 1 a 100. La calidad por default es del 95%. 
Desde Facephi no recomendamos configurar una calidad inferior al 90%.

***

## 3. Ejecutar el widget

Para poder ejecutar el modo pasivo, deberá realizarse la llamada al método `startSelphIDWidget` contenido en la clase `SelphidPlugin` tal y como se especifica a continuación:

    SelphIDConfiguration config = SelphIDConfiguration();
    Map resultJson; // Result
    String previousOCRData;
    config.showResultAfterCapture = true;
    config.showTutorial = false;
    config.scanMode = window.facephi.selphid.scanmode.WidgetSelphIDScanMode.SearchMode;
    config.specificData = "ES|<ALL>";
    resultJson = await SelphidPlugin.startSelphIDWidget(operationMode: _operationMode, resourcesPath: _resourcesPath,
          widgetLicense: _licenseIOS, previousOCRData: previousOCRData, widgetConfigurationJSON: _configurationWidget);

### 3.1. onSuccessWizardCapture

Es el evento callback que se ejecuta cuando el widget devuelve un resultado correcto tras la operación de captura. A este callback se retornará un ***JSON Object*** con todas los parámetros resultantes del proceso de captura, en formato clave-valor.

#### 3.2. onErrorWizardCapture

Es el evento que se ejecuta cuando se ha producido un problema durante el proceso de captura en el widget.

### 3.3. SelphIDOperation

A la hora de realizar la llamada al widget existe una serie de parámetros que se deben incluir. La clase `SelphIDOperation`, que se encuentra en la contiene los modos de captura que pueden realizarse. Estos son:

- CAPTURE_FRONT: El widget queda configurado para realizar la captura de la parte frontal del documento. Devuelve los datos obtenidos en este lado del documento.
- CAPTURE_BACK: El widget queda configurado para realizar la captura de la parte trasera del documento. Devuelve los datos obtenidos en este lado del documento.
- CAPTURE_WIZARD: El widget queda configurado para realizar secuencialmente la captura de la parte frontal del documento y, sin finalizar la ejecución del widget, realizar la captura de la parte trasera. Es el método de captura recomendado.

### 3.4. resourcesPath

Establece el nombre del archivo de recursos que utilizará el widget para su configuración gráfica. Este fichero es customizable y se encuentra en el plugin en la ruta raíz. Su instalación es transparente al usuario, simplemente se añadirá a los proyectos de las respectivas plataformas durante la instalación. En el ***apartado 4*** se explica con más detalle el funcionamiento de este bundle de recursos y cómo modificarlo.

### 3.5. ocrData

Cuando la captura del documento se realiza en 2 llamadas (modo Wizard desactivado), esta propiedad permite pasar un diccionario con la información de la captura previa. De esta manera el widget puede combinar los resultados de ambas lecturas de una manera inteligente y así devolver la información combinada de ambas capturas. También permite al widget calcular un grado de similitud de los datos de ambas caras.

En el caso que la captura de ambas caras del documento se realice en una única llamada esto no es necesario ya que el widget internamente hace este proceso.

### 3.6. config

Es un objeto de la clase `SelphIDConfiguration`, que contiene la configuración del widget para el proceso de captura. En el ***apartado***

### 3.7. widgetLicense

El widget de SelphID está licenciado y para hacer uso de él se requerirá de una licencia (fichero .lic) válida que será otorgada por Facephi. Para hacer uso de esta licencia se deberá obtener el contenido del fichero (ya sea leyéndolo del fichero directamente o )

***

## 4. Recepción del resultado

### 4.1 Recepción del resultado

Al finalizar la llamada del widget, es posible adquirir toda la información obtenida de la captura del documento (ya sea la parte frontal, trasera o ambas a la vez). Los resultado se devuelven en formato ***Map*** con todos los parámetros que retorna el plugin en formato clave-valor.

Es importante reseñar que la información obtenida en este objeto se devuelve duplicada, mostrándola a su vez en abierto (por ejemplo, frontDocumentImage para la imagen de la captura frontal del documento), como tokenizado y encriptado (por ejemplo, tokenFrontDocumentImage para la imagen de la captura frontal del documento).

Dependiendo del tipo de licencia utilizada se podrán obtener un tipo de parámetros o ambos. La información tokenizada es recomendable utilizarla para enviarla de forma segura al servidor donde esté instalada la SDK de SelphID, mientras que los datos en abierto deben utilizarse únicamente en fases de desarrollo y test.

En caso de que el proceso se haya realizado correctamente, el resultado devolverá lo siguiente:

  {
        finishStatus = SelphIDFinishStatus;
        frontDocumentImage = stringBase64;
        backDocumentImage = stringBase64;
        faceImage = stringBase64;
        rawBackDocumentImage = stringBase64;
        rawFrontDocumentImage = stringBase64;
        signatureImage = stringBase64;
        fingerprintImage = stringBase64;
        tokenOCR = stringBase64;
        tokenFaceImage = stringBase64;
        tokenFrontDocument = stringBase64;
        tokenBackDocument = stringBase64;
        tokenRawFrontDocument = stringBase64;
        tokenRawBackDocument = stringBase64;
        documentData = stringBase64;
        errorType = SelphIDErrorType;
        errorMessage = string;
        timeoutStatus = number;
        documentCaptured = string;
    }

Los parámetros recibidos son los siguientes:

- **finishStatus**: Devuelve el diagnóstico global de la operación. Los posibles valores para el tipo de excepción son:
  - **SelphIDFinishStatus.STATUS_CANCEL_BY_USER**: Excepción que se produce cuando el usuario para la extracción de forma manual.
  - **SelphIDFinishStatus.STATUS_TIMEOUT**: Excepción que se produce cuando transcurre un tiempo máximo sin conseguir finalizar la extracción con éxito.
  - **SelphIDFinishStatus.STATUS_OK**: Excepción que se produce cuando el widget no tiene permiso de acceso a la cámara.
  - **SelphIDFinishStatus.STATUS_ERROR**: Se ha producido un error, el cuál se indicará en el enumerado `errorType` y, opcionalmente, se mostrará un mensaje de información extra en la propiedad `errorMessage`.
- **frontDocument/tokenFrontDocument**: La imagen frontal del documento procesada, limpiada y recortada por los bordes y su token correspondiente.
- **backDocument/tokenBackDocument**: La imagen trasera del documento procesada, limpiada y recortada por los bordes y su token asociado.
- **faceImage/tokenFaceImage**: La imagen del rostro que se ha encontrado en el documento, en caso de que exista y su token asociado.
- **rawFrontDocument/tokenRawFrontDocument**: La imagen frontal del documento procesada, sin recortar y su token correspondiente.
- **rawBackDocument/tokenRawBackDocument**: La imagen trasera del documento procesada, sin recortar y su token asociado.
- **matchingSidesScore**: Esta propiedad devuelve un cálculo de la similitud de los datos leídos entre el front y el back del documento. El cálculo se realiza comprobando la similitud entre los campos comunes leídos en ambas caras. El resultado del cálculo será un valor entre 0.0 y 1.0 para el caso de que existan campos comunes en el documento. Cuanto mayor es el valor, más similares son los datos comparados.
Si el cálculo devuelve -1.0 es que el documento no contiene campos comunes o aún no se tiene información de las dos caras.
- **timeoutStatus**: Esta propiedad devuelve el estado en el que se encontraba el proceso de captura cuando el widget terminó. Estos son los posibles valores:

        Front_Detection_None = 0
        Front_Detection_Uncertain = 1
        Front_Detection_Completed = 2
        Front_Document_Analyzed = 3
        Back_Detection_None = 4
        Back_Detection_Uncertain = 5
        Back_Detection_Completed = 6
        Back_Document_Analyzed = 7

  - 0: En la lectura del Front, el widget termino sin poder haber detectado nada. Generalmente cuando no se pone ningún - documento.
  - 1: En la lectura del Front, el widget termino habiendo detectado parcialmente un documento. En este caso algunos de los elementos esperados se han conseguido detectar, pero no todos los necesarios.
  - 2: En la lectura del Front, el widget termino habiendo completado la detección de todos los elementos del documento. Si el widget acaba en este estado es porque el análisis de OCR no se ha podido completar con éxito
  - 3: En la lectura del Front, el widget termino habiendo analizado y extraído todo el OCR del documento. Este es el estado en el que acabaría una lectura correcta del Front de un documento.
  - Los estados del 4 al 7 son exactamente iguales solo que se refieren al resultado del proceso cuando se analiza el back.

- **errorType**: Devuelve el tipo de error que se ha producido (en el caso de que haya habido uno, lo cual se indica en el parámetro `finishStatus` con el valor `error`). Se definen en la clase `SelphIDErrorType`. Los valores que puede tener son los siguientes:
  - **TE_UNKNOWN_ERROR**. Error no gestionado. Posiblemente causado por un error en el bundle de recursos.
  - **TE_NO_ERROR**: No ha ocurrido ningún error. El proceso puede continuar.
  - **TE_CAMERA_PERMISSION_DENIED**: Excepción que se produce cuando el widget no tiene permiso de acceso a la cámara.
  - **TE_SETTINGS_PERMISSION_ERROR**: Excepción que se produce cuando el widget no tiene permiso de acceso a la configuración del sistema (*deprecated*).
  - **TE_HARDWARE_ERROR**: Excepción que surge cuando existe algún problema de hardware del dispositivo, normalmente causado porque los recursos disponibles son muy escasos.
  - **TE_EXTRACTION_LICENSE_ERROR**: Excepción que ocurre cuando ha habido un problema de licencias en el servidor.
  - **TE_UNEXPECTED_CAPTURE_ERROR**: Excepción que ocurre durante la captura de frames por parte de la cámara.
  - **TE_CONTROL_NOT_INITIALIZATED_ERROR**: El configurador del widget no ha sido inicializado.
  - **TE_BAD_EXTRACTOR_CONFIGURATION_ERROR**: Problema surgido durante la configuración del widget.
- **errorMessage**: Indica un mensaje de error adicional en caso de ser necesario. Es un valor opcional.

### 4.2. Diccionario ocrResults

Este diccionario contiene todos los datos detectados en el documento. Las claves de cada campo están codificadas de tal forma que la propia clave contiene información de donde se ha obtenido el valor. Así, por ejemplo, la clave Front/MRZ/DocumentNumber indica el valor del DocumentNumber que se ha leído en el Front del documento y en la región del MRZ. Estas claves dependen del documento capturado y por tanto serán diferentes entre distintos países y modelos de documento.

El diccionario también contiene claves con nombres más genéricos y que no llevan información relativa a la ubicación. Estas claves contienen el dato más completo de todos los leídos para dicho campo.

Estas claves son los siguientes:

FirstName: El valor asociado a esta clave contiene el nombre del usuario.
LastName: El valor asociado a esta clave contiene los apellidos del usuario.
DateOfBirth: El valor asociado a esta clave contiene la fecha de nacimiento detectada en el documento.
Gender: El valor asociado a esta clave contiene el sexo del usuario detectado en el documento.
Nationality: El valor asociado a esta clave contiene la nacionalidad del usuario detectado en el documento.
DocumentNumber: El valor asociado a esta clave contiene el número de documento.
DateOfExpiry: El valor asociado a esta clave contiene la fecha de expiración del documento.
Issuer: El valor asociado a esta clave contiene el editor del documento.
DateofIssue: El valor asociado a esta clave contiene la fecha de expedición del documento.
PlaceOfBirth: El valor asociado a esta clave contiene el lugar de nacimiento del usuario.
Address: El valor asociado a esta clave contiene la dirección detectada en el documento.

***

## 5. Personalización del Widget

El widget permite la personalización de textos, imágenes, fuentes de letra y colores. La personalización se realiza mediante el archivo .zip suministrado con el widget. Este zip está compuesto de un fichero llamado `widget.xml` que contiene la definición de todas las pantallas del widget, cada una de ellas con una serie de elementos los cuales permiten realizar la personalización. El archivo zip también contiene una carpeta con recursos gráficos y otra carpeta con las traducciones de los textos.

### 5.1. Descripción básica

#### 5.1.1. Personalización de textos

La personalización de textos se realiza editando los textos de los archivos de traducciones existentes en el .zip de recursos.

    /strings/strings.es.xml
    /strings/strings.xml

#### 5.1.2. Personalización de imágenes

Para personalizar las imágenes que usa el widget se deben añadir las imágenes en el .zip de recursos. En el zip vienen 3 carpetas:

    /resources/163dpi
    /resources/326dpi
    /resources/489dpi

Estas carpetas corresponden a las diferentes densidades de pantalla y se pueden crear tantas carpetas de densidad como se desee. En estas carpetas están las versiones de las imágenes para cada una de las resoluciones.

Es necesario añadir las imágenes en todas las carpetas, ya que una vez determinada la resolución óptima para el dispositivo, el widget sólo carga imágenes de la carpeta con la resolución elegida.
Las imágenes son referenciadas desde el archivo `widget.xml`.

#### 5.1.3. Personalización de colores

La personalización de los colores de los botones se realiza desde el archivo `widget.xml`. En él se puede personalizar cualquier color de cualquier elemento gráfico que aparece en el widget. Simplemente basta con modificar el color de la propiedad deseada.

#### 5.1.4. Personalización de tipo de fuente

Los archivos de tipografía deben colocarse en la carpeta `/resources/163dpi` y una vez ahí pueden ser referenciados desde el archivo `widget.xml`. Para cambiar el tipo de letra de un elemento de texto bastaría con modificar la propiedad ‘font’ y poner el nombre del archivo correspondiente.

En el siguiente apartado se ampliará la información acerca del contenido del bundle de recursos y el modo de modificar.

### 5.2. Descripción avanzada

#### 5.2.1. Widget.xml

Este fichero contiene la definición de todas las propiedades que son configurables en los procesos de autenticación y registro. Está dividido por pantallas de navegación y dentro de cada etiqueta de pantalla se encuentran todas las propiedades que pueden modificarse.

#### 5.2.2. Carpeta strings

Esta carpeta contiene un fichero `strings.xml` por cada traducción que se desee soportar. El nombre debe estar formado de la siguiente manera:

    strings.(idioma).xml

Siendo (idioma) el código del idioma. Por ejemplo, `strings.es.xml` sería la traducción en castellano, `strings.en.xml` la traducción en inglés, `strings.es_ES.xml` el español de España o `strings.es_AR.xml` el español de Argentina.

Se puede forzar el idioma o dejar que el widget lo escoja en función de la configuración del dispositivo. A la hora de decidir cuál es el idioma a aplicar se sigue el siguiente orden:

- Buscar por código de localización (por ejemplo, “es_AR”).
- Si no encuentra ninguna que coincida, buscaría uno para el idioma genérico (es decir, en este caso sería “es”).
- Si tampoco existiese ningún resultado, entonces usaría el idioma por defecto.

A nivel de código es posible seleccionar la localización mediante la propiedad locale. Este parámetro acepta un string con el código de lenguaje que se desea utilizar (por ejemplo, “es” o “es_ES”).

#### 5.2.3. Carpeta resources

Contiene las carpetas con todos los recursos necesarios para poder modificarse, divididos en densidades. Es obligatorio generar las imágenes en todas las densidades ya que el widget espera encontrarlas en la carpeta correspondiente a la densidad del dispositivo. También se pueden crear nuevas carpetas con la densidad deseada.

#### 5.2.4. Elemento BACKGROUND

El elemento `background` se compone de 4 segmentos a los que se puede dar color independientemente:

- **top**: define el color de fondo el segmento o panel superior.
- **middle_top**: define el color de fondo del segmento o panel donde está situada la imagen de la cámara.
- **middle_bottom**: define el color de fondo el segmento o panel situado debajo de la imagen de la cámara.
- **bottom**: define el color de fondo el segmento o panel inferior.

También se pueden configurar ciertas propiedades que se usan solo en pantallas específicas. A continuación, las enumeramos haciendo referencia a las pantallas en la que son utilizadas:

- **pagination_separator (RegistrationTips, FaceMovementTips)**: define el color de la separación entre el panel inferior y el panel de debajo de la cámara.
- **mirror_border_color (RegistrationTips, FaceMovementTips)**: define el color del borde del círculo que rodea a la imagen de la cámara o del video de los consejos de registro. A este elemento también se le llama mirror o espejo.
- **mirror_border_width (RegistrationTips, FaceMovementTips)**: define el ancho del borde del círculo que rodea a la imagen de la cámara o del video de los consejos de registro. Si no deseáramos mostrar un borde, tendríamos que asignar un valor de 0.0 a esta propiedad.
- **mirror_mist_color (StartExtractor)**: define el color del círculo central en la pantalla previa a la extracción. Este color deberá tener siempre un valor de transparencia ya que debemos dejar ver la imagen de la cámara para que el usuario pueda colocarse correctamente antes de empezar con la extracción. El formato del color cuando se incluye un valor de transparencia es RGBA (El valor de alpha se indicará con el último byte).
- **mirror_color (Results)**: define el color de fondo del círculo que muestra los resultados del proceso de registro.

#### 5.2.5. Elemento BUTTON

- **background**: define el color de fondo el botón
- **decorator**: define el color de la sombra del botón
- **foreground**: define el color de la fuente del botón en caso de que el contenido sea un texto
- **content_type**: define el tipo de contenido del botón. Existen 2 tipos diferentes:
- **resource_id**: Content debe contener el nombre de un archivo en el bundle de recursos
- **text_id**: Content debe contener el identificador de un literal del fichero de traducciones del bundle de recursos
- **content**: define el contenido del botón. Puede ser tanto una imagen como el identificador de un literal.
- **align**: Define la alienación del contenido del botón, ya sea una imagen o un texto
- **font**: Define el tipo de letra utilizado si el contenido del botón es un texto
- **font_size**: Define el tamaño de la letra si el contenido del botón es un texto

#### 5.2.6. Elemento TEXT

Los elementos `text` se utilizan para definir el aspecto gráfico de los textos de cada una de las pantallas del widget. Estas son las propiedades que se pueden modificar:

- **color**: define el color del texto.
- **font**: define el tipo de fuente utilizado para mostrar el texto.
- **font_size**: define el tamaño de la fuente.

Hay que tener en cuenta que en la pantalla de resultados del registro los dos textos que definen la calidad del registro tienen forzado su color al color de la barra que indica la puntuación.

#### 5.2.7. Elemento IMAGE

- **value**: define el nombre del archivo que contiene la imagen a mostrar.

Los elementos `image` solo tienen la propiedad que define el archivo donde se encuentra la imagen físicamente en el bundle de recursos. Las imágenes se obtienen del bundle buscando en la carpeta apropiada de acuerdo con la densidad del dispositivo.

#### 5.2.8. Elemento VIDEO

- **value**: define el nombre del archivo que contiene el video a mostrar.

Los elementos `video` solo tienen la propiedad que define el archivo donde se encuentra el video físicamente en el bundle de recursos.

***

## 6. Implementacion del atributo enableWidgetEventListener

Se deberá agregar un listener como se muestra en el siguiente ejemplo de programación:

        /* the new method that listens for events is added */
        Future<void> _callEvents() async {
            const channel = BasicMessageChannel<String>('onSelphidLogEvent', StringCodec());
            await channel.setMessageHandler((String message) async {
              print('Received: $message');
            });
        }

    void _launchSelphIDCapture() async {
        /* add the new method for listening widget events here */
        _callEvents();
        /* end */
        
        String license;
        try {
          if (Platform.isIOS)
            license = Licenses.SELPHID_LICENSE_IOS;
          else
            license = Licenses.SELPHID_LICENSE_ANDROID;
        } on PlatformException {
          _message = 'Error: Failed to get widget information.';
        }
        
## 7. Implementar modo launchSelphIDTestCapture

Para poder utilizar el modo test se deberá reemplazar el método launchSelphIDCapture por launchSelphIDTestCapture. Dentro del método, se deberá agregar dos nuevos parametros que son el nombre de la imagen a testear, y el modo, tal como se muestra en el ejemplo de programación:

    void _launchSelphIDCapture() async {
        String license;
        try {
          if (Platform.isIOS)
            license = Licenses.SELPHID_LICENSE_IOS;
          else
            license = Licenses.SELPHID_LICENSE_ANDROID;
        } on PlatformException {
          _message = 'Error: Failed to get widget information.';
        }

        final selphIDWidgetResult =
          //await _selphIDWidget.launchSelphIDCapture(_resourcesPath, license);
          await _selphIDWidget.launchSelphIDTestCapture(
              _resourcesPath,
              license,
              'document_front.jpg', //new parameter: FILE NAME
              SelphIDOperation.CAPTURE_FRONT); //Mode Wizard is not allowed for testing purpose. You need to choose FRONT or BACK
        return selphIDWidgetResult.fold((l) {
          setState(() {
            _message = l.toString();
            _frontDocumentImage = null;
            _backDocumentImage = null;
            _faceImage = null;
            _ocrResult = null;
          });
        }, (r) {

IMPORTANTE:
La imagenes para la plataforma ANDROID deberán incluirse en la carpeta app/src/main/assets.
Las imagenes para la plataforma IOS deberán incluirse en el COPY BUNDLE RESOURSES 

## 8. Información de contacto

Para cualquier consulta general, por favor, póngase en contacto con nosotros a través de las siguientes vías:

- info@facephi.com
- <http://www.facephi.com>
- Avenida México, 20. Alicante 03008. España.
- (+34) 965 10 80 08

Si quiere realizar consultas comerciales, utilice los medios facilitados a continuación:

- sales@facephi.com
- (+34) 965 10 80 08

Ante cualquier duda técnica, sugerencia o reporte, contacte a través de:

- support@facephi.com
- (+34) 965 10 80 08

Si desea realizar o hacernos llegar cualquier tipo de sugerencia o detecta algún tipo de error, contacte a través de:

- feedback@facephi.com
- (+34) 965 10 80 08
