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
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Decorative accent
            Positioned(
              top: -30,
              right: -30,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),
                  _buildWasteTypeGrid(),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(
          begin: 0.1,
          end: 0,
          curve: Curves.easeOutCubic,
        );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green.shade700,
                    Colors.green.shade600,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.shade600.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.eco_rounded,
                size: 28,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Waste Disposed',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${NumberUtils.convertDouble(totalWeight)} kg',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Colors.green.shade800,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ],
        ),
        Icon(
          Icons.trending_down_rounded,
          color: Colors.green.shade600,
          size: 32,
        ),
      ],
    );
  }

  Widget _buildWasteTypeGrid() {
    return Wrap(
      spacing: 24,
      runSpacing: 24,
      children: wasteByType.entries.map((entry) {
        final (color, icon) = _getCategoryStyle(entry.key);
        return _buildWasteTypeItem(
          icon: icon,
          color: color,
          title: entry.key,
          value: entry.value,
        ).animate().fadeIn(delay: 100.ms).slideX(
              begin: 0.1,
              end: 0,
              duration: 300.ms,
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
    return SizedBox(
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.1),
                  color.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.withOpacity(0.15),
                width: 1,
              ),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(height: 12),
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade600,
              letterSpacing: 1.2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Text(
            '${NumberUtils.convertDouble(value)} kg',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  (Color, IconData) _getCategoryStyle(String category) {
    switch (category.toLowerCase()) {
      case 'recyclable':
        return (Color(0xFF2D9CDB), Icons.recycling_rounded);
      case 'biodegradable':
        return (Color(0xFF27AE60), Icons.compost_rounded);
      case 'hazardous':
        return (Color(0xFFEB5757), Icons.dangerous_rounded);
      default:
        return (Color(0xFF828282), Icons.inventory_2_rounded);
    }
  }
}