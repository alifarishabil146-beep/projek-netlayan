import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class FreshnessChip extends StatelessWidget {
  final int freshnessScore;
  final String catchHoursAgo;

  const FreshnessChip({
    super.key,
    required this.freshnessScore,
    required this.catchHoursAgo,
  });

  @override
  Widget build(BuildContext context) {
    // Sesuai aturan: background hijau muda (Sea Green alpha 12%), teks & ikon Sea Green (#2E9E6B)
    final Color seaGreen = AppColors.successSeaGreen;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: seaGreen.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: seaGreen.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.eco, size: 12, color: seaGreen),
          const SizedBox(width: 4),
          Text(
            'Kesegaran: $freshnessScore% • $catchHoursAgo',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: seaGreen,
            ),
          ),
        ],
      ),
    );
  }
}
