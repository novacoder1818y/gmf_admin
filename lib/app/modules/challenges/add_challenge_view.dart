import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/challenge_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/neon_button.dart';

class AddChallengeView extends StatefulWidget {
  const AddChallengeView({super.key});
  @override
  State<AddChallengeView> createState() => _AddChallengeViewState();
}

class _AddChallengeViewState extends State<AddChallengeView> {
  final ChallengeModel? existingChallenge = Get.arguments;
  late bool isEditMode;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pointsController = TextEditingController();
  final _option1Controller = TextEditingController();
  final _option2Controller = TextEditingController();
  final _option3Controller = TextEditingController();

  String? _selectedDifficulty = 'Easy';
  String? _selectedCategory = 'MCQ';
  String? _correctAnswer;

  @override
  void initState() {
    super.initState();
    isEditMode = existingChallenge != null;
    if (isEditMode) {
      // Pre-populate the form fields with existing data.
      // This now correctly accesses the fields from the new ChallengeModel.
      _titleController.text = existingChallenge!.title;
      _descriptionController.text = existingChallenge!.description;
      _pointsController.text = existingChallenge!.points.toString();
      _selectedDifficulty = existingChallenge!.difficulty;
      _selectedCategory = existingChallenge!.category;
      _correctAnswer = existingChallenge!.correctAnswer;
      if (existingChallenge!.options != null && existingChallenge!.options!.length >= 3) {
        _option1Controller.text = existingChallenge!.options![0];
        _option2Controller.text = existingChallenge!.options![1];
        _option3Controller.text = existingChallenge!.options![2];
      }
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    if (_correctAnswer == null || _correctAnswer!.isEmpty) {
      Get.snackbar('Error', 'Please select a correct answer.', backgroundColor: Colors.red);
      return;
    }

    Get.dialog(const Center(child: CircularProgressIndicator()), barrierDismissible: false);

    final Map<String, dynamic> data = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'difficulty': _selectedDifficulty,
      'category': _selectedCategory,
      'points': int.tryParse(_pointsController.text) ?? 0,
      'questionType': 'multiple_choice',
      'options': [_option1Controller.text, _option2Controller.text, _option3Controller.text],
      'correctAnswer': _correctAnswer,
    };

    try {
      if (isEditMode) {
        await FirebaseFirestore.instance.collection('challenges').doc(existingChallenge!.id).update(data);
      } else {
        await FirebaseFirestore.instance.collection('challenges').add(data);
      }
      Get.back(); // Close dialog
      Get.back(); // Close form
      Get.snackbar('Success', isEditMode ? 'Challenge updated.' : 'New challenge created.');
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Operation failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditMode ? 'Edit Challenge' : 'Create New Challenge')),
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
            NeonButton(text: isEditMode ? 'Update Challenge' : 'Create Challenge', onTap: _submitForm, gradientColors: [AppTheme.accentColor, AppTheme.primaryColor]),
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
          Expanded(child: _buildTextFormField(controller: controller, label: label, icon: Icons.quiz_outlined)),
          Radio<String>(
            value: controller.text,
            groupValue: _correctAnswer,
            onChanged: (value) => setState(() => _correctAnswer = controller.text),
          ),
        ],
      ),
    );
  }

  TextFormField _buildTextFormField({required TextEditingController controller, required String label, required IconData icon, int maxLines = 1, TextInputType? keyboardType}) {
    return TextFormField(controller: controller, maxLines: maxLines, keyboardType: keyboardType, decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true), validator: (v) => v == null || v.isEmpty ? 'Cannot be empty' : null);
  }
  DropdownButtonFormField<String> _buildDropdown({required String label, String? value, required List<String> items, required ValueChanged<String?> onChanged}) {
    return DropdownButtonFormField<String>(value: value, decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true), items: items.map((i) => DropdownMenuItem(value: i, child: Text(i))).toList(), onChanged: onChanged);
  }
}