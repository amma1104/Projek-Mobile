import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugasteori1/app/modules/berita/views/berita_view.dart';
import 'package:tugasteori1/app/modules/profile/controllers/profile_controller.dart';
import 'package:tugasteori1/app/modules/profile/views/profile_view.dart';
import 'package:tugasteori1/app/modules/saldo/controllers/total_saldo_controller.dart';
import 'package:tugasteori1/app/modules/statistik/views/statistik_view.dart';
import 'package:tugasteori1/app/routes/app_routes.dart';
import '../controllers/pengeluaran_controller.dart';

// Halaman PengeluaranView dengan BottomNavigationBar
class PengeluaranView extends StatefulWidget {
  @override
  _PengeluaranViewState createState() => _PengeluaranViewState();
}

class _PengeluaranViewState extends State<PengeluaranView> {
  int _selectedIndex = 0;

  // Daftar halaman yang dapat dinavigasi
  final List<Widget> _pages = [
    PengeluaranMainView(),  // Halaman Pengeluaran
    StatistikMainView(),      // Halaman Statistik
    BeritaMainView(),
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
      backgroundColor: Colors.grey[200],
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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

// Halaman utama untuk Pengeluaran
class PengeluaranMainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.lazyPut<PengeluaranController>(() => PengeluaranController());
    final PengeluaranController keluarcontroller = Get.find();
    Get.lazyPut<ProfileController>(() => ProfileController());
    final profilcontroller = Get.find<ProfileController>();
    final TotalSaldoController saldoController = Get.find();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.toNamed(AppRoutes.home);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.auto_awesome),
            color: Colors.yellow,
            onPressed: () {
              Get.snackbar("AI", "Fitur Gemini AI diklik!",
                  backgroundColor: Colors.blueAccent,
                  colorText: Colors.white);
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Informasi pengguna dan saldo
            Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: 80,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Obx(() {
                    return Text(
                      'Hi, ${profilcontroller.name.value}!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  }),
                  SizedBox(height: 50),
                  Center(
                    child: Obx(() {
                      // Akses controller global untuk saldo
                      final saldoController = Get.find<TotalSaldoController>();

                      return Text(
                        'Rp. ${saldoController.totalSaldo.value.toStringAsFixed(2)}',  // Menggunakan controller global untuk saldo
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Text(
                      'Total saldo Anda',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Transform.translate(
              offset: Offset(0, -30), // Geser tab ke atas
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Tab Pemasukan
                      GestureDetector(
                        onTap: () {
                          // Navigasi ke PemasukanView
                          Get.toNamed(AppRoutes.pemasukan);
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          decoration: BoxDecoration(
                            color: Get.currentRoute == AppRoutes.pemasukan
                                ? Colors.greenAccent
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Get.currentRoute == AppRoutes.pemasukan
                                  ? Colors.greenAccent
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            'Pemasukan',
                            style: TextStyle(
                              color: Get.currentRoute == AppRoutes.pemasukan
                                  ? Colors.white
                                  : Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      // Tab Pengeluaran
                      GestureDetector(
                        onTap: () {
                          // Navigasi ke PengeluaranView
                          Get.toNamed(AppRoutes.pengeluaran);
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                          decoration: BoxDecoration(
                            color: Get.currentRoute == AppRoutes.pengeluaran
                                ? Colors.redAccent
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: Get.currentRoute == AppRoutes.pengeluaran
                                  ? Colors.redAccent
                                  : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Text(
                            'Pengeluaran',
                            style: TextStyle(
                              color: Get.currentRoute == AppRoutes.pengeluaran
                                  ? Colors.white
                                  : Colors.grey[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pengeluaran Bulan ini',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 1),
                    Obx(() {
                      return Text(
                        'Rp. ${keluarcontroller.pengeluaranBulanIni.value.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }),
                    SizedBox(height: 10),
                    // Line chart widget with bigger size, no coordinates, no border, no grid lines, and added dots
                    SizedBox(
                      height: 100, // Increased height for a larger chart
                      child: Obx(() {
                        if (keluarcontroller.chartData.isEmpty) {
                          return Center(
                            child: Text(
                              'Belum ada data grafik',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        } else {
                        return LineChart(
                          LineChartData(
                            gridData: FlGridData(show: false), // Hide grid lines
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false), // Hide left axis titles
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false), // Hide bottom axis titles
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false), // Hide right axis titles
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false), // Hide top axis titles
                              ),
                            ),
                            borderData: FlBorderData(show: false), // Hide the border
                            lineBarsData: [
                              LineChartBarData(
                                spots: keluarcontroller.chartData, // Use dynamic chart data from controller
                                isCurved: true,
                                color: Colors.redAccent, // Line color
                                dotData: FlDotData(
                                  show: true, // Show dots
                                  getDotPainter: (spot, _, __, ___) {
                                    // Add a dot at the peak points (highest spots)
                                    if (spot.y == keluarcontroller.chartData.map((e) => e.y).reduce((a, b) => a > b ? a : b)) {
                                      return FlDotCirclePainter(
                                        radius: 6,
                                        color: Colors.redAccent,
                                        strokeWidth: 2,
                                        strokeColor: Colors.white,
                                      );
                                    }
                                    // Hide dots for other spots
                                    return FlDotCirclePainter(radius: 0);
                                  },
                                ),
                                belowBarData: BarAreaData(
                                  show: true,
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.redAccent.withOpacity(0.2),
                                      Colors.redAccent.withOpacity(0.0),
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
    }
    }),
    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),

            // Pendapatan terakhir
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Pengeluaran terakhir lu',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),

// Daftar transaksi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      // If no transactions, show a placeholder
                      if (keluarcontroller.recentTransactions.isEmpty) {
                        return Center(
                          child: Text(
                            'Belum ada data transaksi',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        );
                      } else {
                        return Column(
                          children: keluarcontroller.recentTransactions.asMap().entries.map((entry) {
                            int index = entry.key;
                            var transaction = entry.value;

                            return TransactionItem(
                              icon: Icons.shopping_cart, color: Colors.red, // Add the appropriate icon
                              name: transaction['name'],
                              date: transaction['date'],
                              amount: 'Rp. ${transaction['amount']}',
                              index: index, // Pass the index here
                              sort: transaction['sort'],
                            );
                          }).toList(),
                        );
                      }
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: Container(
        width: 56,  // Ukuran lebar tombol
        height: 56, // Ukuran tinggi tombol
        decoration: BoxDecoration(
          color: Colors.blue, // Warna latar belakang tombol
          shape: BoxShape.circle, // Bentuk tombol bulat
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Warna bayangan
              offset: Offset(0, 4), // Posisi bayangan (X, Y)
              blurRadius: 8, // Jarak kabur bayangan
              spreadRadius: 2, // Penyebaran bayangan
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(Icons.add, color: Colors.white),
          onPressed: () {
            // Show a popup to add a new transaction
            showDialog(
              context: context,
              builder: (context) {
                return AddTransactionDialog();
              },
            );
          },
        ),
      ),
    );
  }
}

class AddTransactionDialog extends StatefulWidget {
  @override
  _AddTransactionDialogState createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  String? selectedSort;

  // Function to show the date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            dialogBackgroundColor: Colors.white, // Latar belakang putih
            colorScheme: ColorScheme.light(
              primary: Colors.blue, // Warna elemen yang dipilih (biru)
              onSurface: Colors.black, // Warna teks
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // Warna tombol navigasi
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text =
        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Slightly squared corners
      ),
      backgroundColor: Colors.white, // White background
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Name Field
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Nama Transaksi',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Date Picker Field
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: dateController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Tanggal',
                  labelStyle: TextStyle(color: Colors.grey),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
            ),
            SizedBox(height: 16),

            // Amount Field
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: amountController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Masukkan Pengeluaran',
                  labelStyle: TextStyle(color: Colors.grey),
                  prefixText: 'Rp. ',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 20),

            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedSort,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                  dropdownColor: Colors.grey[100], // warna latar menu dropdown
                  borderRadius: BorderRadius.circular(10), // border radius menu
                  items: <String>['Makanan', 'Transport', 'Belanja', 'Lainnya']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSort = newValue!;
                    });
                  },
                  hint: Text(
                    'Jenis Pengeluaran',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isEmpty) {
                        Get.snackbar("Failed", "Nama Transaksi tidak boleh kosong",
                            backgroundColor: Colors.red, colorText: Colors.white);
                      } else if (dateController.text.isEmpty) {
                        Get.snackbar("Failed", "Tanggal tidak boleh kosong",
                            backgroundColor: Colors.red, colorText: Colors.white);
                      } else if (amountController.text.isEmpty) {
                        Get.snackbar("Failed", "Pengeluaran tidak boleh kosong",
                            backgroundColor: Colors.red, colorText: Colors.white);
                      } else if (selectedSort == null || selectedSort!.isEmpty) {
                        Get.snackbar("Failed", "Jenis pengeluaran tidak boleh kosong",
                            backgroundColor: Colors.red, colorText: Colors.white);
                      } else {
                        final name = nameController.text;
                        final date = dateController.text;
                        final amount = double.parse(amountController.text);

                        Get.find<PengeluaranController>().addTransaction(
                          nameController.text,
                          dateController.text,
                          double.parse(amountController.text),
                          selectedSort!, // jenis pemasukan
                        );
                        Get.find<PengeluaranController>().addData(double.parse(amountController.text));

                        Navigator.pop(context);

                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Tambah',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Batalkan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditTransactionDialog extends StatefulWidget {
  final String name;
  final String date;
  final double amount;
  final int transactionIndex;

  EditTransactionDialog({
    required this.name,
    required this.date,
    required this.amount,
    required this.transactionIndex,
  });

  @override
  _EditTransactionDialogState createState() => _EditTransactionDialogState();
}

class _EditTransactionDialogState extends State<EditTransactionDialog> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  late double oldAmount; // Store the old transaction amount
  String? selectedSort;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name;
    dateController.text = widget.date;
    amountController.text = widget.amount.toString();
    oldAmount = widget.amount; // Set the old amount when editing

    selectedSort = Get.find<PengeluaranController>()
        .recentTransactions[widget.transactionIndex]['sort'];
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            dialogBackgroundColor: Colors.white, // Latar belakang putih
            colorScheme: ColorScheme.light(
              primary: Colors.blue, // Warna elemen yang dipilih (biru)
              onSurface: Colors.black, // Warna teks
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.blue, // Warna tombol navigasi
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text =
        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Slightly rounded corners
      ),
      backgroundColor: Colors.white, // White background
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Nama Transaksi',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: dateController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Tanggal',
                  labelStyle: TextStyle(color: Colors.grey),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () => _selectDate(context),
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: amountController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Masukkan Jumlah',
                  labelStyle: TextStyle(color: Colors.grey),
                  prefixText: 'Rp. ',
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedSort,
                  isExpanded: true,
                  icon: Icon(Icons.arrow_drop_down, color: Colors.grey),
                  dropdownColor: Colors.grey[100], // warna latar menu dropdown
                  borderRadius: BorderRadius.circular(10), // border radius menu
                  items: <String>['Makanan', 'Transport', 'Belanja', 'Lainnya']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSort = newValue!;
                    });
                  },
                  hint: Text(
                    'Jenis Pengeluaran',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (nameController.text.isEmpty) {
                        Get.snackbar("Failed", "Nama Transaksi tidak boleh kosong",
                            backgroundColor: Colors.red, colorText: Colors.white);
                      } else if (dateController.text.isEmpty) {
                        Get.snackbar("Failed", "Tanggal tidak boleh kosong",
                            backgroundColor: Colors.red, colorText: Colors.white);
                      } else if (amountController.text.isEmpty) {
                        Get.snackbar("Failed", "Pengeluaran tidak boleh kosong",
                            backgroundColor: Colors.red, colorText: Colors.white);
                      } else if (selectedSort == null || selectedSort!.isEmpty) {
                        Get.snackbar("Failed", "Jenis pengeluaran tidak boleh kosong",
                            backgroundColor: Colors.red, colorText: Colors.white);
                      } else {
                        final updatedTransaction = {
                          'name': nameController.text,
                          'date': dateController.text,
                          'amount': double.parse(amountController.text),
                          'sort': selectedSort!,
                          'type': Get.find<PengeluaranController>()
                              .recentTransactions[widget.transactionIndex]['type'], // Ambil type lama
                        };

                        // Update the transaction list
                        Get.find<PengeluaranController>()
                            .recentTransactions[widget.transactionIndex] =
                            updatedTransaction;
                        Get.find<PengeluaranController>().editData(widget.transactionIndex, double.parse(amountController.text));

                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Simpan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Batalkan',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class DeleteTransactionDialog extends StatelessWidget {
  final int transactionIndex; // Pass the index of the transaction to delete

  DeleteTransactionDialog({required this.transactionIndex});

  @override
  Widget build(BuildContext context) {
    // Get the transaction to be deleted and its amount
    final transaction = Get.find<PengeluaranController>().recentTransactions[transactionIndex];
    final double amountToRemove = transaction['amount'];

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8), // Slightly rounded corners
      ),
      backgroundColor: Colors.white, // White background for the dialog
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Hapus Transaksi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Apakah Anda yakin ingin menghapus transaksi ini?',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue, // Blue background
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Batal',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // White text
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {

                      // Remove the transaction from the list in the controller
                      Get.find<PengeluaranController>()
                          .recentTransactions.removeAt(transactionIndex);
                      Get.find<PengeluaranController>().deleteData(transactionIndex);

                      Navigator.pop(context); // Close the dialog
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red, // Red background for delete
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Hapus',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // White text
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String name;
  final String date;
  final String amount;
  final int index;
  final String sort;// The index parameter should be passed to uniquely identify each transaction

  TransactionItem({
    required this.icon,
    required this.color,
    required this.name,
    required this.date,
    required this.amount,
    required this.index,
    required this.sort,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          // Menyusun elemen-elemen ke kiri
          children: [
            ListTile(
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: Colors.grey.shade200,
                child: Icon(
                  icon,
                  color: color, // gunakan warna properti color
                ),
              ),
              title: Text(
                name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    sort, // tampilkan jenis pemasukan
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red, // bisa disesuaikan
                    ),
                  ),
                ],
              ),
              trailing: Text(
                amount,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Mengatur jarak antar tombol
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12), // Sesuaikan padding agar tombol lebih tinggi
                        side: BorderSide(color: Colors.blue),  // Menambahkan border biru pada tombol
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),  // Membuat tombol sudut membulat
                        ),
                        backgroundColor: Colors.blue,  // Warna latar belakang tombol (putih)
                      ),
                      child: Text(
                        'Edit',  // Teks pada tombol
                        style: TextStyle(color: Colors.white), // Warna teks biru
                      ),
                      onPressed: () {
                        String cleanedAmount = amount.replaceAll('Rp. ', ''); // Menghapus 'Rp.'
                        double? parsedAmount = double.tryParse(cleanedAmount); // Parsing ke double
                        showDialog(
                          context: context,
                          builder: (context) {
                            return EditTransactionDialog(
                              name: name,
                              date: date,
                              amount: parsedAmount ?? 0.0,
                              transactionIndex: index,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 8),  // Memberikan jarak antara tombol Edit dan Delete
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12), // Sesuaikan padding agar tombol lebih tinggi
                        side: BorderSide(color: Colors.red),  // Menambahkan border biru pada tombol
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),  // Membuat tombol sudut membulat
                        ),
                        backgroundColor: Colors.red,  // Warna latar belakang tombol (putih)
                      ),
                      child: Text(
                        'Delete',  // Teks pada tombol
                        style: TextStyle(color: Colors.white), // Warna teks biru
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return DeleteTransactionDialog(
                              transactionIndex: index,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}