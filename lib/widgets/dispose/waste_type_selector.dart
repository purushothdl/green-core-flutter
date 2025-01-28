// lib/widgets/dispose/waste_type_selector.dart

import 'package:flutter/material.dart';

class WasteTypeSelector extends StatefulWidget {
  final String value;
  final ValueChanged<String?> onChanged;

  const WasteTypeSelector({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<WasteTypeSelector> createState() => _WasteTypeSelectorState();
}

class _WasteTypeSelectorState extends State<WasteTypeSelector> {
  final LayerLink _layerLink = LayerLink();
  bool _isOpen = false;
  late OverlayEntry _overlayEntry;

  void _toggleDropdown() {
    if (_isOpen) {
      _overlayEntry.remove();
    } else {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry);
    }
    setState(() {
      _isOpen = !_isOpen;
    });
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0, size.height),
          child: Material(
            elevation: 4,
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDropdownItem('Biodegradable', selected: widget.value == 'Biodegradable'),
                _buildDropdownItem('Recyclable', selected: widget.value == 'Recyclable'),
                _buildDropdownItem('Hazardous', selected: widget.value == 'Hazardous'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownItem(String text, {bool selected = false}) {
    // Set text color based on selection
    Color textColor;
    if (text == 'Biodegradable') {
      textColor = Colors.green;
    } else if (text == 'Hazardous') {
      textColor = Colors.red;
    } else {
      textColor = Colors.blue;
    }

    return InkWell(
      onTap: () {
        widget.onChanged(text);
        _toggleDropdown();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        decoration: BoxDecoration(
          color: selected ? textColor.withOpacity(0.1) : Colors.white,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected ? textColor : Colors.black87,
            fontSize: 14,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 12.0, bottom: 6),
        ),
        CompositedTransformTarget(
          link: _layerLink,
          child: InkWell(
            onTap: _toggleDropdown,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.value,
                    style: TextStyle(
                      color: _getSelectedTextColor(widget.value),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: Colors.blue[800],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Function to determine the color based on selected value
  Color _getSelectedTextColor(String value) {
    if (value == 'Biodegradable') {
      return Colors.green;
    } else if (value == 'Hazardous') {
      return Colors.red;
    } else if (value == 'Recyclable') {
      return Colors.blue;
    } else if (value == 'Select Waste Type'){
      return Colors.grey;
    }

    return Colors.black87; // Default color
  }

  @override
  void dispose() {
    if (_isOpen) {
      _overlayEntry.remove();
    }
    super.dispose();
  }
}
