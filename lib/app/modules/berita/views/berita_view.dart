import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugasteori1/app/modules/berita/controllers/berita_controller.dart';
import 'package:tugasteori1/app/modules/berita/views/webview_container.dart';
import 'package:tugasteori1/app/modules/pemasukan/views/pemasukan_view.dart';
import 'package:tugasteori1/app/modules/profile/views/profile_view.dart';
import 'package:tugasteori1/app/modules/statistik/views/statistik_view.dart';
import 'package:tugasteori1/app/routes/app_routes.dart';

class BeritaView extends StatefulWidget {
  @override
  _BeritaViewState createState() => _BeritaViewState();
}

class _BeritaViewState extends State<BeritaView> {
  // Index untuk navigasi antar tab
  int _selectedIndex = 2; // Default adalah tab "Berita"

  // Daftar halaman yang sesuai dengan navigasi bar
  final List<Widget> _pages = [
    PemasukanMainView(),  // Halaman Pemasukan
    StatistikMainView(),      // Halaman Statistik
    BeritaMainView(),       // Halaman Berita
    ProfileMainView(),         // Halaman Profil
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex, // Kontrol halaman yang ditampilkan
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        // Tab yang aktif
        onTap: _onItemTapped,
        // Mengubah tab
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.stacked_bar_chart_rounded),
            label: 'Statistik',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.newspaper_rounded),
            label: 'Berita',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_rounded),
            label: 'Profil',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        backgroundColor: Colors.white,
      ),
    );
  }
}

  class BeritaMainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.lazyPut<BeritaController>(() => BeritaController());
    final BeritaController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Berita',
          style: TextStyle(color: Colors.black), // Set warna teks menjadi putih
        ),
        backgroundColor: Colors.grey[200],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.pemasukan);
          },
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        else if (!controller.isConnected.value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi_off,
                  size: 100,
                  color: Colors.red,
                ),
                SizedBox (height: 16),
                Text(
                  'Tidak ada koneksi internet',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          );
        } else {
          return ListView.builder(
            itemCount: controller.beritaList.length,
            itemBuilder: (context, index) {
              var berita = controller.beritaList[index];
              return GestureDetector(
                onTap: () {
                  Get.to(() => WebViewContainer(berita.url));
                },
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0), // Jarak vertikal antar berita
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25), // Rounded corners
                  ),
                  child: Stack(
                    children: [
                      // Thumbnail with a dark overlay
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: Stack(
                          children: [
                            Image.network(
                              berita.imageUrl,
                              width: double.infinity,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                            Container(
                              width: double.infinity,
                              height: 200,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.black.withOpacity(0.4), Colors.transparent],
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Centered title
                      Positioned.fill(
                        child: Align(
                          alignment: Alignment.center, // Center the title
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              berita.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center, // Ensure text is centered
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2, // Ensure title wraps to two lines at most
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}