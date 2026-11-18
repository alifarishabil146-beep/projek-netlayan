import 'package:flutter/material.dart';
import '../models/netlayan_models.dart';
import '../providers/netlayan_store.dart';
import '../screens/cart_checkout_screen.dart';
import '../screens/cart_page.dart';
import '../theme/app_colors.dart';
import '../utils/format_rupiah.dart';
import 'freshness_chip.dart';

class ProductCard extends StatelessWidget {
  final FishItem fish;
  final NetlayanStore store;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.fish,
    required this.store,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLowStock = fish.stockKg < 10;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      color: Colors.white,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Foto produk dengan badge favorit (hati) dan stok menipis
                  Stack(
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
                            color: theme.colorScheme.primary.withValues(alpha: 0.1),
                            child: Icon(Icons.set_meal, size: 40, color: theme.colorScheme.primary),
                          ),
                        ),
                      ),
                      // Tombol Favorit (Hati)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () {
                            store.toggleFavorite(fish.id);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.85),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              fish.isFavorite ? Icons.favorite : Icons.favorite_border,
                              size: 18,
                              color: fish.isFavorite ? Colors.red : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      // Badge Stok Menipis
                      if (isLowStock)
                        Positioned(
                          bottom: 4,
                          left: 4,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'Stok Menipis (${fish.stockKg.toStringAsFixed(0)} Kg)',
                              style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),

                  // Detail Informasi Produk
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                fish.title,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            // Rating Nelayan (Bintang + Angka)
                            Row(
                              children: [
                                const Icon(Icons.star, color: AppColors.starAmber, size: 14),
                                const SizedBox(width: 2),
                                Text(
                                  fish.rating.toStringAsFixed(1),
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${formatRupiah(fish.pricePerKg)} / Kg',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Nelayan: ${fish.fishermanName} (${fish.portLocation})',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        // Label Kesegaran berwarna dan waktu tangkap
                        FreshnessChip(
                          freshnessScore: fish.freshnessScore,
                          catchHoursAgo: fish.catchHoursAgo,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Divider(height: 1, color: Colors.black12),
              const SizedBox(height: 8),

              // Info Estimasi Tiba & Ongkir
              Text(
                '🚚 ${fish.estimatedArrival} • Ongkir ${formatRupiah(fish.shippingCost)}',
                style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),

              // Dua Tombol Berdampingan dalam satu Row (OutlinedButton "+ Keranjang" & ElevatedButton "Beli Sekarang")
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                        backgroundColor: Colors.white,
                        side: BorderSide(color: theme.colorScheme.primary),
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        store.addToCart(fish, 1.0);
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
                                    builder: (ctx) => CartPage(store: store),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_shopping_cart, size: 16),
                      label: const Text(
                        '+ Keranjang',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.tertiary, // Coral CTA
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => CartCheckoutScreen(
                              store: store,
                              directItems: [CartItem(fish: fish, quantityKg: 1.0)],
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.bolt, size: 16),
                      label: const Text(
                        'Beli Sekarang',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
