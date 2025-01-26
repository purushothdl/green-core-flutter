// lib/widgets/orgs/orgs_map.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../models/org_model.dart';
import '../../providers/org_provider.dart';

class OrgsMap extends StatelessWidget {
  const OrgsMap({super.key});

  @override
  Widget build(BuildContext context) {
    final orgProvider = Provider.of<OrgProvider>(context);

    return SizedBox(
      height: 230,
      child: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            orgProvider.userPosition?.latitude ?? 0.0,
            orgProvider.userPosition?.longitude ?? 0.0,
          ),
          zoom: 14,
        ),
        markers: {
          // User Marker (Blue)
          if (orgProvider.userPosition != null)
            Marker(
              markerId: const MarkerId('user'),
              position: LatLng(
                orgProvider.userPosition!.latitude,
                orgProvider.userPosition!.longitude,
              ),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
            ),

          // Orgs Markers (Red)
          ...orgProvider.orgs.map((org) {
            return Marker(
              markerId: MarkerId(org.id),
              position: LatLng(org.latitude, org.longitude),
              icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              onTap: () {
                // Show org info popup
                _showOrgInfo(context, org);
              },
            );
          }).toList(),
        },
      ),
    );
  }

  void _showOrgInfo(BuildContext context, Org org) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(org.name),
          content: Text('Phone: ${org.contact}'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}