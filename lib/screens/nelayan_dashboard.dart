import 'package:flutter/material.dart';
import '../models/netlayan_models.dart';
import '../providers/netlayan_store.dart';
import 'weather_navigation_screen.dart';

class NelayanDashboard extends StatefulWidget {
  final NetlayanStore store;
  final VoidCallback onLogout;

  const NelayanDashboard({
    super.key,
    required this.store,
    required this.onLogout,
  });

  @override
  State<NelayanDashboard> createState() => _NelayanDashboardState();
}

class _NelayanDashboardState extends State<NelayanDashboard> {
  int _currentIndex = 0;

  void _showAddFishDialog() {
    final titleCtrl = TextEditingController();
    String selectedCategory = 'Ikan Laut';
    final priceCtrl = TextEditingController(text: '40000');
    final stockCtrl = TextEditingController(text: '50');
    final portCtrl = TextEditingController(text: widget.store.currentUser?.portLocation ?? 'Pelabuhan Muara Padang');
    final descCtrl = TextEditingController(text: 'Hasil tangkapan baru hari ini, dijamin masih sangat segar.');
    String selectedSampleImg = 'https://images.unsplash.com/photo-1534483509719-3feaee7c30da?w=600&auto=format&fit=crop&q=80';

    final categories = ['Ikan Laut', 'Ikan Karang', 'Udang & Cumi', 'Ikan Besar'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final maxAllowed = widget.store.getMaxPriceForCategory(selectedCategory);

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
                          'Unggah Hasil Tangkapan Baru',
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
                      controller: titleCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nama / Jenis Ikan',
                        hintText: 'Contoh: Ikan Kakap Merah / Tongkol',
                        prefixIcon: Icon(Icons.set_meal, color: Color(0xFF005B96)),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Category Dropdown
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Kategori Ikan',
                        prefixIcon: Icon(Icons.category, color: Color(0xFF005B96)),
                        border: OutlineInputBorder(),
                      ),
                      items: categories.map((cat) {
                        return DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() {
                            selectedCategory = val;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Batas Maksimal Harga Kemendag ($selectedCategory): Rp ${maxAllowed.toStringAsFixed(0)} / Kg',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                    ),
                    const SizedBox(height: 12),

                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: priceCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Harga / Kg (Rp)',
                              prefixIcon: Icon(Icons.payments, color: Color(0xFF005B96)),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: stockCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Stok Berat (Kg)',
                              prefixIcon: Icon(Icons.scale, color: Color(0xFF005B96)),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: portCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Pelabuhan / Dermaga Tangkapan',
                        prefixIcon: Icon(Icons.anchor, color: Color(0xFF005B96)),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: descCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Deskripsi Ikan & Kualitas Tangkapan',
                        prefixIcon: Icon(Icons.description, color: Color(0xFF005B96)),
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
                          if (titleCtrl.text.trim().isEmpty) return;

                          final price = double.tryParse(priceCtrl.text) ?? 0;

                          // Check Ministry of Trade price rule
                          if (price > maxAllowed) {
                            showDialog(
                              context: ctx,
                              builder: (warningCtx) {
                                return AlertDialog(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                  title: Row(
                                    children: const [
                                      Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
                                      SizedBox(width: 8),
                                      Text('Peringatan Kemendag', style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  content: Text(
                                    'Harga yang Anda masukkan (Rp ${price.toStringAsFixed(0)}) melebihi Batas Harga Maksimal Kementerian Perdagangan untuk kategori "$selectedCategory" (Maksimal Rp ${maxAllowed.toStringAsFixed(0)} / Kg).\n\nNelayan dilarang menetapkan harga jual di atas ketentuan Kementerian Perdagangan. Silakan sesuaikan harga Anda.',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                                      onPressed: () => Navigator.pop(warningCtx),
                                      child: const Text('Mengerti & Sesuaikan Harga'),
                                    ),
                                  ],
                                );
                              },
                            );
                            return; // Block saving
                          }

                          final newFish = FishItem(
                            id: 'fish_${DateTime.now().millisecondsSinceEpoch}',
                            fishermanId: widget.store.currentUser?.id ?? 'nelayan_01',
                            fishermanName: widget.store.currentUser?.name ?? 'Pak Syamsul',
                            fishermanCity: widget.store.currentUser?.city ?? 'Kota Padang',
                            title: titleCtrl.text.trim(),
                            category: selectedCategory,
                            pricePerKg: price,
                            stockKg: double.tryParse(stockCtrl.text) ?? 10,
                            imageUrl: selectedSampleImg,
                            catchDate: DateTime.now(),
                            portLocation: portCtrl.text.trim(),
                            description: descCtrl.text.trim(),
                            isFresh: true,
                          );

                          widget.store.addFish(newFish);
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Berhasil mengunggah ${newFish.title} sesuai HET Kemendag!'),
                              backgroundColor: const Color(0xFF005B96),
                            ),
                          );
                        },
                        child: const Text('Simpan & Terbitkan Hasil Tangkapan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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

  void _showAddFinancialRecordDialog() {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    FinancialType selectedType = FinancialType.pengeluaran;
    String selectedCategory = 'BBM Solar';
    final categories = ['BBM Solar', 'Es Batu', 'Perbaikan Alat', 'Umpan Pancing', 'Penjualan Langsung', 'Lain-lain'];

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
                          'Catat Keuangan & Kas',
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

                    Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('Pengeluaran Modal'),
                            selected: selectedType == FinancialType.pengeluaran,
                            selectedColor: Colors.red.shade100,
                            onSelected: (val) {
                              setModalState(() {
                                selectedType = FinancialType.pengeluaran;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('Pemasukan Tunai'),
                            selected: selectedType == FinancialType.pemasukan,
                            selectedColor: Colors.green.shade100,
                            onSelected: (val) {
                              setModalState(() {
                                selectedType = FinancialType.pemasukan;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Keterangan / Judul Catatan',
                        hintText: 'Contoh: Beli solar 20 liter / Es batu',
                        prefixIcon: Icon(Icons.receipt_long, color: Color(0xFF005B96)),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    TextField(
                      controller: amountCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Nominal (Rp)',
                        prefixIcon: Icon(Icons.payments, color: Color(0xFF005B96)),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Kategori Keuangan',
                        prefixIcon: Icon(Icons.category, color: Color(0xFF005B96)),
                        border: OutlineInputBorder(),
                      ),
                      items: categories.map((cat) {
                        return DropdownMenuItem(value: cat, child: Text(cat));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setModalState(() {
                            selectedCategory = val;
                          });
                        }
                      },
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
                          if (titleCtrl.text.trim().isEmpty || amountCtrl.text.trim().isEmpty) return;
                          final amount = double.tryParse(amountCtrl.text) ?? 0;

                          final record = FinancialRecord(
                            id: 'fin_${DateTime.now().millisecondsSinceEpoch}',
                            title: titleCtrl.text.trim(),
                            amount: amount,
                            type: selectedType,
                            date: DateTime.now(),
                            category: selectedCategory,
                          );

                          widget.store.addFinancialRecord(record);
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Catatan keuangan berhasil disimpan!'),
                              backgroundColor: Color(0xFF005B96),
                            ),
                          );
                        },
                        child: const Text('Simpan Catatan Keuangan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user?.name ?? 'Dashboard Nelayan', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Pelabuhan: ${user?.portLocation ?? "Padang"}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
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
            return _buildFishListTab();
          } else if (_currentIndex == 1) {
            return _buildFinancialBookkeepingTab();
          } else if (_currentIndex == 2) {
            return _buildReviewsTab();
          } else if (_currentIndex == 3) {
            return const WeatherNavigationScreen();
          } else {
            return _buildOrdersTab();
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
            icon: Icon(Icons.phishing),
            label: 'Tangkapan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Pembukuan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Ulasan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Cuaca',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Pesanan',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _showAddFishDialog,
              backgroundColor: const Color(0xFF005B96),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Unggah Tangkapan'),
            )
          : (_currentIndex == 1
              ? FloatingActionButton.extended(
                  onPressed: _showAddFinancialRecordDialog,
                  backgroundColor: const Color(0xFF005B96),
                  foregroundColor: Colors.white,
                  icon: const Icon(Icons.edit_note),
                  label: const Text('Catat Keuangan'),
                )
              : null),
    );
  }

  Widget _buildFishListTab() {
    final myFish = widget.store.fishList;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Status Cuaca Ringkas Pink
          Card(
            color: const Color(0xFFE0F7FA),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const ListTile(
              leading: Icon(Icons.wb_sunny, color: Color(0xFF005B96), size: 32),
              title: Text('Cuaca Perairan Padang: Aman', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF005B96))),
              subtitle: Text('Gelombang 1.2m • Angin 14 knot. Klik Tab Navigasi Cuaca untuk radar interaktif.'),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Katalog Tangkapan Terbitan Saya', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF005B96))),
              Text('${myFish.length} Jenis Ikan', style: const TextStyle(color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 12),

          ...myFish.map((fish) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        fish.imageUrl,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) => Container(
                          width: 90,
                          height: 90,
                          color: Colors.blue.shade50,
                          child: const Icon(Icons.set_meal, size: 40, color: Color(0xFF005B96)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(fish.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          const SizedBox(height: 4),
                          Text('Rp ${fish.pricePerKg.toStringAsFixed(0)} / Kg', style: const TextStyle(color: Color(0xFF005B96), fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 2),
                          Text('Stok: ${fish.stockKg} Kg • ${fish.portLocation}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0F7FA),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('Ditangkap Hari Ini (Segar)', style: TextStyle(fontSize: 11, color: Color(0xFF00A8CC), fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () => widget.store.removeFish(fish.id),
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

  Widget _buildFinancialBookkeepingTab() {
    final store = widget.store;
    final records = store.financialRecords;
    final completedOrders = store.orders.where((o) => o.status == OrderStatus.pesananSelesai).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Info Pembukuan Sederhana
          Card(
            color: const Color(0xFFE0F7FA),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                children: [
                  const Icon(Icons.account_balance_wallet, color: Color(0xFF005B96), size: 36),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Pembukuan & Keuangan Nelayan',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF005B96), fontSize: 15),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Pantau total penjualan harian, mingguan, bulanan, serta pencairan dana transaksi dari pembeli.',
                          style: TextStyle(fontSize: 12, color: Color(0xFF6A1B9A)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Summary Cards Grid
          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Penjualan Hari Ini', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 6),
                        Text('Rp ${store.totalDailyRevenue.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF005B96))),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Penjualan Minggu Ini', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 6),
                        Text('Rp ${store.totalWeeklyRevenue.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF005B96))),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Penjualan Bulan Ini', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 6),
                        Text('Rp ${store.totalMonthlyRevenue.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF005B96))),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Dana Sudah Cair', style: TextStyle(fontSize: 12, color: Colors.green)),
                        const SizedBox(height: 6),
                        Text('Rp ${store.totalDisbursedFunds.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.green)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Dana Dalam Proses (Pending)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.orange)),
                      SizedBox(height: 2),
                      Text('Pesanan belum selesai / pengiriman', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                  Text('Rp ${store.totalPendingFunds.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.orange)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text('Riwayat Pendapatan & Pembukuan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF005B96))),
          const SizedBox(height: 10),

          if (records.isEmpty && completedOrders.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(child: Text('Belum ada catatan keuangan atau riwayat transaksi.')),
            ),

          ...records.map((rec) {
            final isIncome = rec.type == FinancialType.pemasukan;
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isIncome ? Colors.green.shade100 : Colors.red.shade100,
                  child: Icon(
                    isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                    color: isIncome ? Colors.green : Colors.red,
                  ),
                ),
                title: Text(rec.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text('${rec.category} • ${rec.date.day}/${rec.date.month}/${rec.date.year}', style: const TextStyle(fontSize: 12)),
                trailing: Text(
                  '${isIncome ? "+" : "-"}Rp ${rec.amount.toStringAsFixed(0)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: isIncome ? Colors.green : Colors.red,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }),

          ...completedOrders.map((ord) {
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade50,
                  child: const Icon(Icons.check_circle, color: Color(0xFF005B96)),
                ),
                title: Text('Pencairan Pesanan ${ord.id}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text('Pembeli: ${ord.buyerName} (${ord.buyerCity}) • Dana Cair', style: const TextStyle(fontSize: 12, color: Colors.green)),
                trailing: Text(
                  '+Rp ${ord.itemsTotalPrice.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 14),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    final store = widget.store;
    final fishermanId = store.currentUser?.id ?? 'nelayan_01';
    final avgRating = store.getAverageRatingForFisherman(fishermanId);
    final fisherReviews = store.reviews.where((r) => r.fishermanId == fishermanId).toList();
    final complaints = store.complaints;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Trust & Reputation Header Card
          Card(
            color: const Color(0xFFE0F7FA),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('Reputasi & Kepercayaan Pelanggan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF005B96))),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 36),
                      const SizedBox(width: 8),
                      Text(
                        avgRating.toStringAsFixed(1),
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF005B96)),
                      ),
                      const Text(' / 5.0', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildScoreColumn('Kesegaran Ikan', '4.9/5'),
                      _buildScoreColumn('Ketepatan Waktu', '5.0/5'),
                      _buildScoreColumn('Kejujuran Timbangan', '5.0/5'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text('Ulasan Pembeli (Perorangan & Swalayan)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF005B96))),
          const SizedBox(height: 10),

          if (fisherReviews.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Center(child: Text('Belum ada ulasan dari pembeli.')),
            ),

          ...fisherReviews.map((rev) {
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(rev.buyerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(rev.overallRating.toStringAsFixed(1), style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text('Produk: ${rev.fishTitle}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                    const SizedBox(height: 8),
                    Text('"${rev.comment}"', style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 13)),
                    const SizedBox(height: 8),
                    Text('Tanggal: ${rev.date.day}/${rev.date.month}/${rev.date.year}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 20),

          const Text('Klaim Garansi / Komplain Pelanggan', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF005B96))),
          const SizedBox(height: 10),
          ...complaints.map((comp) {
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: const Icon(Icons.warning, color: Colors.orange),
                title: Text(comp.issueType, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                subtitle: Text('Pembeli: ${comp.buyerName} • Status: ${comp.statusText}', style: const TextStyle(fontSize: 12)),
                trailing: Text('-Rp ${comp.refundAmount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildScoreColumn(String title, String score) {
    return Column(
      children: [
        Text(score, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF005B96))),
        const SizedBox(height: 2),
        Text(title, style: const TextStyle(fontSize: 11, color: Colors.grey)),
      ],
    );
  }

  Widget _buildOrdersTab() {
    final orders = widget.store.orders;

    if (orders.isEmpty) {
      return const Center(
        child: Text('Belum ada pesanan masuk dari pembeli.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (ctx, idx) {
        final order = orders[idx];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(order.id, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF005B96))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        order.statusText,
                        style: const TextStyle(fontSize: 11, color: Color(0xFF00A8CC), fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 6),

                Text('Pembeli: ${order.buyerName}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text('Kota Tujuan: ${order.buyerCity}', style: const TextStyle(color: Color(0xFFD81B60), fontWeight: FontWeight.w600)),
                Text('Alamat: ${order.deliveryAddress}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 10),

                const Text('Item Pesanan:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text('• ${item.fish.title} (${item.quantityKg} Kg) = Rp ${item.totalPrice.toStringAsFixed(0)}'),
                    )),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total: Rp ${order.grandTotal.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF005B96))),
                    Text('Pembayaran: ${order.paymentMethod}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
                const SizedBox(height: 14),

                // Status Action Buttons for Fisherman
                Row(
                  children: [
                    if (order.status == OrderStatus.menungguKonfirmasi)
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF005B96), foregroundColor: Colors.white),
                          onPressed: () => widget.store.updateOrderStatus(order.id, OrderStatus.diprosesNelayan),
                          child: const Text('Kemas Ikan Boks Es'),
                        ),
                      ),
                    if (order.status == OrderStatus.diprosesNelayan)
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00A8CC), foregroundColor: Colors.white),
                          onPressed: () => widget.store.updateOrderStatus(order.id, OrderStatus.dalamPengiriman),
                          child: const Text('Kirim ke Ekspedisi Antar-Kota'),
                        ),
                      ),
                    if (order.status == OrderStatus.dalamPengiriman)
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00A8CC), foregroundColor: Colors.white),
                          onPressed: () => widget.store.updateOrderStatus(order.id, OrderStatus.pesananSelesai),
                          child: const Text('Tandai Selesai'),
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
