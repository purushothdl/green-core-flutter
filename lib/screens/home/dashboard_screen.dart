// lib/screens/home/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:green_core/widgets/dashboard/graph_widget.dart';
import 'package:green_core/widgets/dashboard/services_header.dart';
import 'package:green_core/widgets/shared/loading_widget.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/waste_provider.dart';
import '../../widgets/dashboard/dashboard_header.dart';
import '../../widgets/dashboard/waste_stats_card.dart';
import '../../widgets/shared/refresh_indicator.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  void _loadInitialData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final wasteProvider = Provider.of<WasteProvider>(context, listen: false);

    if (!authProvider.isUserLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await authProvider.fetchUserDetails();
      });
    }

    if (!wasteProvider.isLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await wasteProvider.fetchWasteStats();
      });
    }
  }

  Future<void> _handleRefresh() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final wasteProvider = Provider.of<WasteProvider>(context, listen: false);


    await authProvider.fetchUserDetails(forceRefresh: true);
    await wasteProvider.fetchWasteStats(forceRefresh: true); // Force refresh
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final wasteProvider = Provider.of<WasteProvider>(context);

    return Scaffold(
      appBar: authProvider.user == null
          ? null // Hide app bar while loading
          : DashboardAppBar(user: authProvider.user),
      backgroundColor: Colors.white,
      body: authProvider.user == null || wasteProvider.isLoading
          ? const Center(child: LoadingWidget())
          : CustomRefreshIndicator(
              onRefresh: _handleRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    WasteStatsCard(
                      totalWeight: wasteProvider.totalWeight,
                      wasteByType: wasteProvider.wasteByType,
                    ),
                    const SizedBox(height: 16),
                    const ServicesWidget(),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200, // Set a fixed height for the graph
                      child: GraphWidget(graphData: wasteProvider.graphData),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}