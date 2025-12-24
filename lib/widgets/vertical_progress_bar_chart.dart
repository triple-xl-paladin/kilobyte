/*
 * Copyright (c) 2025  Alexander Chen <aprchen@gmail.com>
 *
 * This file vertical_progress_bar_chart.dart is part of kilobyte
 *
 * kilobyte is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * kilobyte is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with kilobyte.  If not, see <https://www.gnu.org/licenses/>.
 */

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class VerticalProgressBarChart extends StatelessWidget {
  final List<String> labels = ['Jan', 'Feb', 'Mar', 'Apr'];
  final List<double> actuals = [1065, 1580, 1850, 2190];
  final List<double> totals = [2000, 2000, 2000, 2000];

  VerticalProgressBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: actuals.reduce((a, b) => a > b ? a : b), // highest total
          barGroups: List.generate(labels.length, (i) {
            final actual = actuals[i];
            final total = totals[i];
            final remaining = total - actual;

            return BarChartGroupData(
              x: i,
              barsSpace: 4,
              barRods: [
                // Actual value bar
                BarChartRodData(
                  toY: actual,
                  width: 20,
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(4),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    fromY: 0,
                    toY: total,
                    color: Colors.grey[300],
                  ),

                ),
              ],
            );
          }),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= labels.length) return SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(labels[index]),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
              ),
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }
}
