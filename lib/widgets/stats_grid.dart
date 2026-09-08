import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cryptomarket/models/coin.dart';
import 'package:cryptomarket/theme/app_theme.dart';

class StatsGrid extends StatelessWidget {
  final Coin coin;

  const StatsGrid({
    super.key,
    required this.coin,
  });

  String _formatPrice(double value) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: value < 1.0 ? 4 : 2);
    return formatter.format(value);
  }

  @override
  Widget build(BuildContext context) {
    final stats = [
      {'label': 'Market Cap', 'value': coin.marketCap},
      {'label': '24h Volume', 'value': coin.volume24h},
      {'label': 'Circulating Supply', 'value': coin.circulatingSupply},
      {'label': 'All-Time High', 'value': _formatPrice(coin.allTimeHigh)},
    ];

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: stats.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.2,
      ),
      itemBuilder: (context, index) {
        final stat = stats[index];
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
            border: Border.all(color: AppTheme.border, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                stat['label']!,
                style: AppTheme.bodyStyle(
                  fontSize: 12,
                  color: AppTheme.textMuted,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                stat['value']!,
                style: AppTheme.monoStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        );
      },
    );
  }
}
