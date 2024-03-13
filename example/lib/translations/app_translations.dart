// ignore_for_file: non_constant_identifier_names

import 'en_US/en_us_translations.dart';
import 'zh_CN/zh_cn_translations.dart';

abstract class AppTranslation {
  static Map<String, Map<String, String>> translations = {
    'en': enUs,
    'zh': zhCn,
  };
}

String app_name = "超级戳盒";
String home = '主页';
String reload = 'reload';
