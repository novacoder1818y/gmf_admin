import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../data/dummy_data.dart';
import '../../data/models/event_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/neon_button.dart';

class AddEventView extends StatefulWidget {
  const AddEventView({super.key});

  @override
  State<AddEventView> createState() => _AddEventViewState();
}

class _AddEventViewState extends State<AddEventView> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 7));

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(context: context, initialDate: isStartDate ? _startDate : _endDate, firstDate: DateTime(2020), lastDate: DateTime(2030));
    if (picked != null && picked != (isStartDate ? _startDate : _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final newEvent = EventModel(id: DateTime.now().millisecondsSinceEpoch.toString(), title: _titleController.text, description: _descriptionController.text, startDate: _startDate, endDate: _endDate, isActive: true, participants: 0);
      DummyData.events.insert(0, newEvent);
      Get.snackbar('Success!', 'New event "${newEvent.title}" has been created.', snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create New Event')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildTextFormField(controller: _titleController, label: 'Event Title', icon: Icons.title),
            const SizedBox(height: 16),
            _buildTextFormField(controller: _descriptionController, label: 'Description', icon: Icons.description, maxLines: 4),
            const SizedBox(height: 24),
            _buildDatePicker(context: context, label: 'Start Date', date: _startDate, onTap: () => _selectDate(context, true)),
            const SizedBox(height: 16),
            _buildDatePicker(context: context, label: 'End Date', date: _endDate, onTap: () => _selectDate(context, false)),
            const SizedBox(height: 30),
            NeonButton(text: 'Create Event', onTap: _submitForm, gradientColors: const [AppTheme.accentColor, AppTheme.tertiaryColor]),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker({required BuildContext context, required String label, required DateTime date, required VoidCallback onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(12), child: InputDecorator(decoration: InputDecoration(labelText: label, prefixIcon: const Icon(Icons.calendar_today), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true), child: Text(DateFormat.yMMMd().format(date), style: TextStyle(color: isDark ? Colors.white : Colors.black87, fontSize: 16))));
  }

  TextFormField _buildTextFormField({required TextEditingController controller, required String label, required IconData icon, int maxLines = 1}) {
    return TextFormField(controller: controller, maxLines: maxLines, decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true), validator: (value) { if (value == null || value.isEmpty) { return 'This field cannot be empty'; } return null; });
  }
}