import 'package:flutter/material.dart';
import '../models/netlayan_models.dart';
import '../providers/netlayan_store.dart';

class KurirDashboard extends StatefulWidget {
  final NetlayanStore store;
  final VoidCallback onLogout;

  const KurirDashboard({
    super.key,
    required this.store,
    required this.onLogout,
  });

  @override
  State<KurirDashboard> createState() => _KurirDashboardState();
}

class _KurirDashboardState extends State<KurirDashboard> {
  void _showEpodDialog(OrderModel order) {
    final receiverCtrl = TextEditingController(text: 'Bpk. Hendra (Manager Gudang Swalayan)');
    final signCtrl = TextEditingController(text: 'TTD Digital Terverifikasi');
    String samplePhoto = 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?w=600&auto=format&fit=crop&q=80';

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
                      'Bukti Serah Terima Digital (E-POD)',
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

                Text('Pesanan: ${order.id} • Tujuan: ${order.buyerName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),

                // Photo Preview
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    samplePhoto,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 12),
                const Text('📷 Foto Boks Ikan Tiba di Lokasi Swalayan (Captured Live)', style: TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 12),

                TextField(
                  controller: receiverCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Nama Penerima (Pihak Swalayan / Pembeli)',
                    prefixIcon: Icon(Icons.person, color: Color(0xFFE91E63)),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: signCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Konfirmasi Tanda Tangan Digital',
                    prefixIcon: Icon(Icons.edit, color: Color(0xFFE91E63)),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      final epod = EpodModel(
                        orderId: order.id,
                        photoUrl: samplePhoto,
                        receiverName: receiverCtrl.text.trim(),
                        signatureText: signCtrl.text.trim(),
                        deliveryTime: DateTime.now(),
                      );

                      widget.store.completeOrderWithEpod(order.id, epod);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('E-POD Terkirim! Pesanan ${order.id} Selesai & Dana Otomatis Cair ke Nelayan.'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                    child: const Text('Selesaikan Pengiriman & Cairkan Dana', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
    final activeOrders = widget.store.orders;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Kurir Kargo Ekspedisi Cold Chain', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(user?.name ?? 'Budi (Sopir Kargo)', style: const TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        backgroundColor: const Color(0xFF006064),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: widget.onLogout,
            tooltip: 'Ganti Peran / Keluar',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Live Cold Chain Fleet Header Card
          Card(
            color: const Color(0xFFE0F7FA),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.ac_unit, color: Color(0xFF00838F), size: 30),
                      SizedBox(width: 10),
                      Text(
                        'Armada Truk Pendingin TPI ➔ Swalayan',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF006064)),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Sistem IoT memantau suhu boks pendingin secara real-time untuk memastikan kesegaran ikan tetap terjaga pada -2°C s/d -4°C selama perjalanan antar-kota.',
                    style: TextStyle(fontSize: 13, color: Color(0xFF004D40)),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          const Text('Daftar Tugas Pengiriman Tugas Kargo', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF006064))),
          const SizedBox(height: 10),

          if (activeOrders.isEmpty)
            const Padding(
              padding: EdgeInsets.all(30.0),
              child: Center(child: Text('Belum ada tugas pengiriman kargo aktif.')),
            ),

          ...activeOrders.map((order) {
            final isCompleted = order.status == OrderStatus.pesananSelesai;

            return Card(
              elevation: 3,
              margin: const EdgeInsets.only(bottom: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(order.id, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00838F), fontSize: 15)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: isCompleted ? Colors.green.shade50 : Colors.cyan.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: isCompleted ? Colors.green : Colors.cyan),
                          ),
                          child: Text(
                            order.statusText,
                            style: TextStyle(fontSize: 11, color: isCompleted ? Colors.green.shade800 : Colors.cyan.shade900, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 4),

                    Text('Tujuan: ${order.buyerName} (${order.buyerCity})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text('Alamat: ${order.deliveryAddress}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    const SizedBox(height: 12),

                    // Live Cold-Chain Temperature Box
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.thermostat, color: Colors.blue, size: 24),
                              const SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Suhu Boks Pendingin IoT', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                  Text(
                                    '${order.coolingBoxTemp.toStringAsFixed(1)}°C — AMAN (Optimal)',
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 13),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          if (!isCompleted)
                            IconButton(
                              icon: const Icon(Icons.refresh, color: Colors.blue),
                              onPressed: () {
                                // Simulate minor temp fluctuation
                                final newTemp = -2.0 - (DateTime.now().second % 3) * 0.2;
                                widget.store.updateCoolingTemperature(order.id, newTemp);
                              },
                              tooltip: 'Refresh Suhu Sensor',
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    if (isCompleted && order.epod != null) ...[
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.verified, color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'E-POD Terverifikasi: Diterima oleh ${order.epod!.receiverName} (${order.epod!.signatureText})',
                                style: const TextStyle(fontSize: 12, color: Colors.green, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF006064),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('Unggah E-POD & Selesaikan Pengiriman'),
                          onPressed: () => _showEpodDialog(order),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
