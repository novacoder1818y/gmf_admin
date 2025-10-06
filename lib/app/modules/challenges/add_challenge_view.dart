import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../data/dummy_data.dart';
import '../../data/models/challenge_model.dart';
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
  String? _selectedDifficulty = 'Easy';
  String? _selectedCategory = 'Coding';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _pointsController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newChallenge = ChallengeModel(
        id: DateTime.now().toString(),
        title: _titleController.text,
        description: _descriptionController.text,
        difficulty: _selectedDifficulty!,
        category: _selectedCategory!,
        points: int.tryParse(_pointsController.text) ?? 0,
      );

      DummyData.challenges.insert(0, newChallenge);

      Get.snackbar(
        'Success!',
        'New challenge "${_titleController.text}" has been created.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // This command closes the current page (the form).
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Challenge')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildTextFormField(controller: _titleController, label: 'Challenge Title', icon: Icons.title),
            const SizedBox(height: 16),
            _buildTextFormField(controller: _descriptionController, label: 'Description', icon: Icons.description, maxLines: 4),
            const SizedBox(height: 16),
            _buildDropdown(label: 'Difficulty', value: _selectedDifficulty, items: ['Easy', 'Medium', 'Hard'], onChanged: (value) => setState(() => _selectedDifficulty = value), icon: Icons.bar_chart),
            const SizedBox(height: 16),
            _buildDropdown(label: 'Category', value: _selectedCategory, items: ['Coding', 'Puzzle', 'MCQ'], onChanged: (value) => setState(() => _selectedCategory = value), icon: Icons.category),
            const SizedBox(height: 16),
            _buildTextFormField(controller: _pointsController, label: 'XP Points', icon: Icons.star, keyboardType: TextInputType.number, inputFormatters: [FilteringTextInputFormatter.digitsOnly]),
            const SizedBox(height: 30),
            NeonButton(text: 'Create Challenge', onTap: _submitForm, gradientColors: const [AppTheme.accentColor, AppTheme.tertiaryColor]),
          ],
        ),
      ),
    );
  }

  TextFormField _buildTextFormField({required TextEditingController controller, required String label, required IconData icon, int maxLines = 1, TextInputType? keyboardType, List<TextInputFormatter>? inputFormatters}) {
    return TextFormField(controller: controller, maxLines: maxLines, keyboardType: keyboardType, inputFormatters: inputFormatters, decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true), validator: (value) { if (value == null || value.isEmpty) { return 'This field cannot be empty'; } return null; });
  }

  DropdownButtonFormField<String> _buildDropdown({required String label, required String? value, required List<String> items, required ValueChanged<String?> onChanged, required IconData icon}) {
    return DropdownButtonFormField<String>(value: value, decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true), items: items.map((String item) { return DropdownMenuItem<String>(value: item, child: Text(item)); }).toList(), onChanged: onChanged, validator: (value) => value == null ? 'Please select an option' : null);
  }
}