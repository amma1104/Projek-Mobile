import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:tugasteori1/app/modules/pengeluaran/controllers/pengeluaran_controller.dart';
import 'package:tugasteori1/app/modules/saldo/controllers/total_saldo_controller.dart';
import 'package:tugasteori1/app/modules/profile/controllers/profile_controller.dart';

@GenerateMocks([
  FirebaseAuth,
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  User,
  DocumentSnapshot,
])

class MockTotalSaldoController extends GetxController with Mock implements TotalSaldoController {
  @override
  final totalSaldo = 0.0.obs;
}

class MockProfileController extends GetxController with Mock implements ProfileController {
  @override
  final name = ''.obs;
}

void main() {
  late MockTotalSaldoController mockTotalSaldoController;
  late MockProfileController mockProfileController;
  late PengeluaranController controller;

  setUp(() {
    mockTotalSaldoController = MockTotalSaldoController();
    mockProfileController = MockProfileController();

    if (Get.isRegistered<TotalSaldoController>()) {
      Get.delete<TotalSaldoController>();
    }
    if (Get.isRegistered<ProfileController>()) {
      Get.delete<ProfileController>();
    }

    Get.put<TotalSaldoController>(mockTotalSaldoController);
    Get.put<ProfileController>(mockProfileController);

    controller = PengeluaranController();

    controller.pengeluaranBulanIni.value = 0.0;
    controller.recentTransactions.clear();
    controller.chartData.clear();
  });

  tearDown(() {
    Get.reset();
  });

  group('PengeluaranController Core Logic', () {

    test('addTransaction updates local list, current expense, and decreases total saldo', () {
      mockTotalSaldoController.totalSaldo.value = 500.0;
      controller.pengeluaranBulanIni.value = 50.0;

      const newAmount = 100.0;
      const expectedExpense = 50.0 + newAmount;
      const expectedTotalSaldo = 500.0 - newAmount;

      controller.addTransaction('Makan Siang', '2025-11-11', newAmount, 'Makanan');

      expect(controller.recentTransactions.length, 1);
      expect(controller.recentTransactions.first['amount'], newAmount);
      expect(controller.pengeluaranBulanIni.value, expectedExpense);
      expect(mockTotalSaldoController.totalSaldo.value, expectedTotalSaldo);
    });

    test('updateTransaction adjusts expense and total saldo correctly', () {
      mockTotalSaldoController.totalSaldo.value = 500.0;
      controller.addTransaction('Belanja Lama', '2025-11-12', 100.0, 'Belanja');

      const oldAmount = 100.0;
      const newAmount = 150.0;

      const expectedTotalSaldo = 400.0 - (newAmount - oldAmount);

      controller.updateTransaction(0, 'Belanja Baru', '2025-11-13', newAmount, 'Lainnya');

      expect(controller.recentTransactions.first['name'], 'Belanja Baru');

      expect(controller.pengeluaranBulanIni.value, 150.0);

      expect(mockTotalSaldoController.totalSaldo.value, expectedTotalSaldo);
    });

    test('deleteTransaction removes transaction, adjusts expense and increases total saldo', () {
      mockTotalSaldoController.totalSaldo.value = 500.0;
      controller.addTransaction('Listrik', '2025-11-14', 200.0, 'Lainnya');
      controller.addTransaction('WIFI', '2025-11-15', 50.0, 'Lainnya');

      const amountToRemove = 200.0;

      controller.deleteTransaction(0);

      expect(controller.recentTransactions.length, 1);
      expect(controller.recentTransactions.first['amount'], 50.0);

      expect(controller.pengeluaranBulanIni.value, 50.0);

      expect(mockTotalSaldoController.totalSaldo.value, 450.0);
    });
  });

  group('PengeluaranController Chart Logic', () {

    test('addData adds a new FlSpot and updates length', () {
      controller.addData(10.0);
      controller.addData(30.0);

      expect(controller.chartData.length, 2);
      expect(controller.chartData[0], FlSpot(0.0, 10.0));
      expect(controller.chartData[1], FlSpot(1.0, 30.0));
    });

    test('editData updates FlSpot and adjusts expense and total saldo', () {
      mockTotalSaldoController.totalSaldo.value = 500.0;
      controller.pengeluaranBulanIni.value = 50.0;

      controller.addData(20.0);
      controller.addData(30.0);

      controller.pengeluaranBulanIni.value = 50.0 + 50.0; // 100.0
      mockTotalSaldoController.totalSaldo.value = 500.0 - 50.0; // 450.0

      const oldAmount = 30.0;
      const newAmount = 10.0;

      controller.editData(1, newAmount);

      expect(controller.chartData[1], FlSpot(1.0, newAmount));

      expect(controller.pengeluaranBulanIni.value, 80.0);

      expect(mockTotalSaldoController.totalSaldo.value, 470.0);
    });

    test('deleteData removes FlSpot, adjusts expense, and increases total saldo', () {
      controller.addData(100.0);
      controller.addData(20.0);
      controller.addData(30.0);

      controller.pengeluaranBulanIni.value = 150.0;
      mockTotalSaldoController.totalSaldo.value = 500.0;

      const amountToRemove = 20.0;

      controller.deleteData(1);

      expect(controller.chartData.length, 2);

      expect(controller.pengeluaranBulanIni.value, 130.0);

      expect(mockTotalSaldoController.totalSaldo.value, 520.0);

      expect(controller.chartData[0], FlSpot(0.0, 100.0));
      expect(controller.chartData[1], FlSpot(1.0, 30.0));
    });
  });
}