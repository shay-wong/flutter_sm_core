import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../utils/toast.dart';

extension StringEx on String {
  // 复制到剪贴板
  void copyToClipboard({
    bool showCopied = true,
  }) {
    if (isEmpty) {
      MToast.showToast('内容为空');
      return;
    }
    Clipboard.setData(
      ClipboardData(text: this),
    ).then((value) {
      if (showCopied) MToast.showToast('已复制');
    });
  }

  Future<bool> launch(
      {LaunchMode mode = LaunchMode.platformDefault,
      bool showErrorToas = true}) async {
    try {
      if (await canLaunchUrlString(this)) {
        return launchUrlString(this, mode: mode);
      }
      if (showErrorToas) {
        MToast.showToast('无法打开链接');
      }
      return false;
    } catch (_) {
      if (showErrorToas) {
        MToast.showToast('无法打开链接');
      }
      return false;
    }
  }

  bool? get toBool => bool.tryParse(this);
  int? get toInt => int.tryParse(this);
  double? get toDouble => double.tryParse(this);
  num? get toNum => num.tryParse(this);

  String get remove0Tail {
    if (contains('.') == false) {
      return this;
    }
    var money = this;
    while (money.endsWith('0')) {
      money = money.substring(0, money.length - 1);
    }
    if (money.endsWith('.')) {
      money = money.substring(0, money.length - 1);
    }
    return money;
  }

  bool containsAny(List<String> values) {
    for (final value in values) {
      if (contains(value)) {
        return true;
      }
    }
    return false;
  }

  String get fileName {
    try {
      final path = Uri.parse(this).path;
      return path.substring(path.lastIndexOf('/') + 1);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return '';
    }
  }
}
