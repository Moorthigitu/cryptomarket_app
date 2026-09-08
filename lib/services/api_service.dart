import 'package:dio/dio.dart';
import 'package:cryptomarket/models/coin.dart';

class ApiService {
  final Dio _dio;

  // Base URL pointing to local FastAPI server
  static const String defaultBaseUrl = 'http://127.0.0.1:8000';

  ApiService({Dio? dioCustom})
      : _dio = dioCustom ??
            Dio(
              BaseOptions(
                baseUrl: defaultBaseUrl,
                connectTimeout: const Duration(seconds: 4),
                receiveTimeout: const Duration(seconds: 4),
                headers: {'Content-Type': 'application/json'},
              ),
            );

  Future<List<Coin>> fetchCoins({String? search}) async {
    try {
      final response = await _dio.get(
        '/api/coins',
        queryParameters: search != null && search.isNotEmpty ? {'search': search} : null,
      );

      if (response.statusCode == 200 && response.data is List) {
        final list = response.data as List;
        return list.map((item) => Coin.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (e) {
      // DioException or connection error -> fallback to mock dataset
    }

    // Local filter fallback
    List<Coin> mock = MockData.mockCoins;
    if (search != null && search.isNotEmpty) {
      final q = search.toLowerCase();
      mock = mock.where((c) => c.name.toLowerCase().contains(q) || c.symbol.toLowerCase().contains(q)).toList();
    }
    return mock;
  }

  Future<Coin> fetchCoinDetail(String coinId, {String range = '1D'}) async {
    try {
      final response = await _dio.get('/api/coins/$coinId', queryParameters: {'range': range});

      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        return Coin.fromJson(response.data as Map<String, dynamic>);
      }
    } catch (e) {
      // DioException -> fallback to local mock
    }

    final found = MockData.mockCoins.firstWhere(
      (c) => c.id.toLowerCase() == coinId.toLowerCase() || c.symbol.toLowerCase() == coinId.toLowerCase(),
      orElse: () => MockData.mockCoins.first,
    );
    return found;
  }

  Future<MarketStatsData> fetchMarketStats() async {
    try {
      final response = await _dio.get('/api/market/stats');
      if (response.statusCode == 200 && response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        final gainersList = (data['topGainers'] as List? ?? [])
            .map((item) => Coin.fromJson(item as Map<String, dynamic>))
            .toList();
        final losersList = (data['topLosers'] as List? ?? [])
            .map((item) => Coin.fromJson(item as Map<String, dynamic>))
            .toList();

        return MarketStatsData(
          totalMarketCap: data['totalMarketCap']?.toString() ?? '\$2.42 Trillion',
          marketCapChange24h: (data['marketCapChange24h'] as num?)?.toDouble() ?? 3.45,
          topGainers: gainersList.isNotEmpty ? gainersList : MockData.mockCoins.take(3).toList(),
          topLosers: losersList.isNotEmpty ? losersList : MockData.mockCoins.reversed.take(2).toList(),
        );
      }
    } catch (e) {
      // DioException -> fallback
    }

    final all = MockData.mockCoins;
    final gainers = List<Coin>.from(all)..sort((a, b) => b.change24h.compareTo(a.change24h));
    final losers = List<Coin>.from(all)..sort((a, b) => a.change24h.compareTo(b.change24h));

    return MarketStatsData(
      totalMarketCap: '\$2.42 Trillion',
      marketCapChange24h: 3.45,
      topGainers: gainers.take(3).toList(),
      topLosers: losers.take(2).toList(),
    );
  }
}
