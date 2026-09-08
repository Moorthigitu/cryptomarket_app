import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cryptomarket/models/coin.dart';
import 'package:cryptomarket/services/coin_repository.dart';
import 'package:cryptomarket/theme/app_theme.dart';
import 'package:cryptomarket/widgets/coin_list_tile.dart';
import 'package:cryptomarket/widgets/filter_chips_row.dart';
import 'package:cryptomarket/widgets/search_bar_widget.dart';
import 'package:cryptomarket/widgets/state_widgets.dart';

class CoinListScreen extends StatefulWidget {
  const CoinListScreen({super.key});

  @override
  State<CoinListScreen> createState() => _CoinListScreenState();
}

class _CoinListScreenState extends State<CoinListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final CoinRepository _repository = CoinRepository.instance;

  List<Coin> _coins = [];
  String _selectedFilter = 'All';
  ViewState _viewState = ViewState.loading;
  bool _isManualStateOverride = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
    _loadCoins();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    _loadCoins();
  }

  Future<void> _loadCoins() async {
    if (_isManualStateOverride) return;

    setState(() {
      _viewState = ViewState.loading;
    });

    try {
      final coins = await _repository.getCoins(
        search: _searchController.text.trim(),
        filter: _selectedFilter,
      );

      setState(() {
        _coins = coins;
        _viewState = coins.isEmpty ? ViewState.empty : ViewState.success;
      });
    } catch (e) {
      setState(() {
        _viewState = ViewState.error;
      });
    }
  }

  void _cycleViewState() {
    setState(() {
      _isManualStateOverride = true;
      switch (_viewState) {
        case ViewState.success:
          _viewState = ViewState.loading;
          break;
        case ViewState.loading:
          _viewState = ViewState.error;
          break;
        case ViewState.error:
          _viewState = ViewState.empty;
          break;
        case ViewState.empty:
          _viewState = ViewState.success;
          _isManualStateOverride = false;
          _loadCoins();
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Markets',
          style: AppTheme.headingStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh_rounded,
              color: AppTheme.textPrimary,
            ),
            onPressed: () {
              _isManualStateOverride = false;
              _loadCoins();
            },
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: _cycleViewState,
      //   backgroundColor: AppTheme.surfaceRaised,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(AppTheme.pillRadius),
      //     side: const BorderSide(color: AppTheme.accentGold, width: 1),
      //   ),
      //   icon: const Icon(
      //     Icons.swap_horizontal_circle_outlined,
      //     color: AppTheme.accentGold,
      //     size: 18,
      //   ),
      //   label: Text(
      //     'State: ${_viewState.name.toUpperCase()}',
      //     style: AppTheme.monoStyle(fontSize: 11, color: AppTheme.accentGold),
      //   ),
      // ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: SearchBarWidget(
              controller: _searchController,
              onClear: () {
                _searchController.clear();
                _loadCoins();
              },
            ),
          ),
          // Filter Chips
          FilterChipsRow(
            selectedFilter: _selectedFilter,
            onFilterSelected: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
              _loadCoins();
            },
          ),
          const SizedBox(height: 12),
          // Sort Header Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'NAME',
                  style: AppTheme.monoStyle(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'PRICE · 24H%',
                  style: AppTheme.monoStyle(
                    fontSize: 11,
                    color: AppTheme.textMuted,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Divider(color: AppTheme.border, height: 1),
          // Dynamic Body
          Expanded(
            child: RefreshIndicator(
              color: AppTheme.accentGold,
              backgroundColor: AppTheme.surfaceRaised,
              onRefresh: () async {
                _isManualStateOverride = false;
                await _loadCoins();
              },
              child: _buildBodyState(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyState() {
    switch (_viewState) {
      case ViewState.loading:
        return const LoadingStateWidget(itemCount: 7);
      case ViewState.error:
        return ErrorStateWidget(
          onRetry: () {
            _isManualStateOverride = false;
            _loadCoins();
          },
        );
      case ViewState.empty:
        return EmptyStateWidget(
          icon: Icons.filter_alt_off_rounded,
          title: 'No Matching Coins',
          message: _searchController.text.isNotEmpty
              ? 'No crypto matching "${_searchController.text}".'
              : 'No coins fit the active filter "$_selectedFilter".',
          buttonText: 'Reset Filters',
          onAction: () {
            _searchController.clear();
            setState(() {
              _selectedFilter = 'All';
              _isManualStateOverride = false;
            });
            _loadCoins();
          },
        );
      case ViewState.success:
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          itemCount: _coins.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final coin = _coins[index];
            return CoinListTile(
              coin: coin,
              onTap: () {
                context.push('/coin/${coin.id}');
              },
            );
          },
        );
    }
  }
}
