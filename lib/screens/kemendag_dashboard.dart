import 'package:flutter/material.dart';
import '../models/netlayan_models.dart';
import '../providers/netlayan_store.dart';

class KemendagDashboard extends StatefulWidget {
  final NetlayanStore store;
  final VoidCallback onLogout;

  const KemendagDashboard({
    super.key,
    required this.store,
    required this.onLogout,
  });

  @override
  State<KemendagDashboard> createState() => _KemendagDashboardState();
}

class _KemendagDashboardState extends State<KemendagDashboard> {
  int _currentIndex = 0;

  void _showEditRegulationDialog(TradePriceRegulation reg) {
    final priceCtrl = TextEditingController(text: reg.maxPricePerKg.toStringAsFixed(0));
    final regNumCtrl = TextEditingController(text: reg.regulationNumber);

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Atur Harga Maksimal: ${reg.category}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tetapkan batas harga jual beli maksimal per kg sesuai kebijakan Kementerian Perdagangan.',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Harga Maksimal / Kg (Rp)',
                  prefixIcon: Icon(Icons.gavel, color: Color(0xFF005B96)),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: regNumCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nomor Peraturan (Permendag)',
                  prefixIcon: Icon(Icons.description, color: Color(0xFF005B96)),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF005B96),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final newPrice = double.tryParse(priceCtrl.text) ?? reg.maxPricePerKg;
                widget.store.updateRegulation(reg.category, newPrice, regNumCtrl.text.trim());
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Berhasil memperbarui ketentuan HET ${reg.category} menjadi Rp ${newPrice.toStringAsFixed(0)}'),
                    backgroundColor: const Color(0xFF005B96),
                  ),
                );
              },
              child: const Text('Simpan Ketentuan'),
            ),
          ],
        );
      },
    );
  }

  void _showAddExportDialog() {
    final catCtrl = TextEditingController(text: 'Ikan Karang (Kakap Merah)');
    final volCtrl = TextEditingController(text: '20.0');
    final countryCtrl = TextEditingController(text: 'Malaysia (Kuala Lumpur)');
    final valCtrl = TextEditingController(text: '180000');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
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
                      'Tambah Laporan Ekspor Ikan',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF005B96)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 10),

                TextField(
                  controller: catCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Kategori / Jenis Ikan Ekspor',
                    prefixIcon: Icon(Icons.set_meal, color: Color(0xFF005B96)),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: volCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Volume (Ton)',
                          prefixIcon: Icon(Icons.scale, color: Color(0xFF005B96)),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: valCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Nilai (USD \$)',
                          prefixIcon: Icon(Icons.attach_money, color: Color(0xFF005B96)),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: countryCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Negara Tujuan Ekspor',
                    prefixIcon: Icon(Icons.public, color: Color(0xFF005B96)),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005B96),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      if (catCtrl.text.trim().isEmpty) return;

                      final report = ExportReportModel(
                        id: 'exp_${DateTime.now().millisecondsSinceEpoch}',
                        fishCategory: catCtrl.text.trim(),
                        volumeTon: double.tryParse(volCtrl.text) ?? 10.0,
                        destinationCountry: countryCtrl.text.trim(),
                        estimatedValueUsd: double.tryParse(valCtrl.text) ?? 100000,
                        date: DateTime.now(),
                        status: 'Dalam Pengapalan',
                      );

                      widget.store.addExportReport(report);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Laporan ekspor baru berhasil ditambahkan!'),
                          backgroundColor: Color(0xFF005B96),
                        ),
                      );
                    },
                    child: const Text('Simpan Laporan Ekspor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.store.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Kementerian Perdagangan RI', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(user?.name ?? 'Pengawas Harga Pangan', style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        backgroundColor: const Color(0xFF005B96),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: widget.onLogout,
            tooltip: 'Ganti Peran / Keluar',
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: widget.store,
        builder: (context, _) {
          if (_currentIndex == 0) {
            return _buildRegulationsTab();
          } else if (_currentIndex == 1) {
            return _buildMonitoringTab();
          } else if (_currentIndex == 2) {
            return _buildDistributionTab();
          } else {
            return _buildExportReportsTab();
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF005B96),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.gavel),
            label: 'HET',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.rule),
            label: 'Kepatuhan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Distribusi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'Ekspor',
          ),
        ],
      ),
    );
  }

  Widget _buildRegulationsTab() {
    final regulations = widget.store.tradeRegulations;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F7FA),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFB2EBF2)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.account_balance, color: Color(0xFF005B96)),
                  SizedBox(width: 8),
                  Text(
                    'Direktorat Jenderal Perdagangan Dalam Negeri',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF005B96), fontSize: 15),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Kementerian Perdagangan menetapkan standar Harga Eceran Tertinggi (HET) dan Harga Acuan Penjualan Ikan nasional. Nelayan dilarang memberikan harga jual di atas ketentuan ini untuk melindungi daya beli masyarakat dan stabilitas pasar.',
                style: TextStyle(fontSize: 13, color: Color(0xFF6A1B9A)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Daftar Ketentuan Harga Maksimal Per Kategori Ikan:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF005B96)),
        ),
        const SizedBox(height: 10),
        ...regulations.map((reg) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.set_meal, color: Color(0xFF005B96)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          reg.category,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Batas Maksimal: Rp ${reg.maxPricePerKg.toStringAsFixed(0)} / Kg',
                          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF005B96)),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Dasar Hukum: ${reg.regulationNumber}',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_note, color: Color(0xFF005B96), size: 28),
                    onPressed: () => _showEditRegulationDialog(reg),
                    tooltip: 'Ubah Ketentuan',
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildMonitoringTab() {
    final fishList = widget.store.fishList;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Monitoring Harga Pasar & Kepatuhan Nelayan',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF005B96)),
        ),
        const SizedBox(height: 4),
        const Text(
          'Pemeriksaan otomatis kesesuaian harga ikan tangkapan terhadap Harga Maksimal Kementerian Perdagangan.',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
        const SizedBox(height: 16),
        ...fishList.map((fish) {
          final maxAllowed = widget.store.getMaxPriceForCategory(fish.category);
          final isExceeding = fish.pricePerKg > maxAllowed;

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          fish.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isExceeding ? Colors.red.shade50 : Colors.green.shade50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isExceeding ? Colors.red.shade300 : Colors.green.shade300,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isExceeding ? Icons.warning_amber : Icons.check_circle,
                              size: 14,
                              color: isExceeding ? Colors.red : Colors.green,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isExceeding ? 'MELANGGAR HET' : 'SESUAI KETENTUAN',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: isExceeding ? Colors.red.shade800 : Colors.green.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Nelayan: ${fish.fishermanName} (${fish.fishermanCity})', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Harga Jual: Rp ${fish.pricePerKg.toStringAsFixed(0)} / Kg',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isExceeding ? Colors.red : const Color(0xFF005B96),
                        ),
                      ),
                      Text(
                        'Batas Kemendag: Rp ${maxAllowed.toStringAsFixed(0)} / Kg',
                        style: TextStyle(fontSize: 13, color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDistributionTab() {
    final stockSummary = widget.store.portStockSummary;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F7FA),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFB2EBF2)),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.local_shipping, color: Color(0xFF006064)),
                  SizedBox(width: 8),
                  Text(
                    'Pemantauan Over-Supply & Distribusi Antar-Daerah',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF006064), fontSize: 15),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Dashboard Kemendag memantau pasokan tangkapan per pelabuhan. Jika terdeteksi surplus (over-supply), sistem secara otomatis merekomendasikan rute distribusi ke wilayah defisit untuk menjaga stabilitas harga nasional.',
                style: TextStyle(fontSize: 13, color: Color(0xFF004D40)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Stok Pasokan Hasil Tangkapan Per Pelabuhan:',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF005B96)),
        ),
        const SizedBox(height: 10),

        ...stockSummary.entries.map((entry) {
          final portName = entry.key;
          final totalKg = entry.value;
          final isOverSupply = totalKg > 100; // threshold

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(portName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isOverSupply ? Colors.orange.shade50 : Colors.green.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: isOverSupply ? Colors.orange : Colors.green),
                        ),
                        child: Text(
                          isOverSupply ? 'SURPLUS (OVER-SUPPLY)' : 'STOK NORMAL',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isOverSupply ? Colors.orange.shade800 : Colors.green.shade800,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Total Pasokan Tersedia: ${totalKg.toStringAsFixed(1)} Kg', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const SizedBox(height: 6),
                  if (isOverSupply) ...[
                    const Divider(),
                    const Text('Rekomendasi Rute Distribusi Antar-Daerah:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF005B96))),
                    const SizedBox(height: 4),
                    const Text('➔ Alihkan 40% pasokan ke Kota Bukittinggi & Payakumbuh\n➔ Alihkan 30% pasokan ke Pekanbaru (Stabilisasi Harga Regional)', style: TextStyle(fontSize: 12, color: Colors.black87)),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005B96),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 36),
                      ),
                      icon: const Icon(Icons.send, size: 16),
                      label: const Text('Keluarkan Instruksi Truk Logistik Distribusi'),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Instruksi distribusi dari $portName ke wilayah defisit berhasil dikirim ke asosiasi logistik!'),
                            backgroundColor: const Color(0xFF005B96),
                          ),
                        );
                      },
                    ),
                  ]
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildExportReportsTab() {
    final reports = widget.store.exportReports;
    double totalTon = 0;
    double totalUsd = 0;
    for (var r in reports) {
      totalTon += r.volumeTon;
      totalUsd += r.estimatedValueUsd;
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Export Summary Card
        Card(
          color: const Color(0xFFE0F7FA),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Laporan Devisa & Volume Ekspor Perikanan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF005B96))),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('${totalTon.toStringAsFixed(1)} Ton', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF005B96))),
                        const Text('Total Volume Ekspor', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('\$${totalUsd.toStringAsFixed(0)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                        const Text('Estimasi Devisa (USD)', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Daftar Pengiriman Ekspor', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF005B96))),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF005B96),
                foregroundColor: Colors.white,
              ),
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Tambah Ekspor'),
              onPressed: _showAddExportDialog,
            ),
          ],
        ),
        const SizedBox(height: 10),

        ...reports.map((rep) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(rep.fishCategory, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.green.shade300),
                        ),
                        child: Text(
                          rep.status,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('Tujuan: ${rep.destinationCountry}', style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Volume: ${rep.volumeTon} Ton', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Text('Nilai: \$${rep.estimatedValueUsd.toStringAsFixed(0)} USD', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
