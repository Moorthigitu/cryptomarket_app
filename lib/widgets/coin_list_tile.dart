import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:cryptomarket/models/coin.dart';
import 'package:cryptomarket/theme/app_theme.dart';
import 'package:cryptomarket/widgets/coin_avatar.dart';
import 'package:cryptomarket/widgets/price_change_badge.dart';

class CoinListTile extends StatelessWidget {
  final Coin coin;
  final VoidCallback? onTap;
  final bool showSparkline;
  final bool showStarIcon;
  final VoidCallback? onStarTap;

  const CoinListTile({
    super.key,
    required this.coin,
    this.onTap,
    this.showSparkline = true,
    this.showStarIcon = false,
    this.onStarTap,
  });

  String _formatPrice(double price) {
    final formatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: price < 1.0 ? 4 : 2,
    );
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    final isPositive = coin.change24h >= 0;
    final sparklineColor = isPositive ? AppTheme.gainGreen : AppTheme.lossRed;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          border: Border.all(color: AppTheme.border, width: 1),
        ),
        child: Row(
          children: [
            if (showStarIcon) ...[
              GestureDetector(
                onTap: onStarTap,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: Icon(
                    coin.isStarred ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: coin.isStarred ? AppTheme.accentGold : AppTheme.textFaint,
                    size: 22,
                  ),
                ),
              ),
            ],
            CoinAvatar(symbol: coin.symbol, radius: 20),
            const SizedBox(width: 12),
            // Symbol + Name Stack
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        coin.symbol,
                        style: AppTheme.headingStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceRaised,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '#${coin.rank}',
                          style: AppTheme.monoStyle(fontSize: 10, color: AppTheme.textMuted),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    coin.name,
                    style: AppTheme.bodyStyle(fontSize: 12, color: AppTheme.textMuted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Sparkline Chart (if enabled)
            if (showSparkline && coin.sparklinePoints.isNotEmpty) ...[
              SizedBox(
                width: 60,
                height: 28,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineTouchData: const LineTouchData(enabled: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: coin.sparklinePoints
                            .asMap()
                            .entries
                            .map((e) => FlSpot(e.key.toDouble(), e.value))
                            .toList(),
                        isCurved: true,
                        color: sparklineColor,
                        barWidth: 1.8,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: sparklineColor.withValues(alpha: 0.12),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 14),
            ],
            // Price + % Change Stack
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatPrice(coin.price),
                  style: AppTheme.monoStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3),
                PriceChangeBadge(
                  change: coin.change24h,
                  fontSize: 11,
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
