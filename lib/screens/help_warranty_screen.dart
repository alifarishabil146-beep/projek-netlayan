import 'package:flutter/material.dart';
import '../models/netlayan_models.dart';
import '../providers/netlayan_store.dart';
import '../utils/format_rupiah.dart';

class HelpWarrantyScreen extends StatefulWidget {
  final NetlayanStore store;

  const HelpWarrantyScreen({super.key, required this.store});

  @override
  State<HelpWarrantyScreen> createState() => _HelpWarrantyScreenState();
}

class _HelpWarrantyScreenState extends State<HelpWarrantyScreen> {
  void _showNewComplaintDialog() {
    final descCtrl = TextEditingController();
    String selectedIssue = 'Ikan tidak segar / bau';
    final issues = [
      'Ikan tidak segar / bau',
      'Timbangan kurang dari pesanan',
      'Jenis ikan tidak sesuai pesanan',
      'Keterlambatan pengiriman parah',
    ];

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
                      'Klaim Garansi & Komplain Cepat',
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

                const Text(
                  'Garansi Kesegaran 100% atau Uang Kembali. Pilih kendala pesanan Anda:',
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: selectedIssue,
                  decoration: const InputDecoration(
                    labelText: 'Jenis Kendala / Masalah',
                    prefixIcon: Icon(Icons.report_problem, color: Color(0xFF005B96)),
                    border: OutlineInputBorder(),
                  ),
                  items: issues.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        selectedIssue = val;
                      });
                    }
                  },
                ),
                const SizedBox(height: 12),

                TextField(
                  controller: descCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi Detail & Bukti (Opsional)',
                    hintText: 'Jelaskan kondisi ikan saat diterima...',
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
                      if (descCtrl.text.trim().isEmpty) return;

                      final complaint = ComplaintModel(
                        id: 'comp_${DateTime.now().millisecondsSinceEpoch}',
                        orderId: 'ORD-LATEST',
                        buyerId: widget.store.currentUser?.id ?? 'pembeli_01',
                        buyerName: widget.store.currentUser?.name ?? 'Pembeli',
                        issueType: selectedIssue,
                        description: descCtrl.text.trim(),
                        status: ComplaintStatus.menungguVerifikasi,
                        claimDate: DateTime.now(),
                        refundAmount: 50000,
                      );

                      widget.store.submitComplaint(complaint);
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Klaim garansi berhasil diajukan! Tim support akan merespons dalam 15 menit.'),
                          backgroundColor: Color(0xFF005B96),
                        ),
                      );
                    },
                    child: const Text('Ajukan Klaim Garansi & Refund', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
    final complaints = widget.store.complaints;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pusat Bantuan & Garansi Kesegaran'),
        backgroundColor: const Color(0xFF005B96),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner Garansi Kesegaran
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
                        Icon(Icons.verified, color: Color(0xFF005B96), size: 30),
                        SizedBox(width: 10),
                        Text(
                          'Garansi 100% Segar & Uang Kembali',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF005B96)),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'NETLAYAN menjamin kualitas kesegaran ikan, ketepatan waktu pengiriman cold-chain, dan kejujuran timbangan nelayan. Jika pesanan Anda tidak sesuai, ajukan klaim garansi dalam 1x24 jam untuk refund instan.',
                      style: TextStyle(fontSize: 13, color: Color(0xFF6A1B9A)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Daftar Klaim Garansi & Komplain', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF005B96))),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005B96),
                    foregroundColor: Colors.white,
                  ),
                  icon: const Icon(Icons.add_alert, size: 18),
                  label: const Text('Komplain / Klaim'),
                  onPressed: _showNewComplaintDialog,
                ),
              ],
            ),
            const SizedBox(height: 12),

            if (complaints.isEmpty)
              const Padding(
                padding: EdgeInsets.all(30.0),
                child: Center(child: Text('Belum ada klaim garansi atau komplain aktif.')),
              ),

            ...complaints.map((comp) {
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
                          Text(comp.issueType, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              comp.statusText,
                              style: const TextStyle(fontSize: 11, color: Color(0xFF00A8CC), fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(comp.description, style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Tanggal: ${comp.claimDate.day}/${comp.claimDate.month}/${comp.claimDate.year}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                          Text('Estimasi Refund: ${formatRupiah(comp.refundAmount)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),

            const Text('FAQ / Pertanyaan Umum', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF005B96))),
            const SizedBox(height: 8),
            _buildFaqItem('Bagaimana cara kerja Garansi Kesegaran?', 'Jika ikan diterima dalam keadaan tidak segar atau bau busuk, foto ikan tersebut dan ajukan klaim garansi dalam waktu 1x24 jam. Tim kami akan memverifikasi dan memproses refund instan.'),
            _buildFaqItem('Apakah timbangan nelayan dijamin jujur?', 'Ya, seluruh nelayan di Netlayan terikat standar HET Kementerian Perdagangan dan diverifikasi timbangannya di Pelabuhan TPI.'),
            _buildFaqItem('Berapa lama proses pencairan dana refund?', 'Refund akan dikembalikan ke saldo dompet digital atau metode pembayaran Anda dalam waktu 1-2 jam setelah disetujui.'),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF005B96))),
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(answer, style: const TextStyle(fontSize: 13, color: Colors.black87)),
        ),
      ],
    );
  }
}
