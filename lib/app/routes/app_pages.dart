import 'package:get/get.dart';
import 'package:tugasteori1/app/modules/berita/views/berita_view.dart';
import 'package:tugasteori1/app/modules/berita/Bindings/berita_binding.dart';
import 'package:tugasteori1/app/modules/home/bindings/home_binding.dart';
import 'package:tugasteori1/app/modules/home/views/home_view.dart';
import 'package:tugasteori1/app/modules/pemasukan/bindings/pemasukan_binding.dart';
import 'package:tugasteori1/app/modules/pemasukan/views/pemasukan_view.dart';
import 'package:tugasteori1/app/modules/pengeluaran/bindings/pengeluaran_binding.dart';
import 'package:tugasteori1/app/modules/pengeluaran/views/pengeluaran_view.dart';
import 'package:tugasteori1/app/modules/profile/bindings/profile_binding.dart';
import 'package:tugasteori1/app/modules/profile/views/profile_view.dart';
import 'package:tugasteori1/app/modules/statistik/bindings/statistik_binding.dart';
import 'package:tugasteori1/app/modules/statistik/views/statistik_view.dart';
import 'package:tugasteori1/app/modules/tutorial/bindings/tutorial_binding.dart';
import 'package:tugasteori1/app/modules/tutorial/views/tutorial_view.dart';

import 'app_routes.dart';

class AppPages {
  static const String pemasukan = '/pemasukan';
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => HomeView(), // Define the HomeView as the first page
      binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.pemasukan,
      page: () => PemasukanView(), // Define the PemasukanView for the second page
      binding: PemasukanBinding(),
    ),
    GetPage(
      name: AppRoutes.pengeluaran,
      page: () => PengeluaranView(),
      binding: PengeluaranBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.berita,  // pastikan nama AppRoutes sesuai
      page: () => BeritaView(), // pastikan nama class sesuai
      binding: BeritaBinding(),
    ),
    GetPage(
      name: AppRoutes.statistika,  // pastikan nama AppRoutes sesuai
      page: () => StatistikaView(), // pastikan nama class sesuai
      binding: StatistikaBinding(),
    ),
    GetPage(
      name: AppRoutes.tutorial,  // pastikan nama AppRoutes sesuai
      page: () => TutorialView(), // pastikan nama class sesuai
      binding: TutorialBinding(),
    ),
  ];
}


