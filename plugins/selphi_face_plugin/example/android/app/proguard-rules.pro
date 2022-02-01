-ignorewarnings
 
-keepclasseswithmembernames class * {
    native <methods>;
}
 
-dontwarn org.xmlpull.v1.**
 
-keepnames public class com.facephi.sdk.** { *; }
-keepnames public class com.facephi.fphiwidgetcore.** { *; }
-keepnames public class com.facephi.fphiselphidwidgetcore.** { *; }
-keep public class com.facephi.sdk.** { *; }
-keep public class com.facephi.fphiwidgetcore.** { *; }
-keep public class com.facephi.fphiselphidwidgetcore.** { *; }
 
-keep class org.kxml2.** { *; }
-keep class org.xmlpull.** { *; }