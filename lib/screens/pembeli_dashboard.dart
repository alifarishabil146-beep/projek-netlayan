import 'package:flutter/material.dart';
import '../models/netlayan_models.dart';
import '../providers/netlayan_store.dart';
import '../theme/app_colors.dart';
import '../utils/format_rupiah.dart';
import '../widgets/cart_badge.dart';
import '../widgets/product_card.dart';
import 'cart_page.dart';
import 'help_warranty_screen.dart';
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
  String _sortBy = 'Terbaru'; // Pilihan sorting: Terbaru, Harga Terendah, Kesegaran Tertinggi, Rating Tertinggi
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
    final theme = Theme.of(context);

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
                        color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        child: Icon(Icons.set_meal, size: 60, color: theme.colorScheme.primary),
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
                        '${formatRupiah(fish.pricePerKg)} / Kg',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryAqua.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Pelabuhan: ${fish.portLocation}',
                          style: const TextStyle(fontSize: 12, color: AppColors.primaryOceanBlue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Nelayan Penangkap: ${fish.fishermanName} (${fish.fishermanCity}) • ${fish.catchHoursAgo}',
                    style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    fish.description,
                    style: const TextStyle(color: Colors.black87),
                  ),
                  const SizedBox(height: 12),

                  // Quality Grade & Catch Certificate Card for Supermarkets / Buyers
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryAqua.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.secondaryAqua.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.verified, color: AppColors.primaryDarkDeepBlue, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              'Stempel TPI: ${fish.qualityGrade}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primaryDarkDeepBlue),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text('📜 Surat Jalan & Catch Certificate (Traceability):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primaryOceanBlue)),
                        Text('• Nama Kapal: ${fish.vesselName}', style: const TextStyle(fontSize: 11)),
                        Text('• Zona Penangkapan: ${fish.fishingZone}', style: const TextStyle(fontSize: 11)),
                        Text('• Tanggal Bongkar Muat: ${fish.unloadingDate.day}/${fish.unloadingDate.month}/${fish.unloadingDate.year}', style: const TextStyle(fontSize: 11)),
                        Text('• Estimasi Tiba: ${fish.estimatedArrival} • Ongkir: ${formatRupiah(fish.shippingCost)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ],
                    ),
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
                            icon: Icon(Icons.remove_circle_outline, color: theme.colorScheme.primary),
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
                            icon: Icon(Icons.add_circle_outline, color: theme.colorScheme.primary),
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
                              formatRupiah(totalPrice),
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.tertiary, // Coral CTA
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          widget.store.addToCart(fish, selectedKg);
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Ditambahkan ke keranjang (${fish.title})', style: const TextStyle(color: Colors.white)),
                              backgroundColor: AppColors.textNavy,
                              duration: const Duration(seconds: 3),
                              action: SnackBarAction(
                                label: 'LIHAT',
                                textColor: AppColors.secondaryAqua,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) => CartPage(store: widget.store),
                                    ),
                                  );
                                },
                              ),
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user?.name ?? 'Katalog Pembeli', style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
            Text('Tujuan Pengiriman: ${user?.city ?? "Kota Bukittinggi"}', style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          CartBadge(store: widget.store),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => HelpWarrantyScreen(store: widget.store)),
              );
            },
            tooltip: 'Pusat Bantuan & Garansi',
          ),
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
                  color: theme.colorScheme.primary,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$cartCount Item di Keranjang', style: const TextStyle(color: Colors.white70, fontSize: 12)),
                          Text(
                            'Total: ${formatRupiah(widget.store.cartTotalPrice)}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => CartPage(store: widget.store),
                            ),
                          );
                        },
                        icon: Icon(Icons.shopping_bag, color: theme.colorScheme.primary),
                        label: Text('Lihat Keranjang ($cartCount)', style: TextStyle(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                      )
                    ],
                  ),
                ),
              BottomNavigationBar(
                currentIndex: _tabIndex,
                selectedItemColor: theme.colorScheme.primary,
                unselectedItemColor: AppColors.textSecondary,
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
    final theme = Theme.of(context);

    // Filter berdasarkan kategori dan pencarian
    List<FishItem> filtered = widget.store.fishList.where((fish) {
      bool matchesCategory = _selectedCategory == 'Semua' || fish.category == _selectedCategory;
      bool matchesSearch = _searchQuery.isEmpty || fish.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    // Sorting
    if (_sortBy == 'Harga Terendah') {
      filtered.sort((a, b) => a.pricePerKg.compareTo(b.pricePerKg));
    } else if (_sortBy == 'Kesegaran Tertinggi') {
      filtered.sort((a, b) => b.freshnessScore.compareTo(a.freshnessScore));
    } else if (_sortBy == 'Rating Tertinggi') {
      filtered.sort((a, b) => b.rating.compareTo(a.rating));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Pengiriman Antar-Kota (Gradasi Primary -> Aqua)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.colorScheme.primary, AppColors.secondaryAqua],
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
              prefixIcon: Icon(Icons.search, color: theme.colorScheme.primary),
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
                    selectedColor: theme.colorScheme.primary,
                    backgroundColor: Colors.white,
                    side: BorderSide(color: theme.colorScheme.primary),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : theme.colorScheme.primary,
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
          const SizedBox(height: 12),

          // Baris Header Daftar Ikan & Dropdown Sorting
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Katalog Ikan (${filtered.length})',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: theme.colorScheme.primary),
              ),
              PopupMenuButton<String>(
                initialValue: _sortBy,
                onSelected: (val) {
                  setState(() {
                    _sortBy = val;
                  });
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'Terbaru', child: Text('Terbaru (Default)')),
                  const PopupMenuItem(value: 'Harga Terendah', child: Text('Harga Terendah')),
                  const PopupMenuItem(value: 'Kesegaran Tertinggi', child: Text('Kesegaran Tertinggi')),
                  const PopupMenuItem(value: 'Rating Tertinggi', child: Text('Rating Tertinggi')),
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.sort, size: 16, color: theme.colorScheme.primary),
                      const SizedBox(width: 4),
                      Text('Urut: $_sortBy', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

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
                return ProductCard(
                  fish: fish,
                  store: widget.store,
                  onTap: () => _showFishDetailModal(fish),
                );
              },
            ),
        ],
      ),
    );
  }
}
