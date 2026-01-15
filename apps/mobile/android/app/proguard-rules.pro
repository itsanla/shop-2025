# ini untuk keep class yang dibutuhkan buk
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# ini untuk Firebase buk
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# ini untuk Facebook buk
-keep class com.facebook.** { *; }

# ini untuk WebView buk
-keep class android.webkit.** { *; }

# ini untuk ignore Google Play Core yang tidak dipakai buk
-dontwarn com.google.android.play.core.**
-ignorewarnings
