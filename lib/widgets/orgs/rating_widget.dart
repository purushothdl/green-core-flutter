import 'package:flutter/material.dart';
import 'package:green_core/services/org_service.dart'; // Assuming the service for rating is here

class RatingWidget extends StatefulWidget {
  final String orgId;

  const RatingWidget({super.key, required this.orgId});

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  double _currentRating = 0.0; // Rating value
  String _statusMessage = ''; // Success or error message
  bool _isSuccess = false; // For success status (green message)
  bool _isError = false; // For error status (red message)

  final List<String> _ratingTexts = [
    'Terrible',
    'Poor',
    'Average',
    'Good',
    'Excellent'
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            const SizedBox(height: 16),
            _buildEmojiRating(),
            const SizedBox(height: 16),
            _buildRatingText(),
            const SizedBox(height: 20),

            // Status message
          if (_statusMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Center(
                child: Text(
                  _statusMessage,
                  style: TextStyle(
                    color: _isSuccess ? Colors.green : (_isError ? Colors.red : Colors.black),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),


            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: _buildButton(
                    label: 'Go Back',
                    color: Colors.white,
                    textColor: Colors.green.shade600,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 1,
                  child: _buildButton(
                    label: 'Rate Org',
                    color: Colors.green.shade600,
                    onPressed: () async {
                      if (_currentRating == 0.0) {
                        setState(() {
                          _statusMessage = 'Please select a rating!';
                          _isError = true;
                        });
                        return;
                      }

                      final success = await _submitRating();
                      if (success) {
                        setState(() {
                          _statusMessage = 'Rating submitted successfully!';
                          _isSuccess = true;
                        });
                        Future.delayed(const Duration(seconds: 3), () {
                          Navigator.of(context).pop();
                        });
                      } else {
                        setState(() {
                          _statusMessage = 'You have already rated this organization!';
                          _isError = true;
                        });
                        Future.delayed(const Duration(seconds: 5), () {
                          setState(() {
                            _statusMessage = '';
                          });
                        });
                      }
                    },
                    textColor: null,
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  // Title Row
  Widget _buildTitle() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.star, color: Colors.blue, size: 20),
        ),
        const SizedBox(width: 12),
        const Text('Your Rating',
          style: TextStyle(
            color: Colors.blue,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  // Emoji Rating
  Widget _buildEmojiRating() {
    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(5, (index) {
          final isSelected = (index + 1) == _currentRating;
          final bgColor = _getBackgroundColor(index);
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _currentRating = index + 1.0;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8), // Reduced padding
              decoration: BoxDecoration(
                color: isSelected ? bgColor.withOpacity(0.2) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: AnimatedScale(
                scale: isSelected ? 1.2 : 1.0, // Slightly reduced scale
                duration: const Duration(milliseconds: 200),
                child: Text(
                  _getEmoji(index),
                  style: TextStyle(
                    fontSize: 18, // Reduced font size
                    color: isSelected ? _getEmojiColor(index) : Colors.grey,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // Rating Text below the emojis
  Widget _buildRatingText() {
    return Center(
      child: Text(
        _currentRating > 0 ? _ratingTexts[_currentRating.toInt() - 1] : 'Select Rating',
        style: TextStyle(
          color: _currentRating > 0 ? _getTextColor() : Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Buttons Style
Widget _buildButton({
  required String label,
  required Color color,
  required Color? textColor,
  required VoidCallback onPressed,
  EdgeInsetsGeometry padding = const EdgeInsets.symmetric(horizontal: 6), // Default padding
}) {
  // If no textColor is provided, set it to white and match the border color to the background color
  textColor ??= Colors.white;

  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: textColor == Colors.white ? color : textColor,  // If textColor is white, set border to the same as bg
          width: 1.5,
        ),
      ),
    ),
    onPressed: onPressed,
    child: Padding(
      padding: padding, // Apply the padding to the button
      child: Text(
        label,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
        ),
      ),
    ),
  );
}


  // Helper methods to manage emoji colors, background, etc.
  Color _getBackgroundColor(int index) {
    if (index <= 1) return Colors.red; // Terrible, Poor
    if (index == 2) return Colors.orange; // Average
    return Colors.green; // Good, Excellent
  }

  Color _getEmojiColor(int index) {
    switch(index) {
      case 0: return Colors.red;
      case 1: return Colors.orange;
      case 2: return Colors.amber;
      case 3: return Colors.lightGreen;
      case 4: return Colors.green;
      default: return Colors.black;
    }
  }

  Color _getTextColor() {
    if (_currentRating <= 2) return Colors.red;
    if (_currentRating == 3) return Colors.orange;
    return Colors.green;
  }

  String _getEmoji(int index) {
    switch (index) {
      case 0: return '😭';
      case 1: return '😞';
      case 2: return '😐';
      case 3: return '😊';
      case 4: return '😎';
      default: return '😐';
    }
  }

  // Submit rating to backend
  Future<bool> _submitRating() async {
    try {
      final response = await OrgService.submitRating(widget.orgId, _currentRating.toInt());

      if (response.statusCode == 200) {
        return true; // Successfully rated
      } else if (response.statusCode == 409) {
        return false; // Already rated
      } else {
        throw Exception('Error rating org');
      }
    } catch (e) {
      setState(() {
        _statusMessage = 'An error occurred. Please try again later.';
        _isError = true;
      });
      return false;
    }
  }
}
