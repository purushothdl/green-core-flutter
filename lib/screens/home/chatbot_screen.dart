// lib/screens/chat_history_screen.dart
// lib/features/chat/screens/chat_history_screen.dart
import 'package:flutter/material.dart';
import 'package:green_core/widgets/shared/refresh_indicator.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../providers/chat_provider.dart';
import '../../widgets/chat/chat_history_list.dart';
import '../../widgets/chat/empty_chat_history.dart';
import '../chat/chat_screen.dart';

import 'package:flutter/scheduler.dart';

import 'home_screen.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({super.key});

  @override
  _ChatHistoryScreenState createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> with RouteAware {
  RouteObserver<ModalRoute<void>>? _routeObserver;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _routeObserver = Provider.of<RouteObserver<ModalRoute<void>>>(context, listen: false);
    _routeObserver?.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    _routeObserver?.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    _loadChats(context);
  }

  @override
  void initState() {
    super.initState();
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    if (!chatProvider.isInitialized) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _loadChats(context);
      });
    }
  }

  Future<void> _loadChats(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userId = authProvider.user?.id;
    if (userId != null) {
      await context.read<ChatProvider>().loadUserChats(userId, forceReload: true);
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final userId = authProvider.user?.id;
    if (!chatProvider.isInitialized && userId != null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        chatProvider.loadUserChats(userId);
      });
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat History',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              context.read<ChatProvider>().clearActiveSession();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ChatScreen(),
                ),
              ).then((_) => _loadChats(context));
            },
          ),
        ],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: CustomRefreshIndicator(
        onRefresh: () => _loadChats(context),
        child: Consumer<ChatProvider>(
          builder: (context, chatProvider, _) {
            if (!chatProvider.isInitialized && chatProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (chatProvider.error != null) {
              return Center(
                child: Text(
                  'Error: ${chatProvider.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            }
            if (chatProvider.userChats.isEmpty) {
              return const EmptyChatHistory();
            }
            return ChatHistoryList(chatProvider: chatProvider);
          },
        ),
      ),
    );
  }
}