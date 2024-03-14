import 'package:flutter_sm_core/sm_core.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with MStateMixin {
  @override
  void onInit() {
    super.onInit();

    onLoading(() => init());
  }

  Future init() async {
    try {
      await Future.delayed(1.seconds);
      // return Future.error(MError.noNetwork());
      // return Future.error(LocaleKeys.state_error_tips.tr);
      // return [];
      return true;
    } catch (e) {
      return Future.error(e);
    }
  }
}
