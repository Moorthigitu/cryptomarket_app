import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cryptomarket/models/coin.dart';
import 'package:cryptomarket/services/coin_repository.dart';
import 'package:cryptomarket/theme/app_theme.dart';
import 'package:cryptomarket/widgets/coin_avatar.dart';
import 'package:cryptomarket/widgets/dominance_bar.dart';
import 'package:cryptomarket/widgets/price_change_badge.dart';
import 'package:cryptomarket/widgets/state_widgets.dart';

class MarketStatsScreen extends StatefulWidget {
  const MarketStatsScreen({super.key});

  @override
  State<MarketStatsScreen> createState() => _MarketStatsScreenState();
}

class _MarketStatsScreenState extends State<MarketStatsScreen> {
  final CoinRepository _repository = CoinRepository.instance;

  MarketStatsData? _stats;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchStats();
  }

  Future<void> _fetchStats() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final stats = await _repository.getMarketStats();
      setState(() {
        _stats = stats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Market Overview',
          style: AppTheme.headingStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppTheme.textPrimary),
            onPressed: _fetchStats,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingStateWidget(itemCount: 4);
    }

    if (_hasError || _stats == null) {
      return ErrorStateWidget(
        title: 'Failed to load market overview',
        onRetry: _fetchStats,
      );
    }

    final stats = _stats!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Market Cap Hero Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.surfaceRaised,
                  AppTheme.surface,
                ],
              ),
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              border: Border.all(color: AppTheme.border, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Market Cap',
                      style: AppTheme.bodyStyle(color: AppTheme.textMuted, fontSize: 13),
                    ),
                    PriceChangeBadge(change: stats.marketCapChange24h, fontSize: 11),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  stats.totalMarketCap,
                  style: AppTheme.monoStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Text(
                  'Market Dominance',
                  style: AppTheme.headingStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                const DominanceBar(),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Top Gainers Section
          _buildSectionHeader(
            title: 'Top Gainers 🚀',
            subtitle: '24h highest percentage gainers',
          ),
          const SizedBox(height: 12),
          ...stats.topGainers.map((coin) => _MoverRow(coin: coin)),

          const SizedBox(height: 28),

          // Top Losers Section
          _buildSectionHeader(
            title: 'Top Losers 📉',
            subtitle: '24h highest percentage decliners',
          ),
          const SizedBox(height: 12),
          ...stats.topLosers.map((coin) => _MoverRow(coin: coin)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required String subtitle}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTheme.headingStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: AppTheme.bodyStyle(fontSize: 12, color: AppTheme.textMuted),
        ),
      ],
    );
  }
}

class _MoverRow extends StatelessWidget {
  final Coin coin;

  const _MoverRow({required this.coin});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: InkWell(
        onTap: () => context.push('/coin/${coin.id}'),
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
              SizedBox(
                width: 24,
                child: Text(
                  '#${coin.rank}',
                  style: AppTheme.monoStyle(fontSize: 12, color: AppTheme.textMuted),
                ),
              ),
              const SizedBox(width: 8),
              CoinAvatar(symbol: coin.symbol, radius: 16),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coin.name,
                      style: AppTheme.headingStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      coin.symbol,
                      style: AppTheme.bodyStyle(fontSize: 11, color: AppTheme.textMuted),
                    ),
                  ],
                ),
              ),
              PriceChangeBadge(change: coin.change24h, fontSize: 12),
            ],
          ),
        ),
      ),
    );
  }
}
