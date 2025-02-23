import 'package:get/get.dart';
import 'package:tugasteori1/app/modules/saldo/controllers/total_saldo_controller.dart';

class TotalSaldoBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(TotalSaldoController());
  }
}
