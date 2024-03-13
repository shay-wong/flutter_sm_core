import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/second/bindings/second_binding.dart';
import '../modules/home/second/views/second_page.dart';
import '../modules/home/views/home_page.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
      children: [
        GetPage(
          name: _Paths.second,
          page: () => const SecondPage(),
          binding: SecondBinding(),
        ),
      ],
    ),
  ];
}
