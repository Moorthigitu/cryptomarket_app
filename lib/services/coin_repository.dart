import 'package:cryptomarket/models/coin.dart';
import 'package:cryptomarket/services/api_service.dart';

class CoinRepository {
  static final CoinRepository instance = CoinRepository._internal();
  CoinRepository._internal();

  final ApiService _apiService = ApiService();
  final Set<String> _starredCoinIds = {'bitcoin', 'ethereum', 'binancecoin', 'btc', 'eth', 'bnb'};

  Future<List<Coin>> getCoins({String? search, String filter = 'All'}) async {
    final coins = await _apiService.fetchCoins(search: search);

    // Synchronize isStarred state
    for (var c in coins) {
      if (_starredCoinIds.contains(c.id.toLowerCase()) || _starredCoinIds.contains(c.symbol.toLowerCase())) {
        c.isStarred = true;
      }
    }

    // Apply filter
    List<Coin> result = List.from(coins);
    if (filter == 'Gainers') {
      result = result.where((c) => c.change24h > 0).toList();
    } else if (filter == 'Losers') {
      result = result.where((c) => c.change24h < 0).toList();
    } else if (filter == 'Top Volume') {
      result.sort((a, b) => b.price.compareTo(a.price));
    }

    return result;
  }

  Future<Coin> getCoinDetail(String coinId, {String range = '1D'}) async {
    final coin = await _apiService.fetchCoinDetail(coinId, range: range);
    if (_starredCoinIds.contains(coin.id.toLowerCase()) || _starredCoinIds.contains(coin.symbol.toLowerCase())) {
      coin.isStarred = true;
    }
    return coin;
  }

  Future<MarketStatsData> getMarketStats() async {
    return await _apiService.fetchMarketStats();
  }

  Future<List<Coin>> getWatchlistCoins() async {
    final all = await _apiService.fetchCoins();
    final watchlist = all.where((c) => _starredCoinIds.contains(c.id.toLowerCase()) || _starredCoinIds.contains(c.symbol.toLowerCase())).toList();
    for (var c in watchlist) {
      c.isStarred = true;
    }
    return watchlist;
  }

  void toggleStar(Coin coin) {
    coin.isStarred = !coin.isStarred;
    if (coin.isStarred) {
      _starredCoinIds.add(coin.id.toLowerCase());
      _starredCoinIds.add(coin.symbol.toLowerCase());
    } else {
      _starredCoinIds.remove(coin.id.toLowerCase());
      _starredCoinIds.remove(coin.symbol.toLowerCase());
    }
  }

  bool isStarred(String idOrSymbol) {
    return _starredCoinIds.contains(idOrSymbol.toLowerCase());
  }
}
