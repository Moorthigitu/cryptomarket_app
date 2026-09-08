import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:cryptomarket/theme/app_theme.dart';

class PriceChart extends StatefulWidget {
  final List<double> dataPoints;
  final String currentRange;

  const PriceChart({
    super.key,
    required this.dataPoints,
    required this.currentRange,
  });

  @override
  State<PriceChart> createState() => _PriceChartState();
}

class _PriceChartState extends State<PriceChart> {
  int? touchedIndex;

  String _formatPrice(double value) {
    final formatter = NumberFormat.currency(symbol: '\$', decimalDigits: value < 1.0 ? 4 : 2);
    return formatter.format(value);
  }

  String _getTimeLabel(int index, int total) {
    final now = DateTime.now();
    DateTime time;
    switch (widget.currentRange) {
      case '1H':
        time = now.subtract(Duration(minutes: (total - index - 1) * 10));
        return DateFormat('HH:mm').format(time);
      case '1D':
        time = now.subtract(Duration(hours: (total - index - 1) * 4));
        return DateFormat('HH:mm').format(time);
      case '1W':
        time = now.subtract(Duration(days: (total - index - 1)));
        return DateFormat('EEE d').format(time);
      case '1M':
        time = now.subtract(Duration(days: (total - index - 1) * 5));
        return DateFormat('MMM d').format(time);
      case '1Y':
        time = now.subtract(Duration(days: (total - index - 1) * 60));
        return DateFormat('MMM yyyy').format(time);
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.dataPoints.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(child: Text('No price chart data', style: TextStyle(color: AppTheme.textMuted))),
      );
    }

    final minY = widget.dataPoints.reduce((a, b) => a < b ? a : b);
    final maxY = widget.dataPoints.reduce((a, b) => a > b ? a : b);
    final paddingY = (maxY - minY) * 0.15 == 0 ? 1.0 : (maxY - minY) * 0.15;

    final spots = widget.dataPoints
        .asMap()
        .entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();

    final activeIndex = touchedIndex ?? (spots.length - 1);
    final activePrice = widget.dataPoints[activeIndex];
    final activeTime = _getTimeLabel(activeIndex, widget.dataPoints.length);

    return Column(
      children: [
        // Interactive Header Info display
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatPrice(activePrice),
                    style: AppTheme.monoStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    activeTime,
                    style: AppTheme.bodyStyle(fontSize: 12, color: AppTheme.textMuted),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceRaised,
                  borderRadius: BorderRadius.circular(AppTheme.pillRadius),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Text(
                  'Range: ${widget.currentRange}',
                  style: AppTheme.monoStyle(fontSize: 11, color: AppTheme.accentGold),
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Chart Area
        SizedBox(
          height: 220,
          child: LineChart(
            LineChartData(
              minY: minY - paddingY,
              maxY: maxY + paddingY,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: ((maxY - minY) / 3) == 0 ? 1 : ((maxY - minY) / 3),
                getDrawingHorizontalLine: (value) {
                  return const FlLine(
                    color: AppTheme.border,
                    strokeWidth: 0.8,
                    dashArray: [4, 4],
                  );
                },
              ),
              titlesData: const FlTitlesData(
                show: false,
              ),
              borderData: FlBorderData(show: false),
              lineTouchData: LineTouchData(
                enabled: true,
                handleBuiltInTouches: true,
                touchCallback: (FlTouchEvent event, LineTouchResponse? response) {
                  if (response != null && response.lineBarSpots != null && response.lineBarSpots!.isNotEmpty) {
                    setState(() {
                      touchedIndex = response.lineBarSpots!.first.spotIndex;
                    });
                  } else if (event is FlTapUpEvent || event is FlPanEndEvent) {
                    setState(() {
                      touchedIndex = null;
                    });
                  }
                },
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (_) => AppTheme.surfaceRaised,
                  tooltipBorder: const BorderSide(color: AppTheme.accentGold, width: 1),
                  tooltipRoundedRadius: 8,
                  getTooltipItems: (touchedSpots) {
                    return touchedSpots.map((spot) {
                      return LineTooltipItem(
                        '${_formatPrice(spot.y)}\n',
                        AppTheme.monoStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                        children: [
                          TextSpan(
                            text: _getTimeLabel(spot.spotIndex, widget.dataPoints.length),
                            style: AppTheme.bodyStyle(
                              fontSize: 10,
                              color: AppTheme.textMuted,
                            ),
                          ),
                        ],
                      );
                    }).toList();
                  },
                ),
                getTouchedSpotIndicator: (LineChartBarData barData, List<int> spotIndexes) {
                  return spotIndexes.map((spotIndex) {
                    return TouchedSpotIndicatorData(
                      FlLine(
                        color: AppTheme.accentGold.withValues(alpha: 0.7),
                        strokeWidth: 1.5,
                        dashArray: [4, 4],
                      ),
                      FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 5,
                            color: AppTheme.accentGold,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                    );
                  }).toList();
                },
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: spots,
                  isCurved: true,
                  curveSmoothness: 0.35,
                  color: AppTheme.accentGold,
                  barWidth: 2.5,
                  isStrokeCapRound: true,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppTheme.accentGold.withValues(alpha: 0.35),
                        AppTheme.accentGold.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
