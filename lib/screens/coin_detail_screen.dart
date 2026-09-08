import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cryptomarket/models/coin.dart';
import 'package:cryptomarket/services/coin_repository.dart';
import 'package:cryptomarket/theme/app_theme.dart';
import 'package:cryptomarket/widgets/coin_avatar.dart';
import 'package:cryptomarket/widgets/price_change_badge.dart';
import 'package:cryptomarket/widgets/price_chart.dart';
import 'package:cryptomarket/widgets/state_widgets.dart';
import 'package:cryptomarket/widgets/stats_grid.dart';

class CoinDetailScreen extends StatefulWidget {
  final String coinId;

  const CoinDetailScreen({
    super.key,
    required this.coinId,
  });

  @override
  State<CoinDetailScreen> createState() => _CoinDetailScreenState();
}

class _CoinDetailScreenState extends State<CoinDetailScreen> {
  final CoinRepository _repository = CoinRepository.instance;
  
  Coin? _coin;
  String _selectedRange = '1D';
  bool _isLoading = true;
  bool _hasError = false;
  bool _isStarred = false;

  final List<String> _ranges = ['1H', '1D', '1W', '1M', '1Y'];

  @override
  void initState() {
    super.initState();
    _fetchDetail();
  }

  Future<void> _fetchDetail() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final coin = await _repository.getCoinDetail(widget.coinId, range: _selectedRange);
      setState(() {
        _coin = coin;
        _isStarred = coin.isStarred;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  String _formatPrice(double price) {
    final formatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: price < 1.0 ? 4 : 2,
    );
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textPrimary, size: 20),
            onPressed: () => context.pop(),
          ),
          title: Text('Loading...', style: AppTheme.headingStyle(fontSize: 18)),
        ),
        body: const LoadingStateWidget(itemCount: 4),
      );
    }

    if (_hasError || _coin == null) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textPrimary, size: 20),
            onPressed: () => context.pop(),
          ),
        ),
        body: ErrorStateWidget(
          title: 'Failed to load coin details',
          onRetry: _fetchDetail,
        ),
      );
    }

    final coin = _coin!;
    final chartPoints = coin.rangeData[_selectedRange] ?? coin.sparklinePoints;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppTheme.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          '${coin.symbol} / USD',
          style: AppTheme.headingStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isStarred ? Icons.star_rounded : Icons.star_outline_rounded,
              color: _isStarred ? AppTheme.accentGold : AppTheme.textPrimary,
              size: 24,
            ),
            onPressed: () {
              setState(() {
                _repository.toggleStar(coin);
                _isStarred = coin.isStarred;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppTheme.surfaceRaised,
                  content: Text(
                    _isStarred ? 'Added ${coin.name} to Watchlist' : 'Removed ${coin.name} from Watchlist',
                    style: AppTheme.bodyStyle(color: AppTheme.textPrimary),
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Coin Hero Section
                    Row(
                      children: [
                        CoinAvatar(symbol: coin.symbol, radius: 18),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coin.name,
                              style: AppTheme.headingStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Rank #${coin.rank}',
                              style: AppTheme.bodyStyle(fontSize: 12, color: AppTheme.textMuted),
                            ),
                          ],
                        ),
                        const Spacer(),
                        PriceChangeBadge(change: coin.change24h, fontSize: 13),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _formatPrice(coin.price),
                      style: AppTheme.monoStyle(fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    // Range Tabs Row (1H / 1D / 1W / 1M / 1Y)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(AppTheme.pillRadius),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _ranges.map((range) {
                          final isSelected = range == _selectedRange;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (_selectedRange != range) {
                                  setState(() {
                                    _selectedRange = range;
                                  });
                                  _fetchDetail();
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppTheme.accentGold : Colors.transparent,
                                  borderRadius: BorderRadius.circular(AppTheme.pillRadius),
                                ),
                                child: Center(
                                  child: Text(
                                    range,
                                    style: AppTheme.bodyStyle(
                                      fontSize: 13,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                      color: isSelected ? Colors.black : AppTheme.textMuted,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Interactive Price Chart
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: AppTheme.surface,
                        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                        border: Border.all(color: AppTheme.border),
                      ),
                      child: PriceChart(
                        dataPoints: chartPoints,
                        currentRange: _selectedRange,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Stats Grid (2x2)
                    Text(
                      'Market Statistics',
                      style: AppTheme.headingStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    StatsGrid(coin: coin),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom CTA Row
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppTheme.surface,
                border: Border(top: BorderSide(color: AppTheme.border, width: 1)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: AppTheme.surfaceRaised,
                            content: Text(
                              'Price alert created for ${coin.symbol}',
                              style: AppTheme.bodyStyle(color: AppTheme.textPrimary),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.notifications_active_outlined, size: 18),
                      label: const Text('Set Alert'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.accentGold, width: 1.5),
                        foregroundColor: AppTheme.accentGold,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.pillRadius),
                        ),
                        textStyle: AppTheme.bodyStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _repository.toggleStar(coin);
                          _isStarred = coin.isStarred;
                        });
                      },
                      icon: Icon(
                        _isStarred ? Icons.star_rounded : Icons.star_outline_rounded,
                        size: 18,
                        color: Colors.black,
                      ),
                      label: Text(_isStarred ? 'In Watchlist' : 'Add Watchlist'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentGold,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.pillRadius),
                        ),
                        textStyle: AppTheme.bodyStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
