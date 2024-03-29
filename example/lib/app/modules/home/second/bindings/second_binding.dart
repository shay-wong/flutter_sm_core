import 'package:get/get.dart';

import '../controllers/second_controller.dart';

class SecondBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SecondController>(
      () => SecondController(),
    );
  }
}
