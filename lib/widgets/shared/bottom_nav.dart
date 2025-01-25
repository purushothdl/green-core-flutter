import 'package:flutter/material.dart';

class GradientIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final Gradient gradient;

  const GradientIcon({
    required this.icon,
    required this.size,
    required this.gradient,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) => gradient.createShader(bounds),
      child: Icon(
        icon,
        size: size,
        color: Colors.white,
      ),
    );
  }
}

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      colors: [Colors.greenAccent.shade400, Colors.green.shade700],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.95), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedItemColor: Colors.green.shade800,
        unselectedItemColor: Colors.grey.shade600,
        showSelectedLabels: true,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
        ),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined, size: 26),
            activeIcon: GradientIcon(
              icon: Icons.dashboard_rounded,
              size: 28,
              gradient: gradient,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business_center_outlined, size: 26),
            activeIcon: GradientIcon(
              icon: Icons.business_rounded,
              size: 28,
              gradient: gradient,
            ),
            label: 'Orgs',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.radio_button_checked_outlined, size: 26),
            activeIcon: GradientIcon(
              icon: Icons.radio_button_checked_outlined,
              size: 28,
              gradient: gradient,
            ),
            label: 'Chatbot',
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline, size: 26),
            activeIcon: GradientIcon(
              icon: Icons.person_rounded,
              size: 28,
              gradient: gradient,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}