import 'package:get/get.dart';

import '../controllers/second_controller.dart';

class SecondBinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<SecondController>(
        () => SecondController(),
      ),
    ];
  }
}
