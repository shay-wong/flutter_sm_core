import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/second_controller.dart';

class SecondPage extends GetView<SecondController> {
  const SecondPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SecondPage'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SecondPage is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
