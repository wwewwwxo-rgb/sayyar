# درب العراق — النسخة التأسيسية

هذه بداية مشروع Flutter لأندرويد، تحتوي على:
- خريطة OpenStreetMap.
- واجهة عربية أولية.
- طلب إذن GPS والانتقال إلى موقع المستخدم.
- أزرار تمهيدية للبحث وبلاغات الطرق.

## مهم
هذه ليست نسخة ملاحة كاملة بعد:
- لا يوجد توجيه مسارات أو تعليمات انعطاف حتى الآن.
- لا يوجد ازدحام مباشر حتى الآن.
- أزرار البحث والبلاغات تجريبية.
- الخريطة تحتاج إنترنت، ويجب الالتزام بسياسة استخدام خوادم بلاطات OpenStreetMap.

## تشغيل المشروع
1. ثبّت Flutter SDK وAndroid Studio على كمبيوتر، أو افتح المشروع في بيئة Flutter تدعم استيراد مشروع كامل.
2. فك ضغط الملف.
3. داخل مجلد المشروع شغّل:
   flutter pub get
   flutter run
4. لإنشاء APK تجريبي:
   flutter build apk --debug

## أذونات Android
قد تحتاج إضافة إذن الموقع إلى `android/app/src/main/AndroidManifest.xml` داخل عنصر `manifest` وقبل `application`:

    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.INTERNET" />

للتشغيل في الخلفية أو التتبع المستمر نحتاج تصميم أذونات إضافي، وشرح واضح للمستخدم، ومراعاة قيود أندرويد.

## الخطوة التالية
إضافة البحث عن الأماكن ثم ربط محرك مسارات مثل Valhalla، وبعدها تصميم خدمة بلاغات مباشرة مع قاعدة بيانات، ومكافحة البلاغات الوهمية.
