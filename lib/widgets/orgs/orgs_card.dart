// lib/widgets/orgs/org_card.dart
import 'package:flutter/material.dart';
import 'package:green_core/utils/date_formatter.dart';
import 'package:green_core/widgets/orgs/rating_widget.dart';
import 'package:green_core/widgets/orgs/warning_widget.dart'; // Import warning widget
import '../../models/org_model.dart';
import 'package:provider/provider.dart';
import '../../providers/org_provider.dart';
import '../../screens/dispose/dispose_page.dart';

class OrgCard extends StatelessWidget {
  final Org org;

  const OrgCard({super.key, required this.org});

  @override
  Widget build(BuildContext context) {
    final orgProvider = Provider.of<OrgProvider>(context);
    bool isSelected = org.id == orgProvider.selectedOrgId; // Check if this org is selected

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Row for Org Image and Name
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(25),
                        child: org.imageUrl != null && org.imageUrl!.isNotEmpty
                            ? Image.network(
                                org.imageUrl!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/orgs/default_org.jpg', // Default image asset
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                      ),
                      const SizedBox(width: 16),
                      // Org Name and Joined Date
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              org.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Joined on ${DateFormatter.format(org.createdAt)}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.deepOrange,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Grey container for Address & Contact
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(Icons.location_on, org.address),
                        const SizedBox(height: 0),
                        _buildDetailRow(Icons.phone, org.contact),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Action buttons (Dispose & Give Rating)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _buildActionButton(
                        label: 'Dispose',
                        color: Colors.green.shade600,
                        onPressed: () async {
                          double distance = await orgProvider.getDistanceToOrg(org.id);
                          if (distance <= 50) {
                            // Proceed with dispose action (navigate to dispose page)
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DisposePage(org: org), // Placeholder for Dispose page
                              ),
                            );
                          } else {
                            // Show warning widget
                            showDialog(
                              context: context,
                              builder: (context) => WarningWidget(
                                org: org,
                                distance: distance,
                              ),
                            );
                          }
                        },
                      ),

                      const SizedBox(width: 12),
                      _buildActionButton(
                        label: 'Give Rating',
                        color: Colors.blue.shade600,
                        onPressed: () {
                          // Trigger the rating popup
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return RatingWidget(orgId: org.id);  // Pass the org.id to the rating dialog
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: 5,
              right: 5,
              child: _buildRating(),
            ),
            // Overlay if the org is selected
            if (isSelected)
              Positioned.fill(
                child: Container(
                  color: Colors.blue.withOpacity(0.2),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Helper function to create rows for Address & Contact
  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Icon(
            icon,
            size: 18,
            color: Colors.green.shade600,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }

  // Helper function to create action buttons
  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: color.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Rating widget
  Widget _buildRating() {
    final ratingText = org.rating != null ? 'Rating | ${org.rating}/5' : 'Rating | Not Rated';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.orange.shade600,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        ratingText,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}
