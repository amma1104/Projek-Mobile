import 'package:get/get.dart';

class StatistikaController extends GetxController {
  // Contoh variabel untuk menyimpan data statistika
  final dataStatistika = <String, dynamic>{}.obs;

  // Variabel untuk menyimpan status dropdown urutan
  var selectedSort = 'Pemasukan'.obs;

  // Metode untuk memperbarui urutan
  void updateSort(String newSort) {
    selectedSort.value = newSort;
    // Logika tambahan jika perlu, seperti menyortir data berdasarkan pilihan
    if (newSort == "Terbesar") {
      // Logika pengurutan terbesar
      print("Data disortir berdasarkan Terbesar");
    } else if (newSort == "Terkecil") {
      // Logika pengurutan terkecil
      print("Data disortir berdasarkan Terkecil");
    } else if (newSort == "Tanggal") {
  // Logika pengurutan berdasarkan tanggal
    print("Data disortir berdasarkan Tanggal");
  }
  }

  @override
  void onInit() {
    super.onInit();
  }
}
