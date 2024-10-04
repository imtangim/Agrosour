import 'package:get/get.dart';
import 'package:nasa_space_app/authentication/auth_controller.dart';
import 'package:nasa_space_app/homepage/controller/home_controller.dart';
import 'package:nasa_space_app/homepage/controller/post_service_controller.dart';
import 'package:nasa_space_app/homepage/controller/report_controller.dart';

class GetxBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(HomeController());
    Get.put(PostService());
    Get.put(ReportController());
  }
}
