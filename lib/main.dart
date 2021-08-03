import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:make_up/component/theme.dart';
import 'package:make_up/helper/auth/auth_binding.dart';
import 'package:make_up/helper/mixin.dart';
import 'package:make_up/page/root.dart';

import 'helper/api_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init('authStorage');
  runApp(MyApp());
}

class MyApp extends StatelessWidget with CustomClass {
  final ApiController apiController = Get.put(ApiController());

  @override
  Widget build(BuildContext context) {
    setStatusBar();
    return GetMaterialApp(
      home: Root(),
      title: 'Make Up You',
      theme: CustomTheme.theme,
      builder: EasyLoading.init(),
      initialBinding: AuthBinding(),
      debugShowCheckedModeBanner: false,
    );
  }
}
