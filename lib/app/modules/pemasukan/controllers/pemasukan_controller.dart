import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:tugasteori1/app/modules/profile/controllers/profile_controller.dart';
import 'package:tugasteori1/app/modules/saldo/controllers/total_saldo_controller.dart';

class PemasukanController extends GetxController {

  var name = ''.obs;  // Inisialisasi dengan string kosong

  var type = ''.obs;

  // Pendapatan bulan ini
  var pendapatanBulanIni = 0.0.obs;

  // Data transaksi pendapatan terbaru (kosongkan)
  var recentTransactions = <Map<String, dynamic>>[].obs;

  RxList<FlSpot> chartData = <FlSpot>[].obs;

  final TotalSaldoController saldoController = Get.find<TotalSaldoController>(); // Akses controller global

  // Fungsi untuk mengambil data nama pengguna dari Firestore
  Future<void> getUserData() async {
    try {
      // Ambil UID pengguna yang sedang login
      String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (uid.isNotEmpty) {
        // Ambil data profil dari Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('data_profile').doc(uid).get();
        if (userDoc.exists) {
          // Update nilai name dengan data dari Firestore
          name.value = userDoc['name'] ?? 'Nama tidak ditemukan';
        }
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  void updateName() {
    name.value = Get.find<ProfileController>().name.value;
  }

  @override
  void onInit() {
    super.onInit();
    getUserData(); // Panggil fungsi getUserData saat controller diinisialisasi
  }

  // Fungsi untuk menambahkan transaksi baru
  void addTransaction(String name, String date, double amount) {
    var newTransaction = {
      'name': name,
      'date': date,
      'amount': amount,
      'type': 'masuk',
    };

    // Tambahkan transaksi ke list lokal
    recentTransactions.add(newTransaction);
    recentTransactions.refresh(); // Refresh RxList untuk update UI

    // Tambah amount ke pendapatan bulan ini dan total saldo
    pendapatanBulanIni.value += amount;
    saldoController.totalSaldo.value += amount; // Perbarui saldo global

    print('Total Saldo: ${saldoController.totalSaldo.value}');
    print('Pendapatan Bulan Ini: ${pendapatanBulanIni.value}');
    update();
  }

  // Fungsi untuk memperbarui transaksi
  void updateTransaction(int index, String name, String date, double amount) {
    var oldAmount = recentTransactions[index]['amount'];

    var updatedTransaction = {
      'name': name,
      'date': date,
      'amount': amount,
      'type': 'masuk',
    };

    // Perbarui transaksi di list lokal
    recentTransactions[index] = updatedTransaction;
    recentTransactions.refresh(); // Refresh RxList untuk update UI

    // Update pendapatan bulan ini dan total saldo
    pendapatanBulanIni.value += amount - oldAmount;
    saldoController.totalSaldo.value += amount - oldAmount; // Perbarui saldo global

    print('Total Saldo: ${saldoController.totalSaldo.value}');
    print('Pendapatan Bulan Ini: ${pendapatanBulanIni.value}');

    update();
  }

  // Fungsi untuk menghapus transaksi
  void deleteTransaction(int index) {
    var amountToRemove = recentTransactions[index]['amount'];

    // Hapus transaksi dari list lokal
    recentTransactions.removeAt(index);
    recentTransactions.refresh(); // Refresh RxList untuk update UI

    // Kurangi amount dari pendapatan bulan ini dan total saldo
    pendapatanBulanIni.value -= amountToRemove;
    saldoController.totalSaldo.value -= amountToRemove; // Perbarui saldo global

    print('Total Saldo: ${saldoController.totalSaldo.value}');
    print('Pendapatan Bulan Ini: ${pendapatanBulanIni.value}');

    update();
  }

  // Method to add data to the chart
  void addData(double amount) {
    chartData.add(FlSpot(chartData.length.toDouble(), amount)); // Add new data point
  }

  // Method to edit data at a specific index
  void editData(int index, double newAmount) {
    double oldAmount = chartData[index].y;
    pendapatanBulanIni.value -= oldAmount;
    pendapatanBulanIni.value += newAmount;
    saldoController.totalSaldo.value -= oldAmount;
    saldoController.totalSaldo.value += newAmount; // Perbarui saldo global
    chartData[index] = FlSpot(index.toDouble(), newAmount); // Edit data point
  }

  // Method to delete data from the chart
  void deleteData(int index) {
    double removedAmount = chartData[index].y;
    pendapatanBulanIni.value -= removedAmount;
    saldoController.totalSaldo.value -= removedAmount; // Perbarui saldo global
    chartData.removeAt(index); // Remove data point

    // Adjust the remaining data to maintain the correct indices
    for (int i = index; i < chartData.length; i++) {
      chartData[i] = FlSpot(i.toDouble(), chartData[i].y);
    }
  }
}