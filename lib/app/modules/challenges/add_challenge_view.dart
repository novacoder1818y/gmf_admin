import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../theme/app_theme.dart';
import '../../widgets/neon_button.dart';

class AddChallengeView extends StatefulWidget {
  const AddChallengeView({super.key});
  @override
  State<AddChallengeView> createState() => _AddChallengeViewState();
}

class _AddChallengeViewState extends State<AddChallengeView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pointsController = TextEditingController();
  final _option1Controller = TextEditingController();
  final _option2Controller = TextEditingController();
  final _option3Controller = TextEditingController();

  String? _selectedDifficulty = 'Easy';
  String? _selectedCategory = 'MCQ';
  String? _correctAnswer; // This will hold the correct option text

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_correctAnswer == null) {
        Get.snackbar('Error', 'Please select a correct answer.', backgroundColor: Colors.red);
        return;
      }

      Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);
      try {
        await FirebaseFirestore.instance.collection('challenges').add({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'difficulty': _selectedDifficulty,
          'category': _selectedCategory,
          'points': int.tryParse(_pointsController.text) ?? 0,
          'questionType': 'multiple_choice',
          'options': [
            _option1Controller.text,
            _option2Controller.text,
            _option3Controller.text,
          ],
          'correctAnswer': _correctAnswer,
        });

        Get.back(); // Close dialog
        Get.back(); // Close form
        Get.snackbar('Success!', 'New challenge has been created.', backgroundColor: Colors.green);
      } catch (e) {
        Get.back();
        Get.snackbar('Error', 'Failed to create challenge: $e');
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New MCQ Challenge')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildTextFormField(controller: _titleController, label: 'Challenge Title', icon: Icons.title),
            const SizedBox(height: 16),
            _buildTextFormField(controller: _descriptionController, label: 'Question / Description', icon: Icons.description, maxLines: 3),
            const SizedBox(height: 16),
            _buildDropdown(label: 'Difficulty', value: _selectedDifficulty, items: ['Easy', 'Medium', 'Hard'], onChanged: (v) => setState(() => _selectedDifficulty = v)),
            const SizedBox(height: 16),
            _buildTextFormField(controller: _pointsController, label: 'XP Points', icon: Icons.star, keyboardType: TextInputType.number),
            const Divider(height: 30),
            Text('Multiple Choice Options', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            _buildOptionField(_option1Controller, 'Option 1'),
            _buildOptionField(_option2Controller, 'Option 2'),
            _buildOptionField(_option3Controller, 'Option 3'),
            const SizedBox(height: 30),
            NeonButton(text: 'Create Challenge', onTap: _submitForm, gradientColors: const [AppTheme.accentColor, AppTheme.tertiaryColor]),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: _buildTextFormField(controller: controller, label: label, icon: Icons.quiz_outlined),
          ),
          Radio<String>(
            value: controller.text,
            groupValue: _correctAnswer,
            onChanged: (value) {
              // We set state to rebuild the UI and show which radio button is selected
              setState(() {
                // We use the text from the controller as the value to ensure it's always in sync
                _correctAnswer = controller.text;
              });
            },
          ),
        ],
      ),
    );
  }

  // Other helper methods (_buildTextFormField, _buildDropdown) remain the same
  TextFormField _buildTextFormField({required TextEditingController controller, required String label, required IconData icon, int maxLines = 1, TextInputType? keyboardType}) {
    return TextFormField(controller: controller, maxLines: maxLines, keyboardType: keyboardType, decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true), validator: (v) => v == null || v.isEmpty ? 'Cannot be empty' : null);
  }
  DropdownButtonFormField<String> _buildDropdown({required String label, String? value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return DropdownButtonFormField<String>(value: value, decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true), items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(), onChanged: onChanged);
  }
}
