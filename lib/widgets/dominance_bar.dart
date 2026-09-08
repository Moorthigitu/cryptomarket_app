import 'package:flutter/material.dart';
import 'package:cryptomarket/theme/app_theme.dart';

class DominanceSegment {
  final String label;
  final double percentage;
  final Color color;

  const DominanceSegment({
    required this.label,
    required this.percentage,
    required this.color,
  });
}

class DominanceBar extends StatelessWidget {
  final List<DominanceSegment> segments;

  const DominanceBar({
    super.key,
    this.segments = const [
      DominanceSegment(label: 'BTC', percentage: 54.2, color: Color(0xFFF7931A)),
      DominanceSegment(label: 'ETH', percentage: 16.8, color: Color(0xFF627EEA)),
      DominanceSegment(label: 'Others', percentage: 29.0, color: Color(0xFF2FB88A)),
    ],
  });

  @override
  Widget build(BuildContext context) {
    final total = segments.fold<double>(0, (sum, s) => sum + s.percentage);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Horizontal Segmented Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(AppTheme.pillRadius),
          child: SizedBox(
            height: 10,
            child: Row(
              children: segments.map((seg) {
                final flex = ((seg.percentage / total) * 1000).toInt();
                return Expanded(
                  flex: flex > 0 ? flex : 1,
                  child: Container(color: seg.color),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Legend Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: segments.map((seg) {
            return Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: seg.color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  seg.label,
                  style: AppTheme.bodyStyle(fontSize: 12, color: AppTheme.textMuted),
                ),
                const SizedBox(width: 4),
                Text(
                  '${seg.percentage.toStringAsFixed(1)}%',
                  style: AppTheme.monoStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
