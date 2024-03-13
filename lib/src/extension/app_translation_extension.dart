import '../../generated/locales.g.dart';

// TODO: 本地化还需要再优化
extension AppTranslationExt on Map<String, Map<String, String>> {
  Map<String, Map<String, String>>? mergeTranslations() {
    return AppTranslation.translations.map((key, value) {
      return MapEntry(key, {...value, ...?this[key]});
    });
  }
}
