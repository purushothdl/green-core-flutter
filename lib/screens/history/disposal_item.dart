import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class DisposalItem extends StatelessWidget {
  final Map<String, dynamic> disposal;
  final VoidCallback onTap;

  const DisposalItem({
    super.key,
    required this.disposal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Define the app's primary green color to match the screenshots
    const primaryGreen = Color(0xFF4CAF50);
    final wasteType = disposal['waste_type'] ?? 'Unknown';
    final wasteColor = _getWasteTypeColor(wasteType);
    final wasteIcon = _getWasteTypeIcon(wasteType);

    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: Colors.white,  // Set card background to white
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        splashColor: primaryGreen.withOpacity(0.1),
        highlightColor: primaryGreen.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top section with organization and date
              Row(
                children: [
                  // Organization logo or avatar
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: primaryGreen.withOpacity(0.3), width: 2),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: disposal['photo_url'] ?? '',
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: primaryGreen,
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.business, color: primaryGreen),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Organization name and date
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _truncateText(disposal['org_name'] ?? 'Organization', 20),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              _formatDate(disposal['date'] ?? DateTime.now().toString()),
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Weight badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${disposal['weight'] ?? 0}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          'kg',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 12),
              const Divider(height: 1, color: Color.fromARGB(255, 242, 242, 242),),
              const SizedBox(height: 12),
              
              // Bottom section with waste type and status
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Waste type with icon
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: wasteColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          wasteIcon,
                          size: 18,
                          color: wasteColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        wasteType,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: primaryGreen.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle,
                          size: 16,
                          color: primaryGreen,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Completed',
                          style: TextStyle(
                            fontSize: 13,
                            color: primaryGreen,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to get color based on waste type
  Color _getWasteTypeColor(String wasteType) {
    switch (wasteType.toLowerCase()) {
      case 'recyclable':
        return Colors.blue;
      case 'hazardous':
        return Colors.red;
      case 'biodegradable':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Helper method to get icon based on waste type
  IconData _getWasteTypeIcon(String wasteType) {
    switch (wasteType.toLowerCase()) {
      case 'recyclable':
        return Icons.recycling;
      case 'hazardous':
        return Icons.warning_amber;
      case 'biodegradable':
        return Icons.eco;
      default:
        return Icons.delete;
    }
  }

  // Format date to match the app's style
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  // Helper method to truncate text if it exceeds a certain length
  String _truncateText(String text, int maxLength) {
    if (text.length > maxLength) {
      return '${text.substring(0, maxLength)}...';
    }
    return text;
  }
}

