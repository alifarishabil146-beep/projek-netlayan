import 'package:flutter/material.dart';

class WeatherNavigationScreen extends StatefulWidget {
  const WeatherNavigationScreen({super.key});

  @override
  State<WeatherNavigationScreen> createState() => _WeatherNavigationScreenState();
}

class _WeatherNavigationScreenState extends State<WeatherNavigationScreen> {
  String _selectedZone = 'Perairan Muara Padang - Mentawai';
  double _compassAngle = 45.0; // In degrees

  final List<Map<String, dynamic>> _fishingSpots = [
    {
      'name': 'Spot 1: Gosong Gadang (Tuna & Kakap)',
      'distance': '12.4 Mil Laut',
      'latLng': '0° 58\' S, 100° 18\' E',
      'status': 'Melimpah (Ikan Segar)',
      'wave': '1.0 m',
    },
    {
      'name': 'Spot 2: Perairan Mentawai Timur (Tongkol)',
      'distance': '28.6 Mil Laut',
      'latLng': '1° 12\' S, 99° 52\' E',
      'status': 'Sangat Bagus',
      'wave': '1.3 m',
    },
    {
      'name': 'Spot 3: Karang Bungus (Cumi & Udang)',
      'distance': '8.2 Mil Laut',
      'latLng': '1° 02\' S, 100° 22\' E',
      'status': 'Sedang',
      'wave': '0.8 m',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navigasi Cuaca Laut Interaktif'),
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown Selected Zone
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: const Color(0xFFFCE4EC),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Color(0xFFE91E63)),
                    const SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedZone,
                          isExpanded: true,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF880E4F),
                          ),
                          items: const [
                            DropdownMenuItem(
                              value: 'Perairan Muara Padang - Mentawai',
                              child: Text('Perairan Muara Padang - Mentawai'),
                            ),
                            DropdownMenuItem(
                              value: 'Perairan Bungus & Teluk Bayur',
                              child: Text('Perairan Bungus & Teluk Bayur'),
                            ),
                            DropdownMenuItem(
                              value: 'Perairan Pesisir Selatan Painan',
                              child: Text('Perairan Pesisir Selatan Painan'),
                            ),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedZone = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Marine Safety Banner Status
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFE91E63), Color(0xFF880E4F)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 3),
                  )
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Colors.white24,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.verified, color: Colors.white, size: 32),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'STATUS KEAMANAN LAUT',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'AMAN UNTUK MELAUT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Tinggi gelombang < 1.5 meter, angin tenang.',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Live Weather Grid Details
            Row(
              children: [
                _buildWeatherTile(
                  icon: Icons.water_drop,
                  title: 'Tinggi Gelombang',
                  value: '1.2 Meter',
                  subtitle: 'Kategori Rendah',
                  color: const Color(0xFFD81B60),
                ),
                const SizedBox(width: 12),
                _buildWeatherTile(
                  icon: Icons.air,
                  title: 'Kecepatan Angin',
                  value: '14 Knot',
                  subtitle: 'Arah Barat Daya',
                  color: const Color(0xFFC2185B),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildWeatherTile(
                  icon: Icons.thermostat,
                  title: 'Suhu Laut',
                  value: '29 °C',
                  subtitle: 'Kelembaban 78%',
                  color: const Color(0xFFAD1457),
                ),
                const SizedBox(width: 12),
                _buildWeatherTile(
                  icon: Icons.visibility,
                  title: 'Jarak Pandang',
                  value: '8.5 Km',
                  subtitle: 'Jelas Tanpa Kabut',
                  color: const Color(0xFF880E4F),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Interactive Compass & Navigation Map
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Kompas & Directional Radar',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF880E4F)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.rotate_right, color: Color(0xFFE91E63)),
                          onPressed: () {
                            setState(() {
                              _compassAngle = (_compassAngle + 45) % 360;
                            });
                          },
                          tooltip: 'Putar Kompas Radar',
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Visual Radar Map Box
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A001F),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Radar Grid Lines
                          Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFFF80AB).withValues(alpha: 0.3), width: 1.5),
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xFFFF80AB).withValues(alpha: 0.4), width: 1.5),
                            ),
                          ),

                          // Compass Needle
                          Transform.rotate(
                            angle: _compassAngle * (3.14159 / 180),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.navigation, size: 48, color: Color(0xFFFF80AB)),
                                const SizedBox(height: 4),
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Fishing Spot Radar Ping Points
                          Positioned(
                            top: 30,
                            right: 40,
                            child: _buildRadarPing('Spot 1'),
                          ),
                          Positioned(
                            bottom: 40,
                            left: 50,
                            child: _buildRadarPing('Spot 2'),
                          ),

                          const Positioned(
                            bottom: 10,
                            right: 12,
                            child: Text(
                              'GPS Active • 0°58\'S 100°18\'E',
                              style: TextStyle(color: Color(0xFFFF80AB), fontSize: 10, fontFamily: 'monospace'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Fishing Spots Recommendation List
            const Text(
              'Rekomendasi Titik Tangkapan Ikan',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF880E4F)),
            ),
            const SizedBox(height: 12),
            ..._fishingSpots.map((spot) {
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFCE4EC),
                    child: Icon(Icons.phishing, color: Color(0xFFE91E63)),
                  ),
                  title: Text(
                    spot['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: Text('Jarak: ${spot['distance']} • Gelombang: ${spot['wave']}'),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCE4EC),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      spot['status'],
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF880E4F),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),

            // 3-Day Forecast
            const Text(
              'Prakiraan Cuaca Laut (3 Hari Kedepan)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF880E4F)),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildForecastCard('Hari Ini', 'Cerah Berawan', '1.2m', Icons.wb_sunny, const Color(0xFFE91E63)),
                const SizedBox(width: 8),
                _buildForecastCard('Besok', 'Hujan Ringan', '1.5m', Icons.water, const Color(0xFFC2185B)),
                const SizedBox(width: 8),
                _buildForecastCard('Lusa', 'Cerah', '0.9m', Icons.wb_sunny_outlined, const Color(0xFFAD1457)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherTile({
    required IconData icon,
    required String title,
    required String value,
    required String subtitle,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
            Text(
              subtitle,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadarPing(String label) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: const Color(0xFFFF80AB),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF80AB).withValues(alpha: 0.8),
                blurRadius: 8,
                spreadRadius: 2,
              )
            ],
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Color(0xFFFF80AB), fontSize: 10, fontWeight: FontWeight.bold),
        )
      ],
    );
  }

  Widget _buildForecastCard(String day, String condition, String wave, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.pink.shade100),
        ),
        child: Column(
          children: [
            Text(day, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF880E4F))),
            const SizedBox(height: 6),
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(condition, textAlign: TextAlign.center, style: const TextStyle(fontSize: 11)),
            const SizedBox(height: 4),
            Text('Gel: $wave', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFE91E63))),
          ],
        ),
      ),
    );
  }
}
