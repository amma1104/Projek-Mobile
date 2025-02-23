import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugasteori1/app/modules/berita/Views/berita_view.dart';
import 'package:tugasteori1/app/modules/berita/controllers/berita_controller.dart';
import 'package:tugasteori1/app/modules/home/controllers/home_controller.dart';
import 'package:tugasteori1/app/modules/home/views/home_view.dart';
import 'package:tugasteori1/app/modules/pemasukan/controllers/pemasukan_controller.dart';
import 'package:tugasteori1/app/modules/pemasukan/views/pemasukan_view.dart';
import 'package:tugasteori1/app/modules/pengeluaran/controllers/pengeluaran_controller.dart';
import 'package:tugasteori1/app/modules/pengeluaran/views/pengeluaran_view.dart';
import 'package:tugasteori1/app/modules/profile/controllers/profile_controller.dart';
import 'package:tugasteori1/app/modules/profile/views/profile_view.dart';
import 'package:tugasteori1/app/modules/saldo/controllers/total_saldo_controller.dart';
import 'package:tugasteori1/app/modules/statistik/controllers/statistik_controller.dart';
import 'package:tugasteori1/app/modules/statistik/views/statistik_view.dart';
import 'package:tugasteori1/app/modules/tutorial/controllers/tutorial_controller.dart';
import 'package:tugasteori1/app/modules/tutorial/views/tutorial_view.dart';
import 'package:tugasteori1/app/routes/app_routes.dart';
import 'package:tugasteori1/firebase_options.dart';
import 'package:tugasteori1/notification_handler.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Get.putAsync(() async => await SharedPreferences.getInstance());
  await FirebaseMessagingHandler().initPushNotification();
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  await GetStorage.init();
  Get.lazyPut<HomeController>(() => HomeController());
  Get.lazyPut<PemasukanController>(() => PemasukanController(), );
  Get.lazyPut<PengeluaranController>(() => PengeluaranController());
  Get.lazyPut<BeritaController>(() => BeritaController());
  Get.lazyPut<ProfileController>(() => ProfileController());
  Get.lazyPut<StatistikaController>(() => StatistikaController());
  Get.lazyPut<TutorialController>(() => TutorialController());
  Get.put(TotalSaldoController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(

      title: 'Your App',
      initialRoute: '/', // Halaman awal
      getPages: [
        GetPage(name: '/', page: () => HomeView()), // Main Page
        GetPage(name: AppRoutes.pemasukan, page: () => PemasukanView()),
        GetPage(name: AppRoutes.pengeluaran, page: () => PengeluaranView()),
        GetPage(name: AppRoutes.statistika, page: () => StatistikaView()),
        GetPage(name: AppRoutes.berita, page: () => BeritaView()),
        GetPage(name: AppRoutes.profile, page: () => ProfileView()),
        GetPage(name: '/tutorial', page: () => TutorialView()), // Contoh rute tutorial
      ],
    );
  }
}

