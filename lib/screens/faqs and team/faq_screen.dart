// lib/screens/faqs_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/faq_provider.dart';
import '../../widgets/faqs/faq_card.dart';


class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  _FAQScreenState createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<FAQProvider>(context, listen: false).loadFAQs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FAQs',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home'); 
          },
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: Consumer<FAQProvider>(
        builder: (context, faqProvider, _) {
          if (faqProvider.isLoading) return const _LoadingView();
          if (faqProvider.error != null) return _ErrorView(error: faqProvider.error!);
          if (faqProvider.faqs.isEmpty) return const _EmptyView();
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: faqProvider.faqs.length,
            itemBuilder: (context, index) {
              final category = faqProvider.faqs.keys.elementAt(index);
              return _CategorySection(
                category: category,
                faqs: faqProvider.faqs[category] as List,
              );
            },
          );
        },
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final String category;
  final List<dynamic> faqs;
  const _CategorySection({required this.category, required this.faqs});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
          child: Text(
            category,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.green.shade800,
              letterSpacing: 0.8,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: faqs.length,
          itemBuilder: (context, index) => FAQCard(faq: faqs[index]),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Colors.green.shade600),
          const SizedBox(height: 20),
          Text(
            'Loading FAQs...',
            style: TextStyle(color: Colors.green.shade800),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  const _ErrorView({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade600, size: 40),
          const SizedBox(height: 16),
          Text(
            'Error loading FAQs:',
            style: TextStyle(color: Colors.red.shade800),
          ),
          const SizedBox(height: 8),
          Text(
            error,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.hourglass_empty, color: Colors.green.shade600, size: 40),
          const SizedBox(height: 16),
          Text(
            'No FAQs available',
            style: TextStyle(color: Colors.green.shade800),
          ),
        ],
      ),
    );
  }
}