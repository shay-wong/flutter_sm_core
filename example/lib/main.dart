import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_core/sm_core.dart';

import 'app/routes/app_pages.dart';
import 'translations/app_translations.dart' as example;

void main() {
  runApp(
    ScreenUtilInit(
      designSize: designSize,
      child: GetMaterialApp(
        title: "Application",
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
        translationsKeys: example.AppTranslation.translations
            .mergeTranslations(), // 将本地化交给外部处, 将包中的本地化合并进来
        fallbackLocale: const Locale('en', 'US'),
        // locale: const Locale('zh', 'CN'),
        locale: const Locale('zh'),
        // locale: const Locale('en', 'US'),
        popGesture: true,
      ),
    ),
  );
}
