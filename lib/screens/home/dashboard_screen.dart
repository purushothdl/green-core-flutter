// lib/screens/home/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:green_core/providers/chat_provider.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/waste_provider.dart';
import '../../widgets/dashboard/dashboard_header.dart';
import '../../widgets/dashboard/graph_widget.dart';
import '../../widgets/dashboard/services_header.dart';
import '../../widgets/dashboard/waste_stats_card.dart';
import '../../widgets/shared/loading_widget.dart';
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
    final chatProvider = Provider.of<ChatProvider>(context, listen: false); 

    if (!authProvider.isUserLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await authProvider.fetchUserDetails();
        await chatProvider.loadUserChats((authProvider.user?.id).toString());
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await wasteProvider.fetchAllData(); // Fetch both stats and graph data
    });
  }

  Future<void> _handleRefresh() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final wasteProvider = Provider.of<WasteProvider>(context, listen: false);

    await authProvider.fetchUserDetails(forceRefresh: true);
    await wasteProvider.fetchAllData(forceRefresh: true); // Force refresh
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
      body: authProvider.user == null || wasteProvider.isLoading || wasteProvider.isGraphLoading
          ? const Center(child: LoadingWidget())
          : CustomRefreshIndicator(
              onRefresh: _handleRefresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 210,
                      child: GraphWidget(graphData: wasteProvider.graphData),
                    ),

                    const SizedBox(height: 12),
                    const ServicesWidget(),

                    const SizedBox(height: 8),
                    WasteStatsCard(
                      totalWeight: wasteProvider.totalWeight,
                      wasteByType: wasteProvider.wasteByType,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}