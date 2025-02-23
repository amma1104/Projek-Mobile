import 'package:get/get.dart';
import 'package:tugasteori1/app/modules/tutorial/controllers/tutorial_controller.dart';


class TutorialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TutorialController>(TutorialController());
  }
}
