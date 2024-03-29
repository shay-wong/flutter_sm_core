import 'package:get/get.dart';
import 'package:sm_core/sm_core.dart';

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
      // return Future.error('state_error_tips'.tr);
      // return [];
      return true;
    } catch (e) {
      return Future.error(e);
    }
  }
}
