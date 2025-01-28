// lib/screens/home/orgs_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/org_provider.dart';
import '../../widgets/orgs/orgs_card.dart';
import '../../widgets/orgs/orgs_map.dart';
import '../../widgets/shared/loading_widget.dart';

class OrgsScreen extends StatefulWidget {
  const OrgsScreen({super.key});

  @override
  _OrgsScreenState createState() => _OrgsScreenState();
}

class _OrgsScreenState extends State<OrgsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrgProvider>().fetchOrgsAndLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orgProvider = Provider.of<OrgProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Organisations',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true, 
        foregroundColor: Colors.white, 
        backgroundColor: Colors.green, 
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home'); 
          },
        ),
        actions: [
          // Refresh Button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: ()  {
              Provider.of<OrgProvider>(context, listen: false).refresh();
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: orgProvider.isLoading
          ? const Center(child: LoadingWidget())
          : RefreshIndicator(
              onRefresh: () => orgProvider.refresh(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Map Widget
                    const OrgsMap(),

                    // Orgs List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: orgProvider.orgs.length,
                      itemBuilder: (context, index) {
                        final org = orgProvider.orgs[index];
                        return OrgCard(org: org);
                       
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}