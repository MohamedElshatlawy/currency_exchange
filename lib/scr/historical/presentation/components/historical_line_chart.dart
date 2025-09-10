import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:x_transfer/core/common/app_colors/app_colors.dart';

import '../../../../core/common/app_font_style/app_font_style_global.dart';
import '../../../../core/components/app_text/app_text.dart';
import '../../../../core/components/app_text/models/app_text_model.dart';
import '../../../../core/util/localization/app_localizations.dart';
import '../../domain/entities/historical_entity.dart';

class HistoricalLineChart extends StatelessWidget {
  final List<HistoricalEntity> items;
  const HistoricalLineChart({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final filtered =
        items.where((e) => e.date != null && e.rate != null).toList()..sort(
          (a, b) => DateTime.parse(a.date!).compareTo(DateTime.parse(b.date!)),
        );
    final spots = List<FlSpot>.generate(
      filtered.length,
      (i) => FlSpot(i.toDouble(), filtered[i].rate!),
    );
    final minY = filtered.map((e) => e.rate!).reduce((a, b) => a < b ? a : b);
    final maxY = filtered.map((e) => e.rate!).reduce((a, b) => a > b ? a : b);
    final padding = (maxY - minY).abs() * 0.1;
    final yMin = (minY - padding);
    final yMax = (maxY + padding);
    return Expanded(
      child: Padding(
        padding: EdgeInsetsDirectional.only(end: 12.w),
        child: LineChart(
          LineChartData(
            minY: yMin,
            maxY: yMax,
            minX: 0,
            maxX: (filtered.length - 1).toDouble(),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: ((yMax - yMin) / 4).clamp(
                0.0001,
                double.infinity,
              ),
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 100,
                  interval: 1,
                  getTitlesWidget: (value, meta) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      space: 10,
                      child: RotatedBox(
                        quarterTurns: 3,
                        child: AppText(
                          text: DateFormat('dd-MM').format(
                            DateTime.parse(filtered[value.toInt()].date!),
                          ),
                          model: AppTextModel(
                            style: AppFontStyleGlobal(
                              AppLocalizations.of(context)!.locale,
                            ).overLine.copyWith(color: AppColors.grayColor),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 52,
                  interval: ((yMax - yMin) / 4).clamp(0.0001, double.infinity),
                  getTitlesWidget: (value, meta) {
                    return SideTitleWidget(
                      axisSide: meta.axisSide,
                      child: AppText(
                        text: value.toStringAsFixed(4),
                        model: AppTextModel(
                          style: AppFontStyleGlobal(
                            AppLocalizations.of(context)!.locale,
                          ).overLine.copyWith(color: AppColors.grayColor),
                        ),
                      ),
                    );
                  },
                ),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),

            borderData: FlBorderData(
              show: true,
              border: Border.all(color: AppColors.shadow),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: spots,
                isCurved: true,
                barWidth: 3,
                dotData: FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: AppColors.primaryColor.withValues(alpha: 0.15),
                ),
                color: AppColors.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
