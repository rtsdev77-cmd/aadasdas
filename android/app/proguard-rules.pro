# Flutter-specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.embedding.**  { *; }

# Keep attributes that might be needed for reflection
-keepattributes Signature
-keepattributes *Annotation*

# Keep the main plugin class and all its members
-keep public class com.sslwireless.sslcommerz.FlutterSslcommerzPlugin

# Keep all classes in the sslcommerz package
-keep class com.sslwireless.sslcommerz.** { *; }
-keep interface com.sslwireless.sslcommerz.** { *; }

# Prevent R8 from warning about this package
-dontwarn com.sslwireless.sslcommerz.**

# Keep other payment/notification plugins as a precaution
-keep class com.razorpay.** { *; }
-keep class com.onesignal.** { *; }

# Keep custom exceptions
-keep public class * extends java.lang.Exception

# Google Play Core library rules
-keep class com.google.android.play.core.** { *; }
-dontwarn com.google.android.play.core.**
