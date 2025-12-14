import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tugasteori1/app/modules/pemasukan/controllers/pemasukan_controller.dart';
import 'package:tugasteori1/app/modules/saldo/controllers/total_saldo_controller.dart';

@GenerateMocks([
  FirebaseAuth,
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  User,
  DocumentSnapshot
])

class MockTotalSaldoController extends GetxController with Mock implements TotalSaldoController {
  @override
  final totalSaldo = 0.0.obs;
}

void main() {
  late MockTotalSaldoController mockTotalSaldoController;
  late PemasukanController controller;

  setUp(() {
    mockTotalSaldoController = MockTotalSaldoController();

    if (Get.isRegistered<TotalSaldoController>()) {
      Get.delete<TotalSaldoController>();
    }
    Get.put<TotalSaldoController>(mockTotalSaldoController);

    controller = PemasukanController();
    controller.pendapatanBulanIni.value = 0.0;
    controller.recentTransactions.clear();
    controller.chartData.clear();
  });

  tearDown(() {
    Get.reset();
  });

  group('', () {

    test('addTransaction', () {
      mockTotalSaldoController.totalSaldo.value = 100.0;

      const newAmount = 20.0;
      const expectedIncome = 20.0;
      const expectedTotalSaldo = 100.0 + newAmount;

      controller.addTransaction('Gaji Bulan pertama', '2025-11-11', newAmount, 'Gaji');

      expect(controller.recentTransactions.length, 1);
      expect(controller.recentTransactions.first['amount'], newAmount);
      expect(controller.pendapatanBulanIni.value, expectedIncome);
      expect(mockTotalSaldoController.totalSaldo.value, expectedTotalSaldo);
    });

    test('updateTransaction', () {
      controller.addTransaction('Gaji Lama', '2025-11-12', 50.0, 'Gaji');

      const oldAmount = 50.0;
      const newAmount = 75.0;

      controller.updateTransaction(0, 'Gaji Baru', '2025-11-13', newAmount, 'Bonus');

      expect(controller.recentTransactions.first['name'], 'Gaji Baru');
      expect(controller.pendapatanBulanIni.value, 75.0);
      expect(mockTotalSaldoController.totalSaldo.value, 75.0);
    });

    test('deleteTransaction', () {
      controller.addTransaction('Tunjangan', '2025-11-14', 100.0, 'Bonus');
      controller.addTransaction('Pendapatan Toko', '2025-11-15', 20.0, 'Investasi');

      const amountToRemove = 100.0;

      controller.deleteTransaction(0);

      expect(controller.recentTransactions.length, 1);
      expect(controller.recentTransactions.first['amount'], 20.0);

      expect(controller.pendapatanBulanIni.value, 20.0);
      expect(mockTotalSaldoController.totalSaldo.value, 20.0);
    });
  });

  group('PemasukanController Chart Logic', () {

    test('addData adds a new FlSpot and updates length', () {
      controller.addData(10.0);
      controller.addData(30.0);

      expect(controller.chartData.length, 2);
      expect(controller.chartData[0], FlSpot(0.0, 10.0));
      expect(controller.chartData[1], FlSpot(1.0, 30.0));
    });

    test('editData updates FlSpot and adjusts income and total saldo', () {
      controller.addTransaction('T1', 'd', 10.0, 's');
      controller.addTransaction('T2', 'd', 20.0, 's');
      controller.addData(10.0);
      controller.addData(20.0);

      controller.pendapatanBulanIni.value = 30.0;
      mockTotalSaldoController.totalSaldo.value = 30.0;

      const oldAmount = 20.0;
      const newAmount = 50.0;

      controller.editData(1, newAmount);

      expect(controller.chartData[1], FlSpot(1.0, newAmount));
      expect(controller.pendapatanBulanIni.value, 60.0);
      expect(mockTotalSaldoController.totalSaldo.value, 60.0);
    });

    test('deleteData removes FlSpot, adjusts income/saldo, and re-indexes remaining data', () {
      controller.addData(10.0);
      controller.addData(20.0);
      controller.addData(30.0);

      controller.pendapatanBulanIni.value = 60.0;
      mockTotalSaldoController.totalSaldo.value = 60.0;

      const amountToRemove = 20.0;

      controller.deleteData(1);

      expect(controller.chartData.length, 2);

      expect(controller.pendapatanBulanIni.value, 40.0);
      expect(mockTotalSaldoController.totalSaldo.value, 40.0);

      expect(controller.chartData[0], FlSpot(0.0, 10.0));
      expect(controller.chartData[1], FlSpot(1.0, 30.0));
    });
  });
}