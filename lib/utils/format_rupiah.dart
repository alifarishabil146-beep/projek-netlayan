import 'package:intl/intl.dart';

/// Fungsi utilitas untuk memformat angka menjadi mata uang Rupiah dengan pemisah ribuan (tanpa desimal).
/// Contoh: 35000 -> "Rp 35.000"
String formatRupiah(num angka) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return formatter.format(angka);
}
