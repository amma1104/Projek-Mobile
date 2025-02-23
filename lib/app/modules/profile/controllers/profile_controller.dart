import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:tugasteori1/app/modules/home/controllers/home_controller.dart';
import 'package:tugasteori1/app/modules/saldo/controllers/total_saldo_controller.dart';
import 'package:tugasteori1/app/routes/app_routes.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GetStorage _storage = GetStorage();
  final Connectivity _connectivity = Connectivity();

  String? _currentUserId;
  RxString name = ''.obs;               // Ganti 'var' dengan 'RxString'
  RxString email = ''.obs;              // Ganti 'var' dengan 'RxString'
  RxString language = ''.obs;           // Ganti 'var' dengan 'RxString'
  RxString pin = ''.obs;                // Ganti 'var' dengan 'RxString'
  RxString password = ''.obs;           // Ganti 'var' dengan 'RxString'
  RxString recognizedText = ''.obs;     // Ganti 'var' dengan 'RxString'
  Rx<Position?> currentPosition = Rx<Position?>(null);
  RxString locationMessage = "Lokasi belum diperbarui.".obs;
  RxBool loading = false.obs;
  // Objek observable untuk data lokal
  RxString localName = ''.obs;          // Ganti 'var' dengan 'RxString'
  RxString localEmail = ''.obs;         // Ganti 'var' dengan 'RxString'
  RxString localLanguage = ''.obs;      // Ganti 'var' dengan 'RxString'
  RxString localPin = ''.obs;           // Ganti 'var' dengan 'RxString'
  RxString localPassword = ''.obs;      // Ganti 'var' dengan 'RxString'
  RxString localRecognizedText = ''.obs; // Ganti 'var' dengan 'RxString'
  // Speech-to-Text variables
  late stt.SpeechToText _speech;
  bool isListening = false; // To track if the speech-to-text is active

  // Text-to-Speech instance
  late FlutterTts _tts;

  @override
  void onInit() {
    super.onInit();
    getUserData();
    _initializeSpeech();
    _initializeTTS();
    _checkPendingUpload();
    _connectivity.onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult != ConnectivityResult.none) {
        _uploadPendingData();
      } else {
        // Ketika koneksi tidak ada, tampilkan data lokal
        checkLocalData();
      }
    });
  }

  //Initialize the SpeechToText object asynchronously
  void _initializeSpeech() async {
    _speech = stt.SpeechToText(); // Initialize SpeechToText instance
    bool available = await _speech.initialize();
    if (available) {
      print("Speech recognition is available.");
    } else {
      print("Speech recognition is not available.");
    }
  }

  // Start speech recognition (when the user taps the mic icon)
  void startListening() async {
    if (!isListening) { // Only start listening if it's not already listening
      bool available = await _speech.initialize();
      if (available) {
        _speech.listen(onResult: (result) {
          recognizedText.value =
              result.recognizedWords; // Set recognized text to recognizedText
          update(); // Update UI if using reactive variables
        });
        isListening = true;
      } else {
        print("Speech recognition is not available.");
      }
    }
  }

  // Stop speech recognition
  void stopListening() async {
    if (isListening) {
      await _speech.stop();
      isListening = false;
    }
  }

  // Initialize Text-to-Speech
  void _initializeTTS() {
    _tts = FlutterTts();
    _tts.setLanguage("id-ID"); // Set to Indonesian (you can change this)
    _tts.setPitch(5.0); // Set pitch
    _tts.setSpeechRate(0.5); // Set speed
  }

  // Stop speaking
  Future<void> stopSpeaking() async {
    await _tts.stop();
  }

  // Method to be called when the user presses "Simpan" (Save)
  void onSave() {
    stopListening(); // Stop listening when saving
    saveUserData(); // Save user data
  }

  // Mendapatkan data pengguna termasuk audioLink
  Future<void> getUserData() async {
    email.value = _auth.currentUser?.email ?? '';
    print("Current User Email: ${email.value}");

    try {
      QuerySnapshot userDocs = await _firestore.collection('data_profile')
          .where('email', isEqualTo: email.value)
          .limit(1)  // Batasi hanya 1 dokumen yang sesuai
          .get();
      if (userDocs.docs.isNotEmpty) {
        var data = userDocs.docs.first.data() as Map<String, dynamic>;
        name.value = data['name'] ?? '';
        pin.value = data['pin'] ?? '';
        language.value = data['bahasa'] ?? '';
        password.value = data['password'] ?? '';
        print("User Data: $data");
      } else {
        print("User document does not exist.");
      }
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  // Logout method
  void logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      final totalSaldoController = Get.find<TotalSaldoController>();
      totalSaldoController.resetSaldo();
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      print("Error during logout: $e");
    }
  }

  // Reset data pengguna
  void resetUserData() {
    name.value = '';
    email.value = '';
    language.value = '';
    pin.value = '';
    password.value = '';
  }


  // Menyimpan data pengguna ke Firestore
// Save user data to Firestore with local storage fallback
  Future<void> saveUserData() async {
    try {
      print("Saving user data: ${name.value}, ${email.value}, ${language
          .value}, ${pin.value}, ${password.value}");
      // Try to upload data to Firestore
      await _firestore.collection('data_profile')
          .doc(_auth.currentUser?.uid)
          .set({
        'name': name.value,
        'email': email.value,
        'bahasa': language.value,
        'pin': pin.value,
        'password': password.value,
        'recognizedText': recognizedText.value,
        // Save recognizedText as speech input
      });

      // Clear pending data in local storage if upload is successful
      await _storage.remove('pendingUserData');
      print("Hapus data di lokal.");
      print("Data successfully uploaded to Firestore.");
    } catch (e) {
      // If there's an error (e.g., no internet), save data locally
      _storage.write('pendingUserData', {
        'name': name.value,
        'email': email.value,
        'bahasa': language.value,
        'pin': pin.value,
        'password': password.value,
        'recognizedText': recognizedText.value,
        // Save recognizedText as speech input
      });
      print("Data saved locally due to network error: $e");
    }
  }

  // Check if there is any pending data to upload from local storage
  void _checkPendingUpload() {
    final pendingData = _storage.read('pendingUserData');
    if (pendingData != null) {
      name.value = pendingData['name'];
      email.value = pendingData['email'];
      language.value = pendingData['bahasa'];
      pin.value = pendingData['pin'];
      password.value = pendingData['password'];
      recognizedText.value = pendingData['recognizedText'];

      // Tampilkan data yang ditemukan di konsol
      debugPrint("Data lokal ditemukan: $pendingData");

      // Try to upload the pending data to Firestore
      _uploadPendingData();
    }
  }

  // Upload pending data from local storage to Firestore
  void _uploadPendingData() async {
    final pendingData = _storage.read('pendingUserData');
    if (pendingData != null) {
      try {
        await _firestore.collection('data_profile')
            .doc(_auth.currentUser?.uid)
            .set(pendingData);
        // After successful upload, remove data from local storage
        await _storage.remove('pendingUserData');
        print("Successfully uploaded pending data.");
      } catch (e) {
        print("Error uploading pending data: $e");
      }
    }
  }

  // Fungsi untuk mengecek data yang disimpan di lokal
  void checkLocalData() {
    // Membaca data dari GetStorage dengan key 'pendingUserData'
    final pendingData = _storage.read('pendingUserData');

    if (pendingData != null) {
      print("Data lokal ditemukan: $pendingData");

      name.value = pendingData['name'];
      email.value = pendingData['email'];
      language.value = pendingData['bahasa'];
      pin.value = pendingData['pin'];
      password.value = pendingData['password'];
      recognizedText.value = pendingData['recognizedText'];

      // Misalnya, jika data lokal ada, Anda bisa menampilkan data tertentu
      print("Nama: ${pendingData['name']}");
      print("Email: ${pendingData['email']}");
      print("Bahasa: ${pendingData['bahasa']}");
      print("PIN: ${pendingData['pin']}");
      print("Password: ${pendingData['password']}");
      print("Recognized Text: ${pendingData['recognizedText']}");
    } else {
      print("Tidak ada data lokal ditemukan.");
    }
  }

  // Edit nama pengguna
  void editName(String newName) {
    name.value = newName;
    saveUserData();
  }

  void deleteName() {
    name.value = '';
    saveUserData();
  }

  // Edit email pengguna
  void editEmail(String newEmail) {
    email.value = newEmail;
    saveUserData();
  }

  void deleteEmail() {
    email.value = '';
    saveUserData();
  }

  // Edit bahasa pengguna
  void editLanguage(String newLanguage) {
    language.value = newLanguage;
    saveUserData();
  }

  void deleteLanguage() {
    language.value = '';
    saveUserData();
  }

  // Edit PIN pengguna
  void editPin(String newPin) {
    pin.value = newPin;
    saveUserData();
  }

  void deletePin() {
    pin.value = '';
    saveUserData();
  }

  // Edit password pengguna
  void editPassword(String newPassword) {
    password.value = newPassword;
    saveUserData();
  }

  void deletePassword() {
    password.value = '';
    saveUserData();
  }

  // Login method
  Future<void> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      String? newUserId = userCredential.user?.uid;

      DocumentSnapshot userDoc = await _firestore.collection('data_profile')
          .doc(newUserId)
          .get();

      if (!userDoc.exists) {
        name.value = 'Nama Default';
        language.value = 'Bahasa Default';
        pin.value = '0000';

        await _firestore.collection('data_profile').doc(newUserId).set({
          'name': name.value,
          'email': email,
          'bahasa': language.value,
          'pin': pin.value,
          'audioLink': '', // Set audioLink kosong saat pendaftaran pertama
        });

        print("New user data saved for user ID: $newUserId");
      } else {
        getUserData();
      }

      _currentUserId = newUserId;
      Get.toNamed(AppRoutes.profile);
    } catch (e) {
      print("Login error: $e");
    }
  }

  Future<void> getCurrentLocation() async {
    loading.value = true;

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        throw Exception('Layanan lokasi tidak aktif.');
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw Exception('Izin lokasi ditolak.');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception('Izin lokasi ditolak secara permanen.');
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      currentPosition.value = position;

      locationMessage.value =
      "Latitude: ${position.latitude}\nLongitude: ${position.longitude}";
    } catch (e) {
      locationMessage.value = 'Gagal mendapatkan lokasi: $e';
    } finally {
      loading.value = false;
    }
  }

  void openGoogleMaps() {
    if (currentPosition.value != null) {
      final url =
          'https://www.google.com/maps?q=bank+terdekat+${currentPosition.value!
          .latitude},${currentPosition.value!.longitude}';
      _launchURL(url);
    } else {
      Get.snackbar('Error', 'Lokasi belum tersedia.');
    }
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      Get.snackbar('Error', 'Tidak dapat membuka URL.');
    }
  }
}
