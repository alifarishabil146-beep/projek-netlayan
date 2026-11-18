import 'package:flutter/material.dart';
import '../models/netlayan_models.dart';
import '../providers/netlayan_store.dart';
import '../utils/format_rupiah.dart';

class CartCheckoutScreen extends StatefulWidget {
  final NetlayanStore store;
  final List<CartItem>? directItems; // Mode Beli Sekarang (1 produk langsung)

  const CartCheckoutScreen({
    super.key,
    required this.store,
    this.directItems,
  });

  @override
  State<CartCheckoutScreen> createState() => _CartCheckoutScreenState();
}

class _CartCheckoutScreenState extends State<CartCheckoutScreen> {
  final _buyerNameCtrl = TextEditingController();
  final _buyerPhoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  String _selectedCity = 'Kota Bukittinggi';
  String _selectedCourier = 'Cold Chain Bus Express (Antar Kota Subuh)';
  double _shippingFee = 45000;
  String _selectedPaymentMethod = 'QRIS Instant Payment';
  late List<CartItem> _checkoutItems;

  final List<String> _cities = [
    'Kota Padang',
    'Kota Bukittinggi',
    'Kota Payakumbuh',
    'Kota Solok',
    'Pekanbaru',
    'Medan',
    'Jakarta',
    'Bandung',
  ];

  @override
  void initState() {
    super.initState();
    final user = widget.store.currentUser;
    _buyerNameCtrl.text = user?.name ?? 'Swalayan Grand Lucky';
    _buyerPhoneCtrl.text = user?.phone ?? '081234567890';
    _addressCtrl.text = user?.address ?? 'Jl. Sudirman No. 45, Bukittinggi';
    _selectedCity = user?.city ?? 'Kota Bukittinggi';
    _updateShippingFee();

    // Tentukan item yang akan di-checkout (Direct Buy Now atau dari Keranjang)
    if (widget.directItems != null) {
      _checkoutItems = List.from(widget.directItems!);
    } else {
      _checkoutItems = widget.store.cart;
    }
  }

  void _updateShippingFee() {
    setState(() {
      if (_selectedCity == 'Kota Padang') {
        _shippingFee = 20000;
        _selectedCourier = 'Kurir Lokal Instan Boks Es (Padang)';
      } else if (_selectedCity == 'Jakarta' || _selectedCity == 'Bandung' || _selectedCity == 'Medan') {
        _shippingFee = 120000;
        _selectedCourier = 'Air Cargo Cold Chain (Luar Provinsi)';
      } else {
        _shippingFee = 45000;
        _selectedCourier = 'Cold Chain Bus Express (Antar Kota Subuh)';
      }
    });
  }

  void _processPayment() {
    if (_buyerNameCtrl.text.trim().isEmpty || _addressCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lengkapi alamat pengiriman terlebih dahulu.')),
      );
      return;
    }

    final newOrder = widget.store.placeOrder(
      buyerName: _buyerNameCtrl.text.trim(),
      buyerPhone: _buyerPhoneCtrl.text.trim(),
      buyerCity: _selectedCity,
      deliveryAddress: _addressCtrl.text.trim(),
      courierName: _selectedCourier,
      shippingFee: _shippingFee,
      paymentMethod: _selectedPaymentMethod,
      customItems: widget.directItems != null ? _checkoutItems : null,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFF005B96), size: 28),
              SizedBox(width: 10),
              Text('Pesanan Berhasil!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID Pesanan: ${newOrder.id}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF005B96))),
              const SizedBox(height: 8),
              Text('Tujuan: ${newOrder.buyerCity}'),
              Text('Total Pembayaran: ${formatRupiah(newOrder.grandTotal)}'),
              const SizedBox(height: 12),
              if (_selectedPaymentMethod.contains('QRIS')) ...[
                const Text('Silakan scan QRIS dibawah ini untuk pembayaran:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    width: 160,
                    height: 160,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFF005B96), width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.qr_code_2, size: 90, color: Color(0xFF005B96)),
                        SizedBox(height: 4),
                        Text('QRIS NETLAYAN', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF00A8CC))),
                      ],
                    ),
                  ),
                ),
              ] else
                Text('Metode Pembayaran: $_selectedPaymentMethod\nNomor Rekening: 8870029311 (Bank BCA - Netlayan ID)'),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF005B96), foregroundColor: Colors.white),
              onPressed: () {
                Navigator.pop(ctx); // Close dialog
                Navigator.pop(context); // Return to home
              },
              child: const Text('Lacak Status Pengiriman'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.directItems != null ? 'Beli Sekarang (Checkout)' : 'Checkout & Pembayaran'),
        backgroundColor: const Color(0xFF005B96),
        foregroundColor: Colors.white,
      ),
      body: AnimatedBuilder(
        animation: widget.store,
        builder: (context, _) {
          final itemsTotal = _checkoutItems.fold(0.0, (sum, item) => sum + item.totalPrice);
          final grandTotal = itemsTotal + _shippingFee;

          if (_checkoutItems.isEmpty) {
            return const Center(
              child: Text('Keranjang atau produk pesanan kosong.'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cart Items List
                Text(
                  widget.directItems != null ? 'Rincian Produk Dibeli' : 'Rincian Ikan di Keranjang',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF005B96)),
                ),
                const SizedBox(height: 10),
                ..._checkoutItems.map((item) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      title: Text(item.fish.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${formatRupiah(item.fish.pricePerKg)} / Kg • Tangkapan ${item.fish.fishermanName}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline, size: 20, color: Color(0xFF005B96)),
                            onPressed: () {
                              setState(() {
                                if (widget.directItems != null) {
                                  if (item.quantityKg > 1) {
                                    item.quantityKg -= 1;
                                  }
                                } else {
                                  widget.store.updateCartQuantity(item.fish.id, item.quantityKg - 1);
                                }
                              });
                            },
                          ),
                          Text('${item.quantityKg.toStringAsFixed(0)} Kg', style: const TextStyle(fontWeight: FontWeight.bold)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, size: 20, color: Color(0xFF005B96)),
                            onPressed: () {
                              setState(() {
                                if (widget.directItems != null) {
                                  if (item.quantityKg < item.fish.stockKg) {
                                    item.quantityKg += 1;
                                  }
                                } else {
                                  widget.store.updateCartQuantity(item.fish.id, item.quantityKg + 1);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),

                // Shipping Destination Form
                const Text('Alamat & Pengiriman Antar-Kota', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF005B96))),
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _buyerNameCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Nama Penerima / Swalayan',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Dropdown Kota Tujuan
                        DropdownButtonFormField<String>(
                          initialValue: _selectedCity,
                          decoration: const InputDecoration(
                            labelText: 'Kota Tujuan Pengiriman',
                            border: OutlineInputBorder(),
                          ),
                          items: _cities.map((city) {
                            return DropdownMenuItem(
                              value: city,
                              child: Text(city),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              _selectedCity = val;
                              _updateShippingFee();
                            }
                          },
                        ),
                        const SizedBox(height: 12),

                        TextField(
                          controller: _addressCtrl,
                          maxLines: 2,
                          decoration: const InputDecoration(
                            labelText: 'Alamat Lengkap Pengiriman',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),

                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE0F7FA),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.ac_unit, color: Color(0xFF005B96)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_selectedCourier, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF005B96))),
                                    Text('Ongkir Cold Chain Boks Es: ${formatRupiah(_shippingFee)}', style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Payment Method Selector
                const Text('Metode Pembayaran', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF005B96))),
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.qr_code_2, color: Color(0xFF005B96)),
                        title: const Text('QRIS Instant Payment (Semua Bank / E-Wallet)'),
                        trailing: Radio<String>(
                          value: 'QRIS Instant Payment',
                          groupValue: _selectedPaymentMethod,
                          activeColor: const Color(0xFF005B96),
                          onChanged: (val) => setState(() => _selectedPaymentMethod = val!),
                        ),
                        onTap: () => setState(() => _selectedPaymentMethod = 'QRIS Instant Payment'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.account_balance, color: Color(0xFF00A8CC)),
                        title: const Text('Transfer Bank (BCA / Mandiri / BRI)'),
                        trailing: Radio<String>(
                          value: 'Transfer Bank BCA',
                          groupValue: _selectedPaymentMethod,
                          activeColor: const Color(0xFF005B96),
                          onChanged: (val) => setState(() => _selectedPaymentMethod = val!),
                        ),
                        onTap: () => setState(() => _selectedPaymentMethod = 'Transfer Bank BCA'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.account_balance_wallet, color: Color(0xFFAD1457)),
                        title: const Text('E-Wallet (GoPay / OVO / DANA)'),
                        trailing: Radio<String>(
                          value: 'GoPay / E-Wallet',
                          groupValue: _selectedPaymentMethod,
                          activeColor: const Color(0xFF005B96),
                          onChanged: (val) => setState(() => _selectedPaymentMethod = val!),
                        ),
                        onTap: () => setState(() => _selectedPaymentMethod = 'GoPay / E-Wallet'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Order Summary Footer
                Card(
                  color: const Color(0xFF005B96),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Subtotal Ikan:', style: TextStyle(color: Colors.white70)),
                            Text(formatRupiah(itemsTotal), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Ongkos Kirim Boks Es:', style: TextStyle(color: Colors.white70)),
                            Text(formatRupiah(_shippingFee), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const Divider(color: Colors.white38, height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('TOTAL BAYAR:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                            Text(formatRupiah(grandTotal), style: const TextStyle(color: Colors.yellowAccent, fontWeight: FontWeight.bold, fontSize: 20)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF005B96),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: _processPayment,
                            child: const Text('Bayar Sekarang & Kirim Pesanan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
