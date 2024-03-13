import 'package:url_launcher/url_launcher.dart';

extension UriEx on Uri {
  Future<bool> launch({LaunchMode mode = LaunchMode.platformDefault}) async {
    try {
      if (await canLaunchUrl(this)) {
        return launchUrl(this, mode: mode);
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
