// lib/widgets/dashboard/services_header.dart

import 'package:flutter/material.dart';

class ServicesWidget extends StatefulWidget {
  const ServicesWidget({super.key});

  @override
  State<ServicesWidget> createState() => _ServicesWidgetState();
}

class _ServicesWidgetState extends State<ServicesWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Create staggered animations for each button
    _animations = List.generate(
      4,
      (index) => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.2, // Staggered delay for each button
            1.0,
            curve: Curves.easeOut,
          ),
        ),
      ),
    );

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0, bottom: 16.0),
            child: Text(
              'Services',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.green,
                letterSpacing: -0.5,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _AnimatedServiceButton(
                animation: _animations[0],
                icon: Icons.delete_outline_rounded,
                label: 'Dispose',
                color: Colors.green,
                onTap: () {},
              ),
              _AnimatedServiceButton(
                animation: _animations[1],
                icon: Icons.radio_button_checked_outlined,
                label: 'Chatbot',
                color: Colors.blue,
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/chatbot');
                },
              ),
              _AnimatedServiceButton(
                animation: _animations[2],
                icon: Icons.history_rounded,
                label: 'History',
                color: Colors.orange,
                onTap: () {},
              ),
              _AnimatedServiceButton(
                animation: _animations[3],
                icon: Icons.help_outline_rounded,
                label: 'FAQs',
                color: Colors.purple,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AnimatedServiceButton extends StatefulWidget {
  final Animation<double> animation;
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AnimatedServiceButton({
    required this.animation,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  State<_AnimatedServiceButton> createState() => _AnimatedServiceButtonState();
}

class _AnimatedServiceButtonState extends State<_AnimatedServiceButton> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.animation,
      builder: (context, child) {
        return Opacity(
          opacity: widget.animation.value,
          child: Transform.translate(
            offset: Offset(0, (1 - widget.animation.value) * 20),
            child: child,
          ),
        );
      },
      child: InkWell(
        borderRadius: BorderRadius.circular(40),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          setState(() {
            _isTapped = !_isTapped; // Toggle state on tap
          });
          widget.onTap();
        },
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: _isTapped ? widget.color : widget.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.icon,
                size: 32,
                color: _isTapped ? Colors.white : widget.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}