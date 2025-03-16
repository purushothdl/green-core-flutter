import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class DisposalDetailScreen extends StatelessWidget {
  final Map<String, dynamic> disposal;

  const DisposalDetailScreen({super.key, required this.disposal});

  @override
  Widget build(BuildContext context) {
    // Define the app's primary green color to match the screenshots
    const primaryGreen = Color(0xFF4CAF50);
    final wasteType = disposal['waste_type'] ?? 'Unknown';
    final wasteColor = _getWasteTypeColor(wasteType);
    final wasteIcon = _getWasteTypeIcon(wasteType);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Disposal Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: primaryGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      body: Column(
        children: [
          
          // Content area with scrolling
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Organization info card
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image section with gradient overlay
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                              child: CachedNetworkImage(
                                imageUrl: disposal['photo_url'] ?? '',
                                width: double.infinity,
                                height: 200,
                                fit: BoxFit.cover,
                                progressIndicatorBuilder: (context, url, progress) => Center(
                                  child: CircularProgressIndicator(
                                    value: progress.progress,
                                    color: primaryGreen,
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  height: 200,
                                  color: const Color.fromARGB(255, 246, 246, 246),
                                  child: const Icon(Icons.error, color: Colors.red, size: 50),
                                ),
                              ),
                            ),
                            // Gradient overlay
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.6),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            // Organization name overlay
                            Positioned(
                              left: 16,
                              bottom: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Organization',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                  Text(
                                    disposal['org_name'] ?? 'Unknown',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        // Enhanced info section
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildEnhancedInfoItem(
                                  icon: Icons.scale,
                                  label: 'Weight',
                                  value: '${disposal['weight'] ?? 0} kg',
                                  color: primaryGreen,
                                ),
                                Container(
                                  height: 40,
                                  width: 1,
                                  color: Colors.grey[200],
                                ),
                                _buildEnhancedInfoItem(
                                  icon: Icons.check_circle,
                                  label: 'Status',
                                  value: 'Completed',
                                  color: primaryGreen,
                                ),
                                Container(
                                  height: 40,
                                  width: 1,
                                  color: Colors.grey[200],
                                ),
                                _buildEnhancedInfoItem(
                                  icon: wasteIcon,
                                  label: 'Type',
                                  value: wasteType,
                                  color: wasteColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Date and location information
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Collection Details',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Date and time row
                          _buildDetailRow(
                            icon: Icons.calendar_today,
                            label: 'Date',
                            value: _formatDateOnly(disposal['date'] ?? ''),
                            color: primaryGreen,
                          ),
                          const SizedBox(height: 16),
                          
                          // Time row
                          _buildDetailRow(
                            icon: Icons.access_time,
                            label: 'Time',
                            value: _formatTimeOnly(disposal['date'] ?? ''),
                            color: primaryGreen,
                          ),
                          
                          // Add more details if available
                          if (disposal['location'] != null) ...[
                            const SizedBox(height: 16),
                            _buildDetailRow(
                              icon: Icons.location_on,
                              label: 'Location',
                              value: disposal['location'],
                              color: primaryGreen,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Additional information or actions
                  Card(
                    color: Colors.white,
                    elevation: 4,
                    shadowColor: Colors.black26,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.eco, color: primaryGreen),
                              SizedBox(width: 8),
                              Text(
                                'Environmental Impact',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Placeholder for environmental impact stats
                          _buildImpactStat(
                            icon: Icons.co2,
                            label: 'Carbon Offset',
                            value: '${(double.parse(disposal['weight'].toString()) * 0.5).toStringAsFixed(1)} kg CO₂',
                          ),
                          const SizedBox(height: 12),
                          _buildImpactStat(
                            icon: Icons.water_drop,
                            label: 'Water Saved',
                            value: '${(double.parse(disposal['weight'].toString()) * 3.7).toStringAsFixed(1)} liters',
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Helper widget for rendering info chips
  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
  
  // Helper widget for detail rows
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  // Helper widget for impact statistics
  Widget _buildImpactStat({
    required IconData icon,
    required String label,
    required String value,
  }) {
    const primaryGreen = Color(0xFF4CAF50);
    
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: primaryGreen, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: primaryGreen,
                ),
              ),
            ],
          ),
        ),
      ],
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

  // Format date only (DD MMM, YYYY)
  String _formatDateOnly(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM, yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }
  
  // Format time only (HH:MM)
  String _formatTimeOnly(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('HH:mm').format(date);
    } catch (e) {
      return dateString;
    }
  }

  // Helper method to build modern info chip
  Widget _buildModernInfoChip({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20, color: iconColor),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[800],
          ),
        ),
      ],
    );
  }

  // Add this new helper method
  Widget _buildEnhancedInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}
