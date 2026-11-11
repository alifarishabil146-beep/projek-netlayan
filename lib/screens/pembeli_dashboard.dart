import 'package:flutter/material.dart';
import '../models/netlayan_models.dart';
import '../providers/netlayan_store.dart';
import 'cart_checkout_screen.dart';
import 'order_tracking_screen.dart';
import 'recipe_screen.dart';

class PembeliDashboard extends StatefulWidget {
  final NetlayanStore store;
  final VoidCallback onLogout;

  const PembeliDashboard({
    super.key,
    required this.store,
    required this.onLogout,
  });

  @override
  State<PembeliDashboard> createState() => _PembeliDashboardState();
}

class _PembeliDashboardState extends State<PembeliDashboard> {
  String _selectedCategory = 'Semua';
  String _searchQuery = '';
  int _tabIndex = 0;

  final List<String> _categories = [
    'Semua',
    'Ikan Laut',
    'Ikan Karang',
    'Udang & Cumi',
    'Ikan Besar',
  ];

  void _showFishDetailModal(FishItem fish) {
    double selectedKg = 1.0;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final totalPrice = fish.pricePerKg * selectedKg;

            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      fish.imageUrl,
                      height: 180,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => Container(
                        height: 180,
                        color: Colors.pink.shade50,
                        child: const Icon(Icons.set_meal, size: 60, color: Color(0xFFE91E63)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    fish.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Rp ${fish.pricePerKg.toStringAsFixed(0)} / Kg',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFE91E63)),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCE4EC),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Pelabuhan: ${fish.portLocation}',
                          style: const TextStyle(fontSize: 12, color: Color(0xFFC2185B), fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Nelayan Penangkap: ${fish.fishermanName} (${fish.fishermanCity}) • ${fish.catchHoursAgo}',
                    style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    fish.description,
                    style: const TextStyle(color: Colors.black87),
                  ),
                  const Divider(height: 24),

                  // Quantity Kg Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Jumlah Pesanan (Kg):',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, color: Color(0xFFE91E63)),
                            onPressed: selectedKg > 1
                                ? () {
                                    setModalState(() {
                                      selectedKg -= 1;
                                    });
                                  }
                                : null,
                          ),
                          Text(
                            '${selectedKg.toStringAsFixed(0)} Kg',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, color: Color(0xFFE91E63)),
                            onPressed: selectedKg < fish.stockKg
                                ? () {
                                    setModalState(() {
                                      selectedKg += 1;
                                    });
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Subtotal Harga', style: TextStyle(fontSize: 12, color: Colors.grey)),
                            Text(
                              'Rp ${totalPrice.toStringAsFixed(0)}',
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFE91E63)),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE91E63),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          widget.store.addToCart(fish, selectedKg);
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${fish.title} ($selectedKg Kg) ditambahkan ke keranjang!'),
                              backgroundColor: const Color(0xFFE91E63),
                            ),
                          );
                        },
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Tambah Ke Keranjang', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
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
            Text(user?.name ?? 'Katalog Pembeli', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            Text('Tujuan Pengiriman: ${user?.city ?? "Kota Bukittinggi"}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        backgroundColor: const Color(0xFFE91E63),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: widget.onLogout,
            tooltip: 'Keluar',
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: widget.store,
        builder: (context, _) {
          if (_tabIndex == 0) {
            return _buildCatalogView();
          } else if (_tabIndex == 1) {
            return RecipeScreen(store: widget.store);
          } else {
            return OrderTrackingScreen(store: widget.store);
          }
        },
      ),
      bottomNavigationBar: AnimatedBuilder(
        animation: widget.store,
        builder: (context, _) {
          final cartCount = widget.store.cart.length;
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (cartCount > 0 && _tabIndex != 2)
                Container(
                  color: const Color(0xFF880E4F),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$cartCount Item di Keranjang', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          Text(
                            'Total: Rp ${widget.store.cartTotalPrice.toStringAsFixed(0)}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF80AB),
                          foregroundColor: Colors.black87,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => CartCheckoutScreen(store: widget.store),
                            ),
                          );
                        },
                        icon: const Icon(Icons.shopping_bag),
                        label: const Text('Checkout & Bayar', style: TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
              BottomNavigationBar(
                currentIndex: _tabIndex,
                selectedItemColor: const Color(0xFFE91E63),
                onTap: (idx) {
                  setState(() {
                    _tabIndex = idx;
                  });
                },
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Katalog Ikan'),
                  BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Resep & Pintar'),
                  BottomNavigationBarItem(icon: Icon(Icons.local_shipping), label: 'Lacak Pesanan'),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCatalogView() {
    List<FishItem> filtered = widget.store.fishList.where((fish) {
      bool matchesCategory = _selectedCategory == 'Semua' || fish.category == _selectedCategory;
      bool matchesSearch = _searchQuery.isEmpty || fish.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Pink Pengiriman Antar-Kota
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE91E63), Color(0xFFC2185B)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_shipping, size: 40, color: Colors.white),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'PENGIRIMAN HASIL LAUT ANTAR-KOTA',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Pengiriman boks es terisolasi dari nelayan Padang ke Bukittinggi, Pekanbaru, Medan, Jakarta & kota lainnya.',
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 11),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Search Bar
          TextField(
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
            decoration: InputDecoration(
              hintText: 'Cari jenis ikan segar (contoh: Kakap, Tongkol, Cumi)...',
              prefixIcon: const Icon(Icons.search, color: Color(0xFFE91E63)),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Categories Chips
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              itemBuilder: (ctx, idx) {
                final cat = _categories[idx];
                final isSelected = cat == _selectedCategory;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: ChoiceChip(
                    label: Text(cat),
                    selected: isSelected,
                    selectedColor: const Color(0xFFE91E63),
                    backgroundColor: Colors.white,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFFC2185B),
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedCategory = cat;
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Fish List
          if (filtered.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32.0),
                child: Text('Tidak ada ikan segar yang cocok dengan pencarian.'),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filtered.length,
              itemBuilder: (ctx, idx) {
                final fish = filtered[idx];
                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  color: Colors.white,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => _showFishDetailModal(fish),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              fish.imageUrl,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) => Container(
                                width: 100,
                                height: 100,
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
                                Text(
                                  fish.title,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Rp ${fish.pricePerKg.toStringAsFixed(0)} / Kg',
                                  style: const TextStyle(
                                    color: Color(0xFFE91E63),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Nelayan: ${fish.fishermanName} (${fish.portLocation})',
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFCE4EC),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'Skor Kesegaran: ${fish.freshnessScore}%',
                                        style: const TextStyle(fontSize: 10, color: Color(0xFFC2185B), fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Stok: ${fish.stockKg} Kg',
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: Color(0xFFE91E63)),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
