// lib/screens/dispose/dispose_page.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/org_model.dart';
import '../../models/dispose_model.dart';
import '../../providers/dispose_provider.dart';
import '../../widgets/dispose/dispose_form.dart';

class DisposePage extends StatelessWidget {
  final Org org;

  const DisposePage({super.key, required this.org});

  @override
  Widget build(BuildContext context) {
    final disposeProvider = Provider.of<DisposeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          org.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display organization's image with overlay
            if (org.imageUrl != null)
              Container(
                width: double.infinity,
                height: 160,
                margin: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: NetworkImage(org.imageUrl!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    // Address text container with black opacity (only the container, not the image)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.4), // Black opacity for the address container
                          borderRadius: BorderRadius.circular(6.0), // Rounded corners for the container
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on_sharp,
                              color: Colors.red,
                              size: 18,
                            ),
                            const SizedBox(width: 4), // Small spacing between icon and text
                            Text(
                              org.address,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
            ),
            
            const SizedBox(height: 16),
            disposeProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : DisposeForm(
                    onSubmit: (wasteType, weight, photo) async {
                      final disposeData = DisposeModel(
                        orgName: org.name,
                        wasteType: wasteType,
                        weight: weight,
                        photoPath: photo.path,
                      );

                      try {
                        await disposeProvider.disposeWaste(
                          disposeData: disposeData,
                          photo: photo,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Waste disposed successfully!', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green,),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Failed to dispose waste', style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
                        );
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
