import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sm_core/sm_core.dart';

import '../controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: AppBar(
        title: const Text('HomePage'),
        centerTitle: true,
      ),
      body: controller.loading(
        (state) {
          return Column(
            children: [
              const Center(
                child: Text(
                  'HomePage is working',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              const MTextField(
                // text: '123',
                hintText: '234',
                decoration: InputDecoration(hintText: '345'),
              ),
              const TextField(
                decoration: InputDecoration(hintText: '345'),
              ),
              MImage(
                '',
                placeholder: (context, url) => const Icon(
                  Icons.face,
                ),
              ),
              MContainer(
                width: 20,
                height: 20,
                imageProvider: MImage.provider(''),
              ),
              const MImage('https://www.aad.cc/a.png'),
            ],
          );
        },
      ),
    );
  }
}
