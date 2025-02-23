import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:tugasteori1/app/modules/berita/models/berita_model.dart';
import 'package:tugasteori1/app/modules/berita/services/berita_service.dart';

class BeritaController extends GetxController {
  var beritaList = <BeritaModel>[].obs;
  var isLoading = true.obs;
  var isConnected = true.obs; // Properti untuk status koneksi

  final Connectivity _connectivity = Connectivity();

  @override
  void onInit() {
    fetchBerita();
    super.onInit();
    _connectivity.onConnectivityChanged.listen((connectivityResult) {
      // Memperbarui status koneksi setiap kali ada perubahan
      _updateConnectionStatus(connectivityResult.first);
    });
  }

  void fetchBerita() async {
    try {
      isLoading(true);
      var berita = await BeritaService.fetchBerita();
      beritaList.assignAll(berita);
    } finally {
      isLoading(false);
    }
  }


  // Fungsi untuk memperbarui status koneksi
  void _updateConnectionStatus(ConnectivityResult result) {
    isConnected.value = result != ConnectivityResult.none;
  }
}