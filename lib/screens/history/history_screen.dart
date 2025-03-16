import 'package:flutter/material.dart';
import 'package:green_core/screens/history/disposal_item.dart';
import 'package:provider/provider.dart';
import '../../providers/waste_provider.dart';
import 'disposal_detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch history when screen is built
    final wasteProvider = Provider.of<WasteProvider>(context, listen: false);
    wasteProvider.fetchWasteHistory();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Disposal History',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home'); 
          },
        ),
      ),
      backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      body: Consumer<WasteProvider>(
        builder: (context, wasteProvider, child) {
          if (wasteProvider.isHistoryLoading && !wasteProvider.isHistoryLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          if (wasteProvider.history.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_rounded, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No disposal history found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => wasteProvider.fetchWasteHistory(forceRefresh: true),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: wasteProvider.history.length,
              itemBuilder: (context, index) {
                final disposal = wasteProvider.history[index];
                return DisposalItem(
                  disposal: disposal,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DisposalDetailScreen(disposal: disposal),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
} 