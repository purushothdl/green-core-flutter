// lib/widgets/orgs/orgs_map.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../providers/org_provider.dart';

class OrgsMap extends StatelessWidget {
  const OrgsMap({super.key});

  @override
  Widget build(BuildContext context) {
    final orgProvider = Provider.of<OrgProvider>(context);

    return Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey, width: 0.5)
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
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
              if (orgProvider.userPosition != null)
                Marker(
                  markerId: const MarkerId('user'),
                  position: LatLng(
                    orgProvider.userPosition!.latitude,
                    orgProvider.userPosition!.longitude,
                  ),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                ),
              ...orgProvider.orgs.map((org) {
                return Marker(
                  markerId: MarkerId(org.id),
                  position: LatLng(org.latitude, org.longitude),
                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
                  onTap: () {
                    // When marker is tapped, select the org
                    orgProvider.selectOrg(org.id);
                  },
                );
              }).toList(),
            },
          ),
        ),
      ),
    );
  }
}
