import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tugasteori1/app/modules/pemasukan/controllers/pemasukan_controller.dart';
import 'package:tugasteori1/app/modules/pemasukan/views/pemasukan_view.dart';
import 'package:tugasteori1/app/modules/pengeluaran/controllers/pengeluaran_controller.dart';
import 'package:tugasteori1/app/modules/profile/views/profile_view.dart';
import 'package:tugasteori1/app/modules/statistik/controllers/statistik_controller.dart';
import 'package:tugasteori1/app/routes/app_routes.dart';

import '../../berita/views/berita_view.dart';

class StatistikaView extends StatefulWidget {
  @override
  _StatistikaViewState createState() => _StatistikaViewState();
}

class _StatistikaViewState extends State<StatistikaView> {
  int _selectedIndex = 1; // To track the selected tab, default to Statistik

  // List of views to navigate between
  final List<Widget> _pages = [
    PemasukanMainView(),
    StatistikMainView(),      // Halaman Statistik
    BeritaMainView(),              // Halaman Berita
    ProfileMainView(),         // Halaman Profil
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  Widget _buildIcon(int index, IconData solidIcon, IconData outlineIcon) {
    return Icon(_selectedIndex == index ? solidIcon : outlineIcon);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: _buildIcon(0, Icons.home_rounded, Icons.home_outlined),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(1, Icons.leaderboard_rounded, Icons.leaderboard_outlined),
                label: 'Statistik',
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(2, Icons.article, Icons.article_outlined),
                label: 'Berita',
              ),
              BottomNavigationBarItem(
                icon: _buildIcon(3, Icons.person_rounded, Icons.person_outline),
                label: 'Profil',
              ),
            ],
            selectedItemColor: Colors.blue.shade700,
            unselectedItemColor: Colors.blue,
            showUnselectedLabels: true,
            backgroundColor: Colors.white,
            type: BottomNavigationBarType.fixed,
            elevation: 0,
          ),
        ),
      ),
      // -----------------------------------------------------------------------------
    );
  }
}

class StatistikMainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Lazy load controllers
    Get.lazyPut<PemasukanController>(() => PemasukanController(),);
    Get.lazyPut<PengeluaranController>(() => PengeluaranController());
    Get.lazyPut<StatistikaController>(() => StatistikaController());

    final PemasukanController masukcontroller = Get.find();
    final PengeluaranController keluarcontroller = Get.find();
    final StatistikaController controller = Get.find();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
        elevation: 0,
        title: Text(
          "Statistik",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.pemasukan);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          // Combine chart data from both controllers
          List<FlSpot> combinedChartData = [];
          combinedChartData.addAll(masukcontroller.chartData);
          combinedChartData.addAll(keluarcontroller.chartData);

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Statistics Chart Section
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Statistik Transaksi Lu",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        height: 100, // Define height for the chart area
                        child: Obx(() {
                          // Cek jika data chart kosong untuk pemasukan atau pengeluaran
                          if (masukcontroller.chartData.isEmpty && keluarcontroller.chartData.isEmpty) {
                            return Center(
                              child: Text(
                                'Belum ada data statistik',
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
                                // Pemasukan chart data
                                LineChartBarData(
                                  spots: masukcontroller.chartData,
                                  isCurved: true,
                                  color: Colors.greenAccent, // Line color for pemasukan
                                  barWidth: 2,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(
                                    show: true, // Show dots
                                    getDotPainter: (spot, _, __, ___) {
                                      // Add a dot at the peak points (highest spots) for pemasukan
                                      if (spot.y == masukcontroller.chartData.map((e) => e.y).reduce((a, b) => a > b ? a : b)) {
                                        return FlDotCirclePainter(
                                          radius: 6,
                                          color: Colors.greenAccent,
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
                                        Colors.greenAccent.withOpacity(0.2),
                                        Colors.greenAccent.withOpacity(0.0),
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                  ),
                                ),
                                // Pengeluaran chart data
                                LineChartBarData(
                                  spots: keluarcontroller.chartData,
                                  isCurved: true,
                                  color: Colors.redAccent, // Line color for pengeluaran
                                  barWidth: 2,
                                  isStrokeCapRound: true,
                                  dotData: FlDotData(
                                    show: true, // Show dots
                                    getDotPainter: (spot, _, __, ___) {
                                      // Add a dot at the peak points (highest spots) for pengeluaran
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
                SizedBox(height: 10),

                // Top Transactions Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Transaksi terbanyak lu",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: 30.0,
                      decoration: BoxDecoration(
                        color: Colors.blue, // Set the background color of the button
                        borderRadius: BorderRadius.circular(1000),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 1.0),
                        child: DropdownButton<String>(
                          value: controller.selectedSort.value,
                          items: [
                            "Pemasukan",
                            "Terbesar",
                            "Terkecil",
                            "Tanggal",
                          ]
                              .map((value) => DropdownMenuItem(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                color: Colors.white, // Text color for the button
                              ),
                            ),
                          ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.updateSort(value);
                            }
                          },
                          dropdownColor: Colors.blue, // Dropdown menu color
                          style: TextStyle(color: Colors.black), // Text color for the button
                          borderRadius: BorderRadius.circular(8),
                          underline: SizedBox(), // Remove the default underline
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1.0),
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
                          if (masukcontroller.recentTransactions.isEmpty && keluarcontroller.recentTransactions.isEmpty) {
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
                            List transactions = [];
                            transactions.addAll(masukcontroller.recentTransactions);
                            transactions.addAll(keluarcontroller.recentTransactions);

                            // Sort the transactions based on selectedSort value
                            if (controller.selectedSort.value == "Terbesar") {
                              transactions.sort((a, b) => b['amount'].compareTo(a['amount'])); // Sort descending
                            } else if (controller.selectedSort.value == "Terkecil") {
                              transactions.sort((a, b) => a['amount'].compareTo(b['amount'])); // Sort ascending
                            } else if (controller.selectedSort.value == "Tanggal") {
                              transactions.sort((a, b) {
                                // Parsing tanggal langsung di dalam sort
                                DateTime parseCustomDate(String date) {
                                  final parts = date.split('/');
                                  if (parts.length == 3) {
                                    final day = int.parse(parts[0]);
                                    final month = int.parse(parts[1]);
                                    final year = int.parse(parts[2]);
                                    return DateTime(year, month, day);
                                  }
                                  throw FormatException("Invalid date format: $date");
                                }

                                DateTime dateA = parseCustomDate(a['date']);
                                DateTime dateB = parseCustomDate(b['date']);
                                return dateB.compareTo(dateA); // Sort descending by date
                              });
                            }

                            return Column(
                              children: transactions.asMap().entries.map((entry) {
                                int index = entry.key;
                                var transaction = entry.value;

                                IconData icon = Icons.help_outline;  // Default icon
                                Color color = Colors.grey;  // Default color

                                if (transaction['type'] == 'masuk') {
                                  icon = Icons.attach_money;  // Ikon dolar
                                  color = Colors.green;  // Warna hijau untuk pemasukan
                                } else if (transaction['type'] == 'keluar') {
                                  icon = Icons.shopping_cart;  // Ikon shopping cart
                                  color = Colors.red;  // Warna merah untuk pengeluaran
                                } else if (transaction['type'] == null) {
                                  icon = Icons.attach_money;  // Ikon update jika tipe transaksi null
                                  color = Colors.blue;  // Warna biru untuk ikon update
                                }

                                return TransactionItem(
                                  icon: icon,
                                  color: color,
                                  name: transaction['name'],
                                  date: transaction['date'],
                                  amount: 'Rp. ${transaction['amount']}',
                                  index: index,
                                  sort: transaction['sort'],
                                  type : transaction['type']
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
          );
        }),
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
  final int index; // The index parameter should be passed to uniquely identify each transaction
  final String sort;
  final String type;

  const TransactionItem({
    required this.icon,
    required this.color,
    required this.name,
    required this.date,
    required this.amount,
    required this.index,
    required this.sort,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    Color sortColor;
    if (type == 'masuk') {
      sortColor = Colors.green;
    } else if (type == 'keluar') {
      sortColor = Colors.red;
    } else {
      sortColor = Colors.blue; // default jika null atau tipe tidak dikenali
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  color: sortColor, // gunakan warna berdasarkan type
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
      ),
    );
  }
}