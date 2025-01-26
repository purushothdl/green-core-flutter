// lib/widgets/dashboard/waste_stats_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../utils/number_utils.dart';

class WasteStatsCard extends StatelessWidget {
  final double totalWeight;
  final Map<String, double> wasteByType;

  const WasteStatsCard({
    super.key,
    required this.totalWeight,
    required this.wasteByType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade600.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Gradient Background
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 10),
                  _buildWasteTypeGrid(),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green.shade600.withOpacity(0.8),
                    Colors.green.shade700,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.shade600.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.delete_sweep_rounded,
                size: 28,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              'WASTE DISPOSED',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.grey.shade800,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.7),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: Colors.green.shade100,
              width: 1.5,
            ),
          ),
          child: Text(
            '${NumberUtils.convertDouble(totalWeight).toString()} kg',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Colors.green.shade800,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWasteTypeGrid() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: wasteByType.entries.map((entry) {
        final (color, icon) = _getCategoryStyle(entry.key);
        return _buildWasteTypeItem(
          icon: icon,
          color: color,
          title: entry.key,
          value: entry.value,
        );
      }).toList(),
    );
  }

  Widget _buildWasteTypeItem({
    required IconData icon,
    required Color color,
    required String title,
    required double value,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
        const SizedBox(height: 10),
        Text(
          title.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade700,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 6),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: NumberUtils.convertDouble(value).toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: color,
                  letterSpacing: 0.5,
                ),
              ),
              TextSpan(
                text: ' kg',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  (Color, IconData) _getCategoryStyle(String category) {
    switch (category.toLowerCase()) {
      case 'recyclable':
        return (Colors.blue.shade700, Icons.recycling_rounded);
      case 'biodegradable':
        return (Colors.teal.shade600, Icons.compost_rounded);
      case 'hazardous':
        return (Colors.orange.shade700, Icons.warning_rounded);
      default:
        return (Colors.grey.shade600, Icons.category_rounded);
    }
  }
}