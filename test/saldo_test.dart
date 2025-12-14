import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:tugasteori1/app/modules/saldo/controllers/total_saldo_controller.dart';

void main() {
  late TotalSaldoController controller;

  setUp(() {
    controller = TotalSaldoController();

    controller.totalSaldo.value = 0.0;
  });

  tearDown(() {
    Get.reset();
  });

  group('TotalSaldoController Logic', () {

    test('initial totalSaldo value is 0.0', () {
      expect(controller.totalSaldo.value, 0.0);
    });

    test('tambahSaldo increases totalSaldo correctly', () {
      const initialAmount = 50.0;
      const amountToAdd = 150.0;

      controller.totalSaldo.value = initialAmount;

      controller.tambahSaldo(amountToAdd);

      expect(controller.totalSaldo.value, 200.0);
    });

    test('kurangiSaldo decreases totalSaldo correctly', () {
      const initialAmount = 300.0;
      const amountToSubtract = 75.0;

      controller.totalSaldo.value = initialAmount;

      controller.kurangiSaldo(amountToSubtract);

      expect(controller.totalSaldo.value, 225.0);
    });

    test('kurangiSaldo can result in a negative balance', () {
      const initialAmount = 50.0;
      const amountToSubtract = 100.0;

      controller.totalSaldo.value = initialAmount;

      controller.kurangiSaldo(amountToSubtract);

      expect(controller.totalSaldo.value, -50.0);
    });

    test('resetSaldo sets totalSaldo back to 0.0', () {
      const initialAmount = 999.0;

      controller.totalSaldo.value = initialAmount;

      controller.resetSaldo();

      expect(controller.totalSaldo.value, 0.0);
    });
  });
}