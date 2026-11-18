import 'package:flutter/material.dart';
import '../models/netlayan_models.dart';
import '../providers/netlayan_store.dart';

class TpiDashboard extends StatefulWidget {
  final NetlayanStore store;
  final VoidCallback onLogout;

  const TpiDashboard({
    super.key,
    required this.store,
    required this.onLogout,
  });

  @override
  State<TpiDashboard> createState() => _TpiDashboardState();
}

class _TpiDashboardState extends State<TpiDashboard> {
  void _showVerifyGradeDialog(FishItem fish) {
    String selectedGrade = fish.qualityGrade;
    final vesselCtrl = TextEditingController(text: fish.vesselName);
    final zoneCtrl = TextEditingController(text: fish.fishingZone);

    final grades = [
      'Grade A - Tangkapan Baru (Premium)',
      'Grade B - Ikan Segar Standar',
      'Grade C - Ikan Beku',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Verifikasi Mutu & Stempel TPI',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF006064)),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 10),

                    Text('Produk: ${fish.title}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text('Nelayan: ${fish.fishermanName} • Pelabuhan: ${fish.portLocation}', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: selectedGrade,
                      decoration: const InputDecoration(
                        labelText: 'Label Mutu / Grade Verifikasi',
                        prefixIcon: Icon(Icons.verified, color: Color(0xFF006064)),
                        border: OutlineInputBorder(),
                      ),
                      items: grades.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() {
                            selectedGrade = val;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: vesselCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nama Kapal Penangkap',
                        prefixIcon: Icon(Icons.sailing, color: Color(0xFF006064)),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: zoneCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Zona Laut Penangkapan',
                        prefixIcon: Icon(Icons.map, color: Color(0xFF006064)),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF006064),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          widget.store.verifyFishGrade(
                            fish.id,
                            selectedGrade,
                            vesselCtrl.text.trim(),
                            zoneCtrl.text.trim(),
                          );
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Berhasil memberikan stempel ${selectedGrade} & Sertifikat Asal Tangkap!'),
                              backgroundColor: const Color(0xFF006064),
                            ),
                          );
                        },
                        child: const Text('Terbitkan Stempel Mutu & Catch Certificate', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.store.currentUser;
    final fishList = widget.store.fishList;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Syahbandar & Verifikator TPI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(user?.name ?? 'Petugas Verifikasi', style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        backgroundColor: const Color(0xFF006064),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: widget.onLogout,
            tooltip: 'Ganti Peran / Keluar',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: const Color(0xFFE0F7FA),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.verified_user, color: Color(0xFF00838F), size: 30),
                      SizedBox(width: 10),
                      Text(
                        'Pusat Verifikasi Mutu & Surat Jalan TPI',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF006064)),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Petugas TPI memberikan stempel grade mutu (Grade A/B/C) dan menerbitkan Catch Certificate (Surat Jalan & Asal Tangkap) sebelum ikan dipajang bagi pembeli dan swalayan.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF004D40)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text('Daftar Tangkapan Ikan Menunggu Verifikasi TPI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF006064))),
          const SizedBox(height: 10),

          ...fishList.map((fish) {
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(fish.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: fish.qualityGrade.contains('Grade A') ? Colors.green.shade50 : Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: fish.qualityGrade.contains('Grade A') ? Colors.green : Colors.blue),
                          ),
                          child: Text(
                            fish.qualityGrade,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: fish.qualityGrade.contains('Grade A') ? Colors.green.shade800 : Colors.blue.shade800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('Nelayan: ${fish.fishermanName} (${fish.fishermanCity})', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                    Text('Pelabuhan: ${fish.portLocation}', style: const TextStyle(fontSize: 13, color: Colors.black87)),
                    const SizedBox(height: 10),

                    // Catch Certificate Details Card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('📜 Surat Jalan & Catch Certificate (Traceability):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF006064))),
                          const SizedBox(height: 4),
                          Text('• Nama Kapal: ${fish.vesselName}', style: const TextStyle(fontSize: 12)),
                          Text('• Zona Penangkapan: ${fish.fishingZone}', style: const TextStyle(fontSize: 12)),
                          Text('• Tanggal Bongkar Muat: ${fish.unloadingDate.day}/${fish.unloadingDate.month}/${fish.unloadingDate.year}', style: const TextStyle(fontSize: 12)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF006064),
                          foregroundColor: Colors.white,
                        ),
                        icon: const Icon(Icons.verified, size: 16),
                        label: const Text('Ubah Stempel Mutu / Verifikasi TPI'),
                        onPressed: () => _showVerifyGradeDialog(fish),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
