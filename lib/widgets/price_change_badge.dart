import 'package:flutter/material.dart';
import 'package:cryptomarket/theme/app_theme.dart';

class PriceChangeBadge extends StatelessWidget {
  final double change;
  final double fontSize;
  final EdgeInsetsGeometry padding;

  const PriceChangeBadge({
    super.key,
    required this.change,
    this.fontSize = 12.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = change >= 0;
    final bgTint = isPositive ? AppTheme.gainBgTint : AppTheme.lossBgTint;
    final textCol = isPositive ? AppTheme.gainGreen : AppTheme.lossRed;
    final iconStr = isPositive ? '▲' : '▼';
    final signStr = isPositive ? '+' : '';
    final formattedValue = '$iconStr $signStr${change.toStringAsFixed(2)}%';

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bgTint,
        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
        border: Border.all(color: textCol.withValues(alpha: 0.3), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            formattedValue,
            style: AppTheme.monoStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: textCol,
            ),
          ),
        ],
      ),
    );
  }
}
