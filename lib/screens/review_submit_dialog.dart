import 'package:flutter/material.dart';
import '../models/netlayan_models.dart';
import '../providers/netlayan_store.dart';

class ReviewSubmitDialog extends StatefulWidget {
  final NetlayanStore store;
  final OrderModel order;

  const ReviewSubmitDialog({
    super.key,
    required this.store,
    required this.order,
  });

  @override
  State<ReviewSubmitDialog> createState() => _ReviewSubmitDialogState();
}

class _ReviewSubmitDialogState extends State<ReviewSubmitDialog> {
  double _freshnessRating = 5.0;
  double _deliveryRating = 5.0;
  double _weightRating = 5.0;
  final _commentCtrl = TextEditingController();

  @override
  void dispose() {
    _commentCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firstItem = widget.order.items.isNotEmpty ? widget.order.items.first.fish : null;
    final fishermanId = firstItem?.fishermanId ?? 'nelayan_01';
    final fishermanName = firstItem?.fishermanName ?? 'Pak Syamsul';
    final fishTitle = firstItem?.title ?? 'Ikan Tangkapan Segar';

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ulasan & Penilaian Kualitas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF005B96))),
          const SizedBox(height: 4),
          Text('Nelayan: $fishermanName', style: TextStyle(fontSize: 13, color: Colors.grey.shade700)),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Produk: $fishTitle', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const Divider(height: 24),

            // Freshness Rating
            const Text('1. Tingkat Kesegaran Ikan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Slider(
              value: _freshnessRating,
              min: 1,
              max: 5,
              divisions: 4,
              activeColor: const Color(0xFF005B96),
              label: _freshnessRating.toStringAsFixed(1),
              onChanged: (val) {
                setState(() {
                  _freshnessRating = val;
                });
              },
            ),
            Center(child: Text('${_freshnessRating.toStringAsFixed(1)} / 5.0 Bintang', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF005B96)))),
            const SizedBox(height: 10),

            // Delivery Rating
            const Text('2. Ketepatan Waktu Pengiriman', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Slider(
              value: _deliveryRating,
              min: 1,
              max: 5,
              divisions: 4,
              activeColor: const Color(0xFF005B96),
              label: _deliveryRating.toStringAsFixed(1),
              onChanged: (val) {
                setState(() {
                  _deliveryRating = val;
                });
              },
            ),
            Center(child: Text('${_deliveryRating.toStringAsFixed(1)} / 5.0 Bintang', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF005B96)))),
            const SizedBox(height: 10),

            // Weight Honesty Rating
            const Text('3. Kejujuran Timbangan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            Slider(
              value: _weightRating,
              min: 1,
              max: 5,
              divisions: 4,
              activeColor: const Color(0xFF005B96),
              label: _weightRating.toStringAsFixed(1),
              onChanged: (val) {
                setState(() {
                  _weightRating = val;
                });
              },
            ),
            Center(child: Text('${_weightRating.toStringAsFixed(1)} / 5.0 Bintang', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF005B96)))),
            const SizedBox(height: 14),

            TextField(
              controller: _commentCtrl,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Ulasan & Komentar Anda',
                hintText: 'Bagikan pengalaman kesegaran ikan...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Batal'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF005B96),
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            final overall = (_freshnessRating + _deliveryRating + _weightRating) / 3;

            final review = ReviewModel(
              id: 'rev_${DateTime.now().millisecondsSinceEpoch}',
              orderId: widget.order.id,
              buyerId: widget.store.currentUser?.id ?? 'pembeli_01',
              buyerName: widget.store.currentUser?.name ?? 'Pembeli',
              fishermanId: fishermanId,
              fishTitle: fishTitle,
              freshnessRating: _freshnessRating,
              deliveryRating: _deliveryRating,
              weightRating: _weightRating,
              overallRating: overall,
              comment: _commentCtrl.text.trim().isEmpty ? 'Sangat puas dengan kualitas ikan!' : _commentCtrl.text.trim(),
              date: DateTime.now(),
            );

            widget.store.addReview(review);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Terima kasih! Ulasan & rating Anda berhasil dikirim.'),
                backgroundColor: Color(0xFF005B96),
              ),
            );
          },
          child: const Text('Kirim Ulasan'),
        ),
      ],
    );
  }
}
