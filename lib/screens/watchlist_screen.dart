import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cryptomarket/models/coin.dart';
import 'package:cryptomarket/services/coin_repository.dart';
import 'package:cryptomarket/theme/app_theme.dart';
import 'package:cryptomarket/widgets/coin_list_tile.dart';
import 'package:cryptomarket/widgets/state_widgets.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  final CoinRepository _repository = CoinRepository.instance;

  List<Coin> _watchlistCoins = [];
  bool _isLoading = true;
  bool _forceEmptyDemo = false;

  @override
  void initState() {
    super.initState();
    _loadWatchlist();
  }

  Future<void> _loadWatchlist() async {
    setState(() {
      _isLoading = true;
    });

    final list = await _repository.getWatchlistCoins();

    setState(() {
      _watchlistCoins = list;
      _isLoading = false;
    });
  }

  void _toggleStar(Coin coin) {
    setState(() {
      _repository.toggleStar(coin);
      _loadWatchlist();
    });
  }

  @override
  Widget build(BuildContext context) {
    final showEmpty = _forceEmptyDemo || _watchlistCoins.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Watchlist',
          style: AppTheme.headingStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          // Demo Toggle Button for Empty State vs Populated
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton.icon(
              onPressed: () {
                setState(() {
                  _forceEmptyDemo = !_forceEmptyDemo;
                });
              },
              icon: Icon(
                _forceEmptyDemo ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                size: 16,
                color: AppTheme.accentGold,
              ),
              label: Text(
                _forceEmptyDemo ? 'Show Items' : 'Demo Empty',
                style: AppTheme.monoStyle(fontSize: 11, color: AppTheme.accentGold),
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const LoadingStateWidget(itemCount: 4)
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: showEmpty
                  ? _EmptyWatchlistState(onResetDemo: () async {
                      setState(() {
                        _forceEmptyDemo = false;
                      });
                      final all = await _repository.getCoins();
                      if (all.isNotEmpty) {
                        _repository.toggleStar(all.first);
                        if (all.length > 1) _repository.toggleStar(all[1]);
                      }
                      _loadWatchlist();
                    })
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${_watchlistCoins.length} Pinned Assets',
                          style: AppTheme.bodyStyle(color: AppTheme.textMuted, fontSize: 13),
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.separated(
                            itemCount: _watchlistCoins.length,
                            separatorBuilder: (_, __) => const SizedBox(height: 10),
                            itemBuilder: (context, index) {
                              final coin = _watchlistCoins[index];
                              return CoinListTile(
                                coin: coin,
                                showStarIcon: true,
                                onStarTap: () => _toggleStar(coin),
                                onTap: () => context.push('/coin/${coin.id}'),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }
}

class _EmptyWatchlistState extends StatelessWidget {
  final VoidCallback onResetDemo;

  const _EmptyWatchlistState({required this.onResetDemo});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Dashed border icon badge
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: AppTheme.surface,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.accentGold.withValues(alpha: 0.5),
                  width: 1.5,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.star_border_rounded,
                  size: 46,
                  color: AppTheme.accentGold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Your Watchlist is Empty',
              style: AppTheme.headingStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Tap the star icon on any coin\'s detail screen to pin it here for quick tracking.',
              style: AppTheme.bodyStyle(color: AppTheme.textMuted, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            OutlinedButton.icon(
              onPressed: onResetDemo,
              icon: const Icon(Icons.star_rounded, size: 18),
              label: const Text('Pin Default Assets'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppTheme.accentGold),
                foregroundColor: AppTheme.accentGold,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.pillRadius),
                ),
                textStyle: AppTheme.bodyStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
