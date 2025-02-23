import 'package:get/get.dart';
import 'package:tugasteori1/app/modules/statistik/controllers/statistik_controller.dart';


class StatistikaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StatistikaController>(() => StatistikaController());
  }
}
