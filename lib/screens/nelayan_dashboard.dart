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
    final categoryCtrl = TextEditingController(text: 'Ikan Laut');
    final priceCtrl = TextEditingController(text: '40000');
    final stockCtrl = TextEditingController(text: '50');
    final portCtrl = TextEditingController(text: widget.store.currentUser?.portLocation ?? 'Pelabuhan Muara Padang');
    final descCtrl = TextEditingController(text: 'Hasil tangkapan baru hari ini, dijamin masih sangat segar.');
    String selectedSampleImg = 'https://images.unsplash.com/photo-1534483509719-3feaee7c30da?w=600&auto=format&fit=crop&q=80';

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
                      'Unggah Hasil Tangkapan Baru',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE91E63)),
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
                    prefixIcon: Icon(Icons.set_meal, color: Color(0xFFE91E63)),
                    border: OutlineInputBorder(),
                  ),
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
                          prefixIcon: Icon(Icons.payments, color: Color(0xFFE91E63)),
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
                          prefixIcon: Icon(Icons.scale, color: Color(0xFFE91E63)),
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
                    prefixIcon: Icon(Icons.anchor, color: Color(0xFFE91E63)),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: descCtrl,
                  maxLines: 2,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi Ikan & Kualitas Tangkapan',
                    prefixIcon: Icon(Icons.description, color: Color(0xFFE91E63)),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE91E63),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      if (titleCtrl.text.trim().isEmpty) return;

                      final newFish = FishItem(
                        id: 'fish_${DateTime.now().millisecondsSinceEpoch}',
                        fishermanId: widget.store.currentUser?.id ?? 'nelayan_01',
                        fishermanName: widget.store.currentUser?.name ?? 'Pak Syamsul',
                        fishermanCity: widget.store.currentUser?.city ?? 'Kota Padang',
                        title: titleCtrl.text.trim(),
                        category: categoryCtrl.text.trim(),
                        pricePerKg: double.tryParse(priceCtrl.text) ?? 35000,
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
                          content: Text('Berhasil mengunggah ${newFish.title}!'),
                          backgroundColor: const Color(0xFFE91E63),
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
        backgroundColor: const Color(0xFFE91E63),
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
            return const WeatherNavigationScreen();
          } else {
            return _buildOrdersTab();
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFFE91E63),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.phishing),
            label: 'Tangkapan Saya',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.explore),
            label: 'Navigasi Cuaca',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Pesanan Masuk',
          ),
        ],
      ),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _showAddFishDialog,
              backgroundColor: const Color(0xFFE91E63),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.add),
              label: const Text('Unggah Tangkapan'),
            )
          : null,
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
            color: const Color(0xFFFCE4EC),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const ListTile(
              leading: Icon(Icons.wb_sunny, color: Color(0xFFE91E63), size: 32),
              title: Text('Cuaca Perairan Padang: Aman', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF880E4F))),
              subtitle: Text('Gelombang 1.2m • Angin 14 knot. Klik Tab Navigasi Cuaca untuk radar interaktif.'),
            ),
          ),
          const SizedBox(height: 16),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Katalog Tangkapan Terbitan Saya', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF880E4F))),
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
                          color: Colors.pink.shade50,
                          child: const Icon(Icons.set_meal, size: 40, color: Color(0xFFE91E63)),
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
                          Text('Rp ${fish.pricePerKg.toStringAsFixed(0)} / Kg', style: const TextStyle(color: Color(0xFFE91E63), fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 2),
                          Text('Stok: ${fish.stockKg} Kg • ${fish.portLocation}', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFCE4EC),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text('Ditangkap Hari Ini (Segar)', style: TextStyle(fontSize: 11, color: Color(0xFFC2185B), fontWeight: FontWeight.w600)),
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
                    Text(order.id, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFE91E63))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.pink.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        order.statusText,
                        style: const TextStyle(fontSize: 11, color: Color(0xFFC2185B), fontWeight: FontWeight.bold),
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
                    Text('Total: Rp ${order.grandTotal.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFE91E63))),
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
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFE91E63), foregroundColor: Colors.white),
                          onPressed: () => widget.store.updateOrderStatus(order.id, OrderStatus.diprosesNelayan),
                          child: const Text('Kemas Ikan Boks Es'),
                        ),
                      ),
                    if (order.status == OrderStatus.diprosesNelayan)
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEC407A), foregroundColor: Colors.white),
                          onPressed: () => widget.store.updateOrderStatus(order.id, OrderStatus.dalamPengiriman),
                          child: const Text('Kirim ke Ekspedisi Antar-Kota'),
                        ),
                      ),
                    if (order.status == OrderStatus.dalamPengiriman)
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC2185B), foregroundColor: Colors.white),
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
