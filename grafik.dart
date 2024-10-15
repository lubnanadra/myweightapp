import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:myweightapps/tema.dart';
import 'package:myweightapps/models/sensormodel.dart';

class GrafikScreen extends StatelessWidget {
  const GrafikScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Grafik Perkembangan Berat Badan',
          style: semibold14.copyWith(color: putih),
        ),
        backgroundColor: birutua,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: StreamBuilder<DatabaseEvent>(
              stream: FirebaseDatabase.instance
                  .ref('sensordata')
                  .orderByKey()
                  .onValue,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                // Ambil data dari Firebase
                final dataMap = snapshot.data?.snapshot.value;

                if (dataMap is! Map<dynamic, dynamic>) {
                  return const Center(child: Text('Data tidak valid.'));
                }

                // Parsing data dan pastikan waktu unik
                final uniqueSensorData = <String, Map<String, dynamic>>{};

                dataMap.entries.forEach((entry) {
                  final timeKey = entry.key as String;
                  final beratBadanValue = entry.value.toString();

                  // Memastikan bahwa hanya menyimpan waktu yang unik
                  if (!uniqueSensorData.containsKey(timeKey)) {
                    try {
                      final sensorModel =
                          SensorModel.fromMap(timeKey, beratBadanValue);
                      uniqueSensorData[timeKey] = {
                        'data': sensorModel,
                        'time': sensorModel.time,
                      };
                    } catch (e) {
                      print('Error parsing sensor data: $e');
                    }
                  }
                });

                // Konversi kembali ke list
                final List<Map<String, dynamic>> sensorDataList =
                    uniqueSensorData.values.toList();

                // Urutkan data berdasarkan waktu
                sensorDataList.sort((a, b) => a['time'].compareTo(b['time']));

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildChart(sensorDataList),
                    const SizedBox(height: 20),
                    _buildDateHistory(sensorDataList),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChart(List<Map<String, dynamic>> data) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: SizedBox(
        height: 300,
        child: data.isEmpty
            ? Center(child: Text('Tidak ada data untuk ditampilkan.'))
            : LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toString(),
                            style: const TextStyle(
                                fontSize: 8), // Ukuran lebih kecil
                          );
                        },
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      // Menambahkan ini untuk mengatur right titles
                      sideTitles: SideTitles(
                          showTitles:
                              false), // Tidak menampilkan label di kanan
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          int index = value.toInt();
                          if (index >= 0 && index < data.length) {
                            return SideTitleWidget(
                              axisSide: meta.axisSide,
                              child: Text(
                                DateFormat('MM/dd').format(data[index]['time']),
                                style: const TextStyle(
                                    fontSize: 8), // Ukuran lebih kecil
                              ),
                            );
                          } else {
                            return const Text('');
                          }
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(color: Colors.black),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: data
                          .asMap()
                          .entries
                          .map((entry) => FlSpot(
                                entry.key.toDouble(),
                                entry.value['data'].beratBadan,
                              ))
                          .toList(),
                      isCurved: true,
                      color: birumuda,
                      barWidth: 4,
                      belowBarData: BarAreaData(
                        show: true,
                        color: birumuda.withOpacity(0.3),
                      ),
                    ),
                  ],
                  minX: 0,
                  maxX: data.length.toDouble() - 1,
                  minY: data.isNotEmpty
                      ? (data
                              .map((e) => e['data'].beratBadan)
                              .reduce((a, b) => a < b ? a : b) -
                          1)
                      : 0,
                  maxY: data.isNotEmpty
                      ? (data
                              .map((e) => e['data'].beratBadan)
                              .reduce((a, b) => a > b ? a : b) +
                          1)
                      : 1,
                ),
              ),
      ),
    );
  }

  Widget _buildDateHistory(List<Map<String, dynamic>> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tanggal Pengukuran Berat Badan',
          style: semibold14.copyWith(color: birutua, fontSize: 18),
        ),
        const SizedBox(height: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: data.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Text(
                DateFormat('dd MMM yyyy').format(entry['time']),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
