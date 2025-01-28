// lib/widgets/dispose/dispose_form.dart
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'file_upload_widget.dart';
import 'waste_type_selector.dart';

class DisposeForm extends StatefulWidget {
  final Future<void> Function(String wasteType, double weight, File photo) onSubmit;

  const DisposeForm({super.key, required this.onSubmit});

  @override
  State<DisposeForm> createState() => _DisposeFormState();
}

class _DisposeFormState extends State<DisposeForm> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  String? _selectedWasteType;
  File? _selectedImage;
  String? _weightError; // To hold the weight error message

  void _submit() {
    bool isValid = true;

    // Validate weight
    if (_weightController.text.isEmpty) {
      setState(() => _weightError = 'Please enter the weight');
      isValid = false;
      Future.delayed(const Duration(seconds: 5), () => setState(() => _weightError = null));
    } else if (double.tryParse(_weightController.text) == null) {
      setState(() => _weightError = 'Enter a valid number');
      isValid = false;
      Future.delayed(const Duration(seconds: 5), () => setState(() => _weightError = null));
    } else {
      _weightError = null;
    }

    if (isValid && _selectedWasteType != null && _selectedImage != null) {
      widget.onSubmit(
        _selectedWasteType!,
        double.parse(_weightController.text),
        _selectedImage!,
      );
    } else {
      if (isValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please complete all fields and upload an image')),
        );
      }
    }
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Waste Type Selector
            Text(
              'Waste Type',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.orange),
            ),
            WasteTypeSelector(
              value: _selectedWasteType ?? 'Select Waste Type',
              onChanged: (value) => setState(() => _selectedWasteType = value),
            ),

            const SizedBox(height: 16),
            // Weight Input
            _buildWeightField(),

            const SizedBox(height: 16),
            // File Upload
            Text(
              'Image Upload',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.orange),
            ),
            const SizedBox(height: 8),
            FileUploadWidget(
              label: 'Image',
              filePath: _selectedImage?.path,
              onFileSelected: (filePath) => setState(() => _selectedImage = filePath != null ? File(filePath) : null),
            ),
            const SizedBox(height: 24),

            // Buttons
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: _goBack,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: const BorderSide(color: Colors.green, width: 1.5), // Add green border
                      ),
                      backgroundColor: Colors.white, // Background color of the button
                    ),
                    child: const Text(
                      'Go Back',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: _submit,
                    style: _buttonStyle(Colors.green, Colors.white),
                    child: const Text('Dispose Waste', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeightField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weight (kg)',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.orange),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
          child: TextFormField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter weight in kg',
              hintStyle: TextStyle(color: Colors.blueGrey[300], fontSize: 14),
              filled: true,
              fillColor: Colors.white,
              border: _inputBorder(),
              enabledBorder: _inputBorder(Colors.grey.shade300),
              focusedBorder: _inputBorder(Colors.blue),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
            style: TextStyle(color: Colors.blueGrey[800], fontSize: 14),
          ),
        ),
        if (_weightError != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              _weightError!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }

  OutlineInputBorder _inputBorder([Color? color]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color ?? Colors.transparent, width: 1.5),
    );
  }

  ButtonStyle _buttonStyle(Color backgroundColor, Color textColor) {
    return ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: backgroundColor),
      ),
      backgroundColor: textColor == Colors.white ? backgroundColor : Colors.white,
    );
  }
}
