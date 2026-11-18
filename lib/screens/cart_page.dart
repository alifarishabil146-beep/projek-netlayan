import 'package:flutter/material.dart';
import '../models/netlayan_models.dart';
import '../providers/netlayan_store.dart';
import '../utils/format_rupiah.dart';
import '../widgets/freshness_chip.dart';
import 'cart_checkout_screen.dart';

class CartPage extends StatelessWidget {
  final NetlayanStore store;

  const CartPage({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) {
        final cartItems = store.cart;
        final totalItemsCount = cartItems.length;

        // Kelompokkan item berdasarkan nelayan (fishermanId) mirip per toko di Shopee
        Map<String, List<CartItem>> groupedByFisherman = {};
        for (var item in cartItems) {
          groupedByFisherman.putIfAbsent(item.fish.fishermanId, () => []).add(item);
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Keranjang Saya ($totalItemsCount)', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            backgroundColor: const Color(0xFF005B96),
            foregroundColor: Colors.white,
            actions: [
              if (store.selectedCartCount > 0)
                TextButton.icon(
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Hapus Item Terpilih?'),
                        content: Text('Apakah Anda ingin menghapus ${store.selectedCartCount} item yang dipilih dari keranjang?'),
                        actions: [
                          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                            onPressed: () {
                              store.removeSelectedCartItems();
                              Navigator.pop(ctx);
                            },
                            child: const Text('Hapus'),
                          ),
                        ],
                      ),
                    );
                  },
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Hapus'),
                ),
            ],
          ),
          body: cartItems.isEmpty
              ? EmptyCart(
                  onShopNow: () => Navigator.pop(context),
                )
              : ListView(
                  padding: const EdgeInsets.only(bottom: 90),
                  children: groupedByFisherman.entries.map((entry) {
                    final fishermanId = entry.key;
                    final items = entry.value;
                    final firstFish = items.first.fish;
                    final isGroupSelected = items.every((item) => item.isSelected);

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CartGroupHeader(
                            fishermanName: firstFish.fishermanName,
                            portLocation: firstFish.portLocation,
                            isGroupSelected: isGroupSelected,
                            onChanged: (selected) {
                              store.toggleFishermanSelection(fishermanId, selected ?? false);
                            },
                          ),
                          const Divider(height: 1),
                          ...items.map((cartItem) {
                            return Dismissible(
                              key: Key(cartItem.fish.id),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                color: Colors.red,
                                child: const Icon(Icons.delete, color: Colors.white),
                              ),
                              onDismissed: (_) {
                                store.removeFromCart(cartItem.fish.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('${cartItem.fish.title} dihapus dari keranjang')),
                                );
                              },
                              child: CartItemTile(
                                cartItem: cartItem,
                                store: store,
                              ),
                            );
                          }),
                        ],
                      ),
                    );
                  }).toList(),
                ),
          bottomNavigationBar: cartItems.isEmpty ? null : CartBottomBar(store: store),
        );
      },
    );
  }
}

class CartGroupHeader extends StatelessWidget {
  final String fishermanName;
  final String portLocation;
  final bool isGroupSelected;
  final ValueChanged<bool?> onChanged;

  const CartGroupHeader({
    super.key,
    required this.fishermanName,
    required this.portLocation,
    required this.isGroupSelected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          Checkbox(
            value: isGroupSelected,
            activeColor: const Color(0xFF005B96),
            onChanged: onChanged,
          ),
          const Icon(Icons.store, size: 18, color: Color(0xFF005B96)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$fishermanName ($portLocation)',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF005B96)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  final CartItem cartItem;
  final NetlayanStore store;

  const CartItemTile({
    super.key,
    required this.cartItem,
    required this.store,
  });

  void _confirmDeleteOrUpdate(BuildContext context, double newQty) {
    if (newQty < 1) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Hapus Produk?'),
          content: Text('Apakah Anda ingin menghapus ${cartItem.fish.title} dari keranjang?'),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              onPressed: () {
                store.removeFromCart(cartItem.fish.id);
                Navigator.pop(ctx);
              },
              child: const Text('Hapus'),
            ),
          ],
        ),
      );
    } else if (newQty > cartItem.fish.stockKg) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Stok maksimum tersedia adalah ${cartItem.fish.stockKg.toStringAsFixed(0)} Kg')),
      );
    } else {
      store.updateCartQuantity(cartItem.fish.id, newQty);
    }
  }

  @override
  Widget build(BuildContext context) {
    final fish = cartItem.fish;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            value: cartItem.isSelected,
            activeColor: const Color(0xFF005B96),
            onChanged: (_) => store.toggleCartItemSelection(fish.id),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              fish.imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (c, e, s) => Container(
                width: 70,
                height: 70,
                color: Colors.blue.shade50,
                child: const Icon(Icons.set_meal, size: 30, color: Color(0xFF005B96)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fish.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '${formatRupiah(fish.pricePerKg)} / Kg',
                  style: const TextStyle(color: Color(0xFF005B96), fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 4),
                FreshnessChip(
                  freshnessScore: fish.freshnessScore,
                  catchHoursAgo: fish.catchHoursAgo,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Subtotal: ${formatRupiah(cartItem.totalPrice)}',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                          onTap: () => _confirmDeleteOrUpdate(context, cartItem.quantityKg - 1),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(4)),
                            child: const Icon(Icons.remove, size: 14),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text('${cartItem.quantityKg.toStringAsFixed(0)} Kg', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        ),
                        InkWell(
                          onTap: () => _confirmDeleteOrUpdate(context, cartItem.quantityKg + 1),
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade400), borderRadius: BorderRadius.circular(4)),
                            child: const Icon(Icons.add, size: 14),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CartBottomBar extends StatelessWidget {
  final NetlayanStore store;

  const CartBottomBar({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final isAllSelected = store.isAllCartSelected;
    final selectedCount = store.selectedCartCount;
    final selectedTotal = store.selectedCartTotalPrice;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, -2)),
        ],
      ),
      child: Row(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Checkbox(
                value: isAllSelected,
                activeColor: const Color(0xFF005B96),
                onChanged: (val) => store.toggleSelectAllCart(val ?? false),
              ),
              const Text('Semua', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Total: ${formatRupiah(selectedTotal)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF005B96)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Text(
                  'Ongkir di checkout',
                  style: TextStyle(fontSize: 9, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedCount > 0 ? const Color(0xFFE65100) : Colors.grey.shade400,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: selectedCount > 0
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => CartCheckoutScreen(
                          store: store,
                          directItems: store.selectedCartItems,
                        ),
                      ),
                    );
                  }
                : null,
            child: Text(
              'Checkout ($selectedCount)',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class EmptyCart extends StatelessWidget {
  final VoidCallback onShopNow;

  const EmptyCart({super.key, required this.onShopNow});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'Keranjang kamu masih kosong',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 8),
            Text(
              'Yuk, temukan ikan segar tangkapan nelayan Padang berkualitas di katalog.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF005B96),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: onShopNow,
              child: const Text('Mulai Belanja', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}
