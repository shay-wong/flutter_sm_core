// TODO: 本地化还需要再优化
import 'package:sm_get_plus/sm_get_plus.dart';
import 'package:sm_logger/sm_logger.dart';
import 'package:sm_models/sm_models.dart';
import 'package:sm_widget/sm_widget.dart';

extension AppTranslationExt on Map<String, Map<String, String>> {
  Map<String, Map<String, String>>? mergeTranslations() {
    final list = [
      SMWidgetAppTranslation.translations,
      SMModelAppTranslation.translations,
      SMGetAppTranslation.translations,
    ];
    Map<String, Map<String, String>>? map = this;
    for (final translations in list) {
      map = map?._mergeTranslations(translations);
      logger.d(map);
    }
    return map;
  }

  Map<String, Map<String, String>>? _mergeTranslations(
      Map<String, Map<String, String>> translations) {
    return translations.map(
      (key, value) {
        return MapEntry(key, {...value, ...?this[key]});
      },
    );
  }
}
