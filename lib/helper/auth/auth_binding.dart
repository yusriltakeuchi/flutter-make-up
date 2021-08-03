import 'package:get/get.dart';
import 'package:make_up/helper/api_controller.dart';
import 'auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
    Get.lazyPut<ApiController>(() => ApiController());
  }
}
