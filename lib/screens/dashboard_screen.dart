
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'student_list_screen.dart';
import '../widgets/total_students_card.dart';
import '../widgets/boys_count_card.dart';
import '../widgets/girls_count_card.dart';
import '../widgets/total_classes_card.dart';
import '../widgets/students_by_grade_chart.dart';
import '../widgets/gender_distribution_chart.dart';
import '../providers/student_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('School Dashboard'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(studentListProvider),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () async => ref.refresh(studentListProvider),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildCardsGrid(context, screenSize),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    'Analytics',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _buildChartsSection(context, screenSize),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (_) => const StudentListScreen())
                      );
                    },
                    icon: const Icon(Icons.people),
                    label: const Text(
                      "Manage Students",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardsGrid(BuildContext context, Size screenSize) {
    final isMobile = screenSize.width < 600;
    
    if (isMobile) {
      final cardWidth = screenSize.width * 0.9; 
      
      return Center(
        child: Column(
          children: [
            TotalStudentsCard(width: cardWidth),
            const SizedBox(height: 16),
            BoysCountCard(width: cardWidth),
            const SizedBox(height: 16),
            GirlsCountCard(width: cardWidth),
            const SizedBox(height: 16),
            TotalClassesCard(width: cardWidth),
          ],
        ),
      );
    } else {
      
      final cardWidth = screenSize.width * 0.4; 
      
      return Center(
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: 16,
          runSpacing: 16,
          children: [
            TotalStudentsCard(width: cardWidth),
            BoysCountCard(width: cardWidth),
            GirlsCountCard(width: cardWidth),
            TotalClassesCard(width: cardWidth),
          ],
        ),
      );
    }
  }

  Widget _buildChartsSection(BuildContext context, Size screenSize) {
    final isMobile = screenSize.width < 600;
    
    if (isMobile) {
     
      return Column(
        children: [
          Container(
            height: 250,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: StudentsByGradeChart(),
            ),
          ),
          Container(
            height: 250,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: GenderDistributionChart(),
            ),
          ),
        ],
      );
    } else {
     
      return Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              height: 300,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: StudentsByGradeChart(),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              height: 300,
              margin: const EdgeInsets.only(left: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: GenderDistributionChart(),
              ),
            ),
          ),
        ],
      );
    }
  }
}