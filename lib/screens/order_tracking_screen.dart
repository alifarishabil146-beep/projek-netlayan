import 'package:flutter/material.dart';
import '../models/netlayan_models.dart';
import '../providers/netlayan_store.dart';

class OrderTrackingScreen extends StatelessWidget {
  final NetlayanStore store;

  const OrderTrackingScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    final myOrders = store.orders;

    if (myOrders.isEmpty) {
      return const Center(
        child: Text('Belum ada pesanan aktif.'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: myOrders.length,
      itemBuilder: (ctx, idx) {
        final order = myOrders[idx];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 2,
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
                        color: const Color(0xFFFCE4EC),
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

                Text('Kota Tujuan: ${order.buyerCity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text('Ekspedisi: ${order.courierName}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text('Alamat: ${order.deliveryAddress}', style: const TextStyle(fontSize: 12, color: Colors.black87)),
                const SizedBox(height: 12),

                // Delivery Status Timeline
                const Text('Lacak Status Pengiriman:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF880E4F))),
                const SizedBox(height: 8),
                _buildTimelineStep('1', 'Pesanan Diterima & Lunas', 'Metode: ${order.paymentMethod}', true),
                _buildTimelineStep(
                  '2',
                  'Pengemasan Boks Es Sterofom',
                  'Dipersiapkan oleh Nelayan di Pelabuhan Padang',
                  order.status == OrderStatus.diprosesNelayan || order.status == OrderStatus.dalamPengiriman || order.status == OrderStatus.pesananSelesai,
                ),
                _buildTimelineStep(
                  '3',
                  'Dalam Perjalanan Antar-Kota',
                  'Estimasi Tiba di ${order.buyerCity} Subuh Ini',
                  order.status == OrderStatus.dalamPengiriman || order.status == OrderStatus.pesananSelesai,
                ),
                _buildTimelineStep(
                  '4',
                  'Pesanan Selesai',
                  'Ikan segar telah diterima di lokasi tujuan',
                  order.status == OrderStatus.pesananSelesai,
                ),

                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Pembayaran:', style: TextStyle(color: Colors.grey.shade700)),
                    Text(
                      'Rp ${order.grandTotal.toStringAsFixed(0)}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFE91E63)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTimelineStep(String stepNumber, String title, String subtitle, bool isCompleted) {
    final color = isCompleted ? const Color(0xFFE91E63) : Colors.grey;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: color,
            child: isCompleted
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : Text(stepNumber, style: const TextStyle(fontSize: 10, color: Colors.white)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
                    color: isCompleted ? Colors.black87 : Colors.grey,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 11, color: isCompleted ? Colors.grey.shade700 : Colors.grey.shade500),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
