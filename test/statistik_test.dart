import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:tugasteori1/app/modules/statistik/controllers/statistik_controller.dart';

void main() {
  late StatistikaController controller;

  setUp(() {
    controller = StatistikaController();

    controller.selectedSort.value = 'Pemasukan';
  });

  tearDown(() {
    Get.reset();
  });

  group('StatistikaController State and Logic', () {

    test('initial selectedSort value is "Pemasukan"', () {
      expect(controller.selectedSort.value, 'Pemasukan');
    });

    test('updateSort changes selectedSort value', () {
      const newSort = 'Terbesar';

      controller.updateSort(newSort);

      expect(controller.selectedSort.value, newSort);
    });

    test('updateSort handles "Terkecil" option', () {
      const newSort = 'Terkecil';

      controller.updateSort(newSort);

      expect(controller.selectedSort.value, newSort);
    });

    test('updateSort handles "Tanggal" option', () {
      const newSort = 'Tanggal';

      controller.updateSort(newSort);

      expect(controller.selectedSort.value, newSort);
    });

    test('updateSort handles "Pemasukan" option', () {
      controller.selectedSort.value = 'Terbesar';
      const newSort = 'Pemasukan';

      controller.updateSort(newSort);

      expect(controller.selectedSort.value, newSort);
    });

  });
}