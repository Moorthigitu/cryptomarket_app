import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cryptomarket/screens/coin_detail_screen.dart';
import 'package:cryptomarket/screens/coin_list_screen.dart';
import 'package:cryptomarket/screens/market_stats_screen.dart';
import 'package:cryptomarket/screens/settings_screen.dart';
import 'package:cryptomarket/screens/watchlist_screen.dart';
import 'package:cryptomarket/theme/app_theme.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

class AppShellScaffold extends StatelessWidget {
  final Widget child;

  const AppShellScaffold({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/watchlist')) {
      return 1;
    }
    if (location.startsWith('/stats')) {
      return 2;
    }
    if (location.startsWith('/settings')) {
      return 3;
    }
    if (location == '/') {
      return 0;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/watchlist');
        break;
      case 2:
        context.go('/stats');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppTheme.border, width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          onTap: (index) => _onItemTapped(index, context),
          selectedItemColor: AppTheme.accentGold,
          unselectedItemColor: AppTheme.textMuted,
          backgroundColor: AppTheme.surface,
          type: BottomNavigationBarType.fixed,
          selectedLabelStyle: AppTheme.bodyStyle(fontSize: 11, fontWeight: FontWeight.bold),
          unselectedLabelStyle: AppTheme.bodyStyle(fontSize: 11),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart_rounded),
              activeIcon: Icon(Icons.show_chart_rounded, color: AppTheme.accentGold),
              label: 'Markets',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.star_outline_rounded),
              activeIcon: Icon(Icons.star_rounded, color: AppTheme.accentGold),
              label: 'Watchlist',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart_outline_rounded),
              activeIcon: Icon(Icons.pie_chart_rounded, color: AppTheme.accentGold),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings_rounded, color: AppTheme.accentGold),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => AppShellScaffold(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const CoinListScreen(),
        ),
        GoRoute(
          path: '/watchlist',
          builder: (context, state) => const WatchlistScreen(),
        ),
        GoRoute(
          path: '/stats',
          builder: (context, state) => const MarketStatsScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/coin/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final coinId = state.pathParameters['id'] ?? 'btc';
        return CoinDetailScreen(coinId: coinId);
      },
    ),
  ],
);
