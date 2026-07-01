# Gson spezifische Regeln für Typ-Parameter (wichtig für das Plugin)
-keepattributes Signature, *Annotation*, EnclosingMethod, InnerClasses
-keep class com.google.gson.** { *; }

# flutter_local_notifications Klassen vor Obfuscation schützen
-keep class com.dexterous.flutterlocalnotifications.** { *; }
