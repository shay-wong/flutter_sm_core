import 'package:flutter/foundation.dart';

abstract class Configura {
  /// 是否打印日志, 默认为 [kDebugMode]
  static bool get isPrientable => const bool.fromEnvironment("PRINTABLE", defaultValue: kDebugMode);
}
