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

  final List<Map<String, dynamic>> _services = [
    {
      'icon': Icons.delete_outline_rounded,
      'label': 'Dispose',
      'color': const Color(0xFF00C853),
    },
    {
      'icon': Icons.smart_toy_outlined,
      'label': 'Chatbot',
      'color': const Color(0xFF2962FF),
    },
    {
      'icon': Icons.history_rounded,
      'label': 'History',
      'color': const Color(0xFFF57F17),
    },
    {
      'icon': Icons.help_outline_rounded,
      'label': 'FAQs',
      'color': const Color(0xFFAA00FF),
    },
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _animations = List.generate(
      4,
      (index) => Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * 0.15,
            1.0,
            curve: Curves.fastEaseInToSlowEaseOut,
          ),
        ),
      ),
    );

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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 16.0),
            child: RichText(
              text: TextSpan(
                text: 'Services',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                  letterSpacing: -0.8,
                  height: 1.2,
                ),
                children: [
                  TextSpan(
                    text: '\nQuick access to features',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade500,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 130,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                4,
                (index) => _AnimatedServiceButton(
                  animation: _animations[index],
                  icon: _services[index]['icon'] as IconData,
                  label: _services[index]['label'] as String,
                  color: _services[index]['color'] as Color,
                  onTap: () => _handleServiceTap(index, context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleServiceTap(int index, BuildContext context) async {
    // Wait for 500ms before navigation
    await Future.delayed(const Duration(milliseconds: 200));
    
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/dispose');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/chatbot');
        break;
      case 2:
        // Handle history tap
        break;
      case 3:
        // Handle FAQs tap
        break;
    }
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
        return Transform(
          transform: Matrix4.identity()
            ..translate(
              0.0,
              (1 - widget.animation.value) * 20,
            )
            ..scale(widget.animation.value),
          alignment: Alignment.center,
          child: Opacity(
            opacity: widget.animation.value,
            child: child,
          ),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: () {
            setState(() {
              _isTapped = true;
            });
            Future.delayed(const Duration(milliseconds: 300), () {
              widget.onTap();
            });
          },
          splashColor: widget.color.withOpacity(0.2),
          highlightColor: widget.color.withOpacity(0.1),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 80,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _isTapped ? widget.color : widget.color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.icon,
                    size: 28,
                    color: _isTapped ? Colors.white : widget.color,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade700,
                    letterSpacing: -0.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}