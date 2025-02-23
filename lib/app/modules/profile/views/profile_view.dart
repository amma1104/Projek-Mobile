import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:tugasteori1/app/modules/berita/views/berita_view.dart';
import 'package:tugasteori1/app/modules/pemasukan/views/pemasukan_view.dart';
import 'dart:io';
import 'package:tugasteori1/app/modules/profile/controllers/profile_controller.dart';
import 'package:tugasteori1/app/modules/statistik/views/statistik_view.dart';
import 'package:tugasteori1/app/routes/app_routes.dart';
import 'package:video_player/video_player.dart'; // Import video_player

void _speak(String text) async {
  FlutterTts tts = FlutterTts();
  if (text.isNotEmpty) {
    await tts.speak(text);
  } else {
    Get.snackbar(
      "Info",
      "Tidak ada teks untuk dibacakan!",
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }
}

class ProfileView extends StatefulWidget {
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  int _selectedIndex = 3;

  final List<Widget> _pages = [
    PemasukanMainView(),  // Halaman Pemasukan
    StatistikMainView(),      // Halaman Statistik
    BeritaMainView(),              // Halaman Berita
    ProfileMainView(),         // Halaman Profil
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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

class ProfileMainView extends StatefulWidget {
  @override
  _ProfileMainViewState createState() => _ProfileMainViewState();
}

class _ProfileMainViewState extends State<ProfileMainView> {
  File? _imageFile;
  VideoPlayerController? _videoController; // Video player controller
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        _videoController = null; // Clear video controller if an image is selected
      });
    }
  }

  // Fungsi untuk memilih video
  Future<void> _pickVideo(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickVideo(source: source);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Menyimpan file video
        _videoController = VideoPlayerController.file(_imageFile!) // Inisialisasi controller video
          ..initialize().then((_) {
            setState(() {});
            _videoController?.play(); // Memutar video setelah inisialisasi
          });
      });
    } else {
      print("Tidak ada video yang dipilih.");
    }
  }

  @override
  void dispose() {
    super.dispose();
    _videoController?.dispose(); // Jangan lupa untuk dispose controller video
  }


  @override
  Widget build(BuildContext context) {
    Get.lazyPut<ProfileController>(() => ProfileController());
    final profilcontroller = Get.find<ProfileController>();
    final authController = Get.find<ProfileController>(); // Find AuthController


    return Scaffold(
      appBar: AppBar(
        title: Text("Profil", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.grey[200],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.pemasukan);
          },
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Gambar Profil atau Video di atas Nama
              GestureDetector(
                onTap: () => _showImageSourceActionSheet(context),
                child: _imageFile != null
                    ? _videoController != null && _videoController!.value.isInitialized
                    ? Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipOval(
                      child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(60),
                          color: Colors.black,
                        ),
                        child: VideoPlayer(_videoController!),
                      ),
                    ),
                    Positioned(
                      bottom: -10, // Menempatkan tombol sedikit di luar lingkaran
                      child: IconButton(
                        icon: Icon(
                          _videoController!.value.isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          size: 40,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            if (_videoController!.value.isPlaying) {
                              _videoController?.pause();
                            } else {
                              _videoController?.play();
                            }
                          });
                        },
                      ),
                    ),
                  ],
                )
                    : ClipOval(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: FileImage(_imageFile!),
                  ),
                )
                    : CircleAvatar(
                  radius: 60,
                  child: Icon(Icons.camera_alt, size: 50, color: Colors.grey),
                ),
              ),
              SizedBox(height: 20),
              // Nama Pengguna
              Obx(() =>
                  Text(
                    profilcontroller.name.value.isEmpty
                        ? "Nama belum diisi"
                        : profilcontroller.name.value,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  )),
              SizedBox(height: 20),
      Container(
        width: double.infinity,  // Ensures the card stretches across the width of the screen
        margin: EdgeInsets.all(1), // Increased margin around the card
        child: Card(
          color: Colors.white,  // Background color of the card
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
              ListTile(
                leading: Icon(Icons.person, color: Colors.blue),
                title: Text('Nama Panggilan'),
                subtitle: Obx(() =>
                    Text(profilcontroller.name.value.isEmpty
                        ? "Tidak ada nama"
                        : profilcontroller.name.value)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.volume_up),
                      onPressed: () => _speak(profilcontroller.name.value),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditNameBottomSheet(context, profilcontroller);
                      },
                    ),
                  ],
                ),
              ),
                Divider(),
              ListTile(
                leading: Icon(Icons.email, color: Colors.blue),
                title: Text('Email'),
                subtitle: Obx(() =>
                    Text(profilcontroller.email.value.isEmpty
                        ? "Tidak ada email"
                        : profilcontroller.email.value)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.volume_up),
                      onPressed: () => _speak(profilcontroller.email.value),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditEmailBottomSheet(context, profilcontroller);
                      },
                    ),
                  ],
                ),
              ),
                Divider(),
              ListTile(
                leading: Icon(Icons.language, color: Colors.blue),
                title: Text('Bahasa'),
                subtitle: Obx(() =>
                    Text(profilcontroller.language.value.isEmpty
                        ? "Tidak ada bahasa"
                        : profilcontroller.language.value)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.volume_up),
                      onPressed: () => _speak(profilcontroller.language.value),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditLanguageBottomSheet(context, profilcontroller);
                      },
                    ),
                  ],
                ),
              ),
                Divider(),
              ListTile(
                leading: Icon(Icons.lock, color: Colors.blue),
                title: Text('PIN'),
                subtitle: Obx(() =>
                    Text(profilcontroller.pin.value.isEmpty
                        ? "Tidak ada PIN"
                        : profilcontroller.pin.value)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.volume_up),
                      onPressed: () => _speak(profilcontroller.pin.value),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditPinBottomSheet(context, profilcontroller);
                      },
                    ),
                  ],
                ),
              ),
                Divider(),
              ListTile(
                leading: Icon(Icons.lock_outline, color: Colors.blue),
                title: Text('Password'),
                subtitle: Obx(() =>
                    Text(profilcontroller.password.value.isEmpty
                        ? "Tidak ada password"
                        : "********")), // Menyembunyikan password
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.volume_up),
                      onPressed: () => _speak(profilcontroller.password.value),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        _showEditPasswordBottomSheet(context, profilcontroller);
                      },
                    ),
                  ],
                ),
              ),Divider(),
                ListTile(
                  leading: Icon(Icons.location_on, color: Colors.blue),
                  title: Text('Lokasi Terkini'),
                  onTap: () {
                    final profileController = Get.put(ProfileController());

                    showDialog(
                      context: context,
                      builder: (context) {
                        return Obx(() {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text('Lokasi Terkini'),
                            content: profileController.loading.value
                                ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 10),
                                Text('Mengambil lokasi...'),
                              ],
                            )
                                : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(profileController.locationMessage.value),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  await profileController.getCurrentLocation(); // Refresh lokasi
                                },
                                child: Text('Refresh Lokasi'),
                                style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              ),
                              TextButton(
                                onPressed: () {
                                  profileController.openGoogleMaps(); // Buka di Google Maps
                                },
                                child: Text('Buka di Google Maps'),
                                style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              ),
                            ],
                          );
                        });
                      },
                    );
                  },
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.storage, color: Colors.blue),
                  title: Text('Data Lokal'),
                  onTap: () {
                    final profileController = Get.put(ProfileController());

                    // Panggil saveUserData di sini
                    profileController.checkLocalData(); // Menyimpan data

                    showDialog(
                      context: context,
                      builder: (context) {
                        return Obx(() {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            title: Text('Data Lokal'),
                            content: profileController.loading.value
                                ? Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 10),
                                Text('Mengambil data dari lokal...'),
                              ],
                            )
                                : (profileController.name.value == null || profileController.name.value.isEmpty) &&
                                (profileController.email.value == null || profileController.email.value.isEmpty) &&
                                (profileController.language.value == null || profileController.language.value.isEmpty) &&
                                (profileController.pin.value == null || profileController.pin.value.isEmpty) &&
                                (profileController.password.value == null || profileController.password.value.isEmpty)
                                ? Text("Tidak ada data ditemukan.")
                                : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Divider(),
                                ListTile(
                                  title: Text('Nama'),
                                  subtitle: Text(profileController.name.value ?? "Tidak ada data"),
                                ),
                                Divider(),
                                ListTile(
                                  title: Text('Email'),
                                  subtitle: Text(profileController.email.value ?? "Tidak ada data"),
                                ),
                                Divider(),
                                ListTile(
                                  title: Text('Bahasa'),
                                  subtitle: Text(profileController.language.value ?? "Tidak ada data"),
                                ),
                                Divider(),
                                ListTile(
                                  title: Text('PIN'),
                                  subtitle: Text(profileController.pin.value ?? "Tidak ada data"),
                                ),
                                Divider(),
                                ListTile(
                                  title: Text('Password'),
                                  subtitle: Text(profileController.password.value ?? "Tidak ada data"),
                                ),
                                Divider(),
                              ],
                            ),

                            actions: [
                              // Tombol Tutup
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Tutup dialog
                                },
                                child: Text('Tutup'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          );
                        });
                      },
                    );
                  },
                ),
                Divider(),
                ListTile(
                  title: GestureDetector(
                    onTap: () {
                      authController.logout();
                    },
                    child: Container(
                      width: 300.0, // Adjust the width for a more elongated look
                      height: 45.0, // Adjust the height for a shorter button
                      padding: EdgeInsets.symmetric(vertical: 12.0), // Adjust vertical padding
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue), // Blue border
                      ),
                      child: Text(
                        'Keluar',
                        textAlign: TextAlign.center, // Center the text
                        style: TextStyle(
                          color: Colors.blue, // Blue text color
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
      ),
            ],
          ),
        ),
      ),
    );
  }

  // Tampilkan modal untuk memilih sumber gambar atau video
  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
        backgroundColor: Colors.grey[200],
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera),
                title: Text('Ambil Foto'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.videocam),
                title: Text('Rekam Video'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickVideo(ImageSource.camera); // Pilih kamera untuk merekam video
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Pilih dari Galeri'),
                onTap: () {
                  Navigator.of(context).pop();
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

void _showEditNameBottomSheet(BuildContext context, ProfileController controller) {
    TextEditingController nameController = TextEditingController(text: controller.name.value);
    stt.SpeechToText _speech = stt.SpeechToText();  // Initialize speech-to-text
    FlutterTts _tts = FlutterTts(); // Initialize text-to-speech

    // Method to start voice input
    void _startListening() async {
      bool available = await _speech.initialize();
      if (available) {
        _speech.listen(onResult: (result) {
          nameController.text = result.recognizedWords; // Set the recognized words into the controller
        });
      } else {
        Get.snackbar(
          "Error",
          "Speech recognition is not available.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }

    // Method to read aloud the current text
    void _speak() async {
      String text = nameController.text.trim();
      if (text.isNotEmpty) {
        await _tts.speak(text);
      } else {
        Get.snackbar(
          "Info",
          "Tidak ada teks untuk dibacakan!",
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
            color: Colors.white, // Background putih
            child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
            top: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit Nama Panggilan",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Nama",
                        labelStyle: TextStyle(color: Colors.blue), // Label berwarna biru
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue), // Border biru
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue), // Border biru saat fokus
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.mic),
                        onPressed: _startListening, // Start listening when mic button is pressed
                      ),
                      IconButton(
                        icon: Icon(Icons.volume_up),
                        onPressed: _speak, // Read the text aloud when speaker button is pressed
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      controller.deleteName();
                      Get.back(); // Close bottom sheet after action
                    },
                    child: Text("Hapus"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty) {
                        controller.editName(nameController.text); // Update name
                        Get.back(); // Close bottom sheet after saving
                      } else {
                        Get.snackbar(
                          "Error",
                          "Nama tidak boleh kosong!",
                          backgroundColor: Colors.blue,
                          colorText: Colors.white,
                        );
                      }
                    },
                    child: Text("Simpan"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
        );
      },
    );
  }

  void _showEditEmailBottomSheet(BuildContext context, ProfileController controller) {
    TextEditingController emailController = TextEditingController(text: controller.email.value);
    stt.SpeechToText _speech = stt.SpeechToText();  // Initialize speech-to-text
    FlutterTts _tts = FlutterTts(); // Initialize text-to-speech

    // Method to start voice input
    void _startListening() async {
      bool available = await _speech.initialize();
      if (available) {
        _speech.listen(onResult: (result) {
          emailController.text = result.recognizedWords; // Set the recognized words into the controller
        });
      } else {
        Get.snackbar(
          "Error",
          "Speech recognition is not available.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }

    // Method to read aloud the current text
    void _speak() async {
      String text = emailController.text.trim();
      if (text.isNotEmpty) {
        await _tts.speak(text);
      } else {
        Get.snackbar(
          "Info",
          "Tidak ada teks untuk dibacakan!",
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
            color: Colors.white, // Background putih
            child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
            top: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit Email",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.blue), // Label berwarna biru
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue), // Border biru
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue), // Border biru saat fokus
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.mic),
                        onPressed: _startListening, // Start listening when mic button is pressed
                      ),
                      IconButton(
                        icon: Icon(Icons.volume_up),
                        onPressed: _speak, // Read the text aloud when speaker button is pressed
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      controller.deleteEmail(); // Menghapus email
                      Get.back(); // Tutup bottom sheet setelah aksi
                    },
                    child: Text("Hapus"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (emailController.text.isNotEmpty) {
                        controller.editEmail(emailController.text); // Memperbarui email
                        Get.back(); // Tutup bottom sheet setelah menyimpan
                      } else {
                        Get.snackbar(
                          "Error",
                          "Email tidak boleh kosong!",
                          backgroundColor: Colors.blue,
                          colorText: Colors.white,
                        );
                      }
                    },
                    child: Text("Simpan"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                  )
                  ),
                ],
              ),
            ],
          ),
        )
        );
      },
    );
  }


  void _showEditLanguageBottomSheet(BuildContext context, ProfileController controller) {
    TextEditingController languageController = TextEditingController(text: controller.language.value);
    stt.SpeechToText _speech = stt.SpeechToText();  // Initialize speech-to-text
    FlutterTts _tts = FlutterTts(); // Initialize text-to-speech

    // Method to start voice input
    void _startListening() async {
      bool available = await _speech.initialize();
      if (available) {
        _speech.listen(onResult: (result) {
          languageController.text = result.recognizedWords; // Set the recognized words into the controller
        });
      } else {
        Get.snackbar(
          "Error",
          "Speech recognition is not available.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }

    // Method to read aloud the current text
    void _speak() async {
      String text = languageController.text.trim();
      if (text.isNotEmpty) {
        await _tts.speak(text);
      } else {
        Get.snackbar(
          "Info",
          "Tidak ada teks untuk dibacakan!",
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
            color: Colors.white, // Background putih
            child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
            top: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit Bahasa",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: languageController,
                      decoration: InputDecoration(
                        labelText: "Bahasa",
                        labelStyle: TextStyle(color: Colors.blue), // Label berwarna biru
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue), // Border biru
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue), // Border biru saat fokus
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.mic),
                        onPressed: _startListening, // Start listening when mic button is pressed
                      ),
                      IconButton(
                        icon: Icon(Icons.volume_up),
                        onPressed: _speak, // Read the text aloud when speaker button is pressed
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      controller.deleteLanguage(); // Menghapus bahasa
                      Get.back(); // Tutup bottom sheet setelah aksi
                    },
                    child: Text("Hapus"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (languageController.text.isNotEmpty) {
                        controller.editLanguage(languageController.text); // Memperbarui bahasa
                        Get.back(); // Tutup bottom sheet setelah menyimpan
                      } else {
                        Get.snackbar(
                          "Error",
                          "Bahasa tidak boleh kosong!",
                          backgroundColor: Colors.blue,
                          colorText: Colors.white,
                        );
                      }
                    },
                    child: Text("Simpan"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                  ),
                  ),
                ],
              ),
            ],
          ),
        )
        );
      },
    );
  }


  void _showEditPinBottomSheet(BuildContext context, ProfileController controller) {
    TextEditingController pinController = TextEditingController(text: controller.pin.value);
    stt.SpeechToText _speech = stt.SpeechToText();  // Initialize speech-to-text
    FlutterTts _tts = FlutterTts(); // Initialize text-to-speech

    // Method to start voice input
    void _startListening() async {
      bool available = await _speech.initialize();
      if (available) {
        _speech.listen(onResult: (result) {
          pinController.text = result.recognizedWords; // Set the recognized words into the controller
        });
      } else {
        Get.snackbar(
          "Error",
          "Speech recognition is not available.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }

    // Method to read aloud the current text
    void _speak() async {
      String text = pinController.text.trim();
      if (text.isNotEmpty) {
        await _tts.speak(text);
      } else {
        Get.snackbar(
          "Info",
          "Tidak ada teks untuk dibacakan!",
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
            color: Colors.white, // Background putih
            child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
            top: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit PIN",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: pinController,
                      decoration: InputDecoration(
                        labelText: "PIN",
                        labelStyle: TextStyle(color: Colors.blue), // Label berwarna biru
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue), // Border biru
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue), // Border biru saat fokus
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.mic),
                        onPressed: _startListening, // Start listening when mic button is pressed
                      ),
                      IconButton(
                        icon: Icon(Icons.volume_up),
                        onPressed: _speak, // Read the text aloud when speaker button is pressed
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      controller.deletePin(); // Menghapus PIN
                      Get.back(); // Tutup bottom sheet setelah aksi
                    },
                    child: Text("Hapus"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (pinController.text.isNotEmpty) {
                        controller.editPin(pinController.text); // Memperbarui PIN
                        Get.back(); // Tutup bottom sheet setelah menyimpan
                      } else {
                        Get.snackbar(
                          "Error",
                          "PIN tidak boleh kosong!",
                          backgroundColor: Colors.blue,
                          colorText: Colors.white,
                        );
                      }
                    },
                    child: Text("Simpan"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                  ),
                  ),
                ],
              ),
            ],
          ),
        )
        );
      },
    );
  }


  void _showEditPasswordBottomSheet(BuildContext context, ProfileController controller) {
    TextEditingController passwordController = TextEditingController(text: controller.password.value);
    stt.SpeechToText _speech = stt.SpeechToText();  // Initialize speech-to-text
    FlutterTts _tts = FlutterTts(); // Initialize text-to-speech

    // Method to start voice input
    void _startListening() async {
      bool available = await _speech.initialize();
      if (available) {
        _speech.listen(onResult: (result) {
          passwordController.text = result.recognizedWords; // Set the recognized words into the controller
        });
      } else {
        Get.snackbar(
          "Error",
          "Speech recognition is not available.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }

    // Method to read aloud the current text
    void _speak() async {
      String text = passwordController.text.trim();
      if (text.isNotEmpty) {
        await _tts.speak(text);
      } else {
        Get.snackbar(
          "Info",
          "Tidak ada teks untuk dibacakan!",
          backgroundColor: Colors.blue,
          colorText: Colors.white,
        );
      }
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
            color: Colors.white, // Background putih
            child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
            top: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Edit Password",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.blue), // Label berwarna biru
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue), // Border biru
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue), // Border biru saat fokus
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(Icons.mic),
                        onPressed: _startListening, // Start listening when mic button is pressed
                      ),
                      IconButton(
                        icon: Icon(Icons.volume_up),
                        onPressed: _speak, // Read the text aloud when speaker button is pressed
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      controller.deletePassword(); // Delete password
                      Get.back(); // Close bottom sheet after action
                    },
                    child: Text("Hapus"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (passwordController.text.isNotEmpty) {
                        controller.editPassword(passwordController.text); // Update password
                        Get.back(); // Close bottom sheet after saving
                      } else {
                        Get.snackbar(
                          "Error",
                          "Password tidak boleh kosong!", // Show error if password is empty
                          backgroundColor: Colors.blue,
                          colorText: Colors.white,
                        );
                      }
                    },
                    child: Text("Simpan"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                  )
                  ),
                ],
              ),
            ],
          ),
        )
        );
      },
    );
  }