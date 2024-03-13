import 'package:get/get.dart';

class SecondController extends GetxController {
  //TODO: Implement SecondController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  void increment() => count.value++;
}
