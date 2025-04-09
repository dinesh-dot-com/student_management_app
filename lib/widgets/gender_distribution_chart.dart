
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/student_provider.dart';

class GenderDistributionChart extends ConsumerWidget {
  const GenderDistributionChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final students = ref.watch(studentListProvider);
    final boysCount = students.where((s) => s.gender == 'Male').length;
    final girlsCount = students.where((s) => s.gender == 'Female').length;
    final total = boysCount + girlsCount;
    
    final List<PieChartSectionData> sections = [];
    
    if (total > 0) {
      final boysPct = boysCount / total * 100;
      final girlsPct = girlsCount / total * 100;
      
      sections.add(
        PieChartSectionData(
          color: Colors.blue,
          value: boysCount.toDouble(),
          title: '${boysPct.round()}%',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
      
      sections.add(
        PieChartSectionData(
          color: Colors.pink,
          value: girlsCount.toDouble(),
          title: '${girlsPct.round()}%',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender Distribution',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        if (sections.isEmpty)
          const Expanded(
            child: Center(
              child: Text('No data available'),
            ),
          )
        else
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: sections,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLegendItem('Boys', Colors.blue, boysCount),
                    const SizedBox(height: 16),
                    _buildLegendItem('Girls', Colors.pink, girlsCount),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
  
  Widget _buildLegendItem(String label, Color color, int count) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              count.toString(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}