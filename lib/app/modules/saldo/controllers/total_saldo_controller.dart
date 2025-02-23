import 'package:get/get.dart';

class TotalSaldoController extends GetxController {
  var totalSaldo = 0.0.obs;

  // Fungsi untuk menambah saldo
  void tambahSaldo(double amount) {
    totalSaldo.value += amount;
  }

  // Fungsi untuk mengurangi saldo
  void kurangiSaldo(double amount) {
    totalSaldo.value -= amount;
  }
  void resetSaldo() {
    totalSaldo.value = 0.0;
  }
}
