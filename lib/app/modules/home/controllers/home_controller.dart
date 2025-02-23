
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  // Reactive state variable for the message
  var message = "Hidup Chill\nCuan Tetap Stabil!".obs;

  // Method to handle button press for navigation
  void onStartPressed() {
    Get.toNamed('/pemasukan'); // Navigate to the Pemasukan page
  }

  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    super.onInit();
    _connectivity.onConnectivityChanged.listen((connectivityResult) {
      // Jika connectivityResult adalah List<ConnectivityResult>, kita ambil hasil pertama
        _updateConnectionStatus(connectivityResult.first);
    });
  }

// Fungsi untuk mengupdate status koneksi
  void _updateConnectionStatus(ConnectivityResult connectivityResult) {
    if (connectivityResult == ConnectivityResult.none) {
      Get.snackbar(
        "No Internet Connection",
        "You are disconnected from the internet.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        "Connected",
        "You are connected to the internet.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

}