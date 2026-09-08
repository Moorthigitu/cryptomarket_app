import 'package:flutter/material.dart';
import 'package:cryptomarket/theme/app_theme.dart';

class CoinAvatar extends StatelessWidget {
  final String symbol;
  final double radius;

  const CoinAvatar({
    super.key,
    required this.symbol,
    this.radius = 20.0,
  });

  Color _getBgColor(String sym) {
    switch (sym.toUpperCase()) {
      case 'BTC':
        return const Color(0xFFF7931A);
      case 'ETH':
        return const Color(0xFF627EEA);
      case 'SOL':
        return const Color(0xFF14F195);
      case 'USDT':
        return const Color(0xFF26A17B);
      case 'BNB':
        return const Color(0xFFF3BA2F);
      case 'XRP':
        return const Color(0xFF23292F);
      case 'ADA':
        return const Color(0xFF0033AD);
      case 'DOGE':
        return const Color(0xFFC2A633);
      default:
        return AppTheme.surfaceRaised;
    }
  }

  Color _getTextColor(String sym) {
    if (sym.toUpperCase() == 'SOL' || sym.toUpperCase() == 'BNB' || sym.toUpperCase() == 'DOGE') {
      return Colors.black;
    }
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final bg = _getBgColor(symbol);
    final textCol = _getTextColor(symbol);
    final initial = symbol.isNotEmpty ? symbol[0] : '?';

    return CircleAvatar(
      radius: radius,
      backgroundColor: bg,
      child: Text(
        initial,
        style: AppTheme.headingStyle(
          fontSize: radius * 0.9,
          fontWeight: FontWeight.bold,
          color: textCol,
        ),
      ),
    );
  }
}
