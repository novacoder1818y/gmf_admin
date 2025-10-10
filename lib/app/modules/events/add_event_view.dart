import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../theme/app_theme.dart';
import '../../widgets/neon_button.dart';

// A local data model to manage the state of each question form
class QuestionFormModel {
  final TextEditingController questionController;
  final List<TextEditingController> optionControllers;
  int correctOptionIndex;

  QuestionFormModel()
      : questionController = TextEditingController(),
        optionControllers = List.generate(3, (_) => TextEditingController()),
        correctOptionIndex = 0;
}

class AddEventView extends StatefulWidget {
  const AddEventView({super.key});
  @override
  State<AddEventView> createState() => _AddEventViewState();
}

class _AddEventViewState extends State<AddEventView> {
  final QueryDocumentSnapshot? existingEvent = Get.arguments;
  late bool isEditMode;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController(text: '5');
  final _totalXpController = TextEditingController(text: '100');

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  final List<QuestionFormModel> _questionForms = [];

  @override
  void initState() {
    super.initState();
    isEditMode = existingEvent != null;
    if (isEditMode) {
      final data = existingEvent!.data() as Map<String, dynamic>;
      _titleController.text = data['title'];
      _descriptionController.text = data['description'];
      var _startDate = (data['startDate'] as Timestamp).toDate();
      _selectedDate = _startDate;
      _selectedTime = TimeOfDay.fromDateTime(_startDate);
      _durationController.text = (data['durationInMinutes'] ?? 5).toString();
      _totalXpController.text = (data['totalXp'] ?? 100).toString();

      if (data['questions'] is List) {
        for (var q in data['questions']) {
          final form = QuestionFormModel();
          form.questionController.text = q['question'];
          if (q['options'] is List && q['options'].length >= 3) {
            form.optionControllers[0].text = q['options'][0];
            form.optionControllers[1].text = q['options'][1];
            form.optionControllers[2].text = q['options'][2];
          }
          final correctIndex = (q['options'] as List).indexOf(q['correctAnswer']);
          form.correctOptionIndex = correctIndex != -1 ? correctIndex : 0;
          _questionForms.add(form);
        }
      }
    } else {
      _addQuestionForm();
    }
  }

  void _addQuestionForm() => setState(() => _questionForms.add(QuestionFormModel()));
  void _removeQuestionForm(int index) => setState(() => _questionForms.removeAt(index));

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final finalDateTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedTime.hour, _selectedTime.minute);

    final List<Map<String, dynamic>> questionsData = _questionForms.map((form) {
      return {
        'question': form.questionController.text,
        'options': form.optionControllers.map((c) => c.text).toList(),
        'correctAnswer': form.optionControllers[form.correctOptionIndex].text,
      };
    }).toList();

    if (questionsData.isEmpty) {
      Get.snackbar('Error', 'Please add at least one question.');
      return;
    }

    final Map<String, dynamic> eventData = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'startDate': Timestamp.fromDate(finalDateTime),
      'durationInMinutes': int.tryParse(_durationController.text) ?? 5,
      'totalXp': int.tryParse(_totalXpController.text) ?? 100,
      'questions': questionsData,
      // THIS IS THE FIX:
      // Add a server timestamp when creating a new event.
      if (!isEditMode) 'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      if (isEditMode) {
        await FirebaseFirestore.instance.collection('events').doc(existingEvent!.id).update(eventData);
      } else {
        await FirebaseFirestore.instance.collection('events').add(eventData);
      }
      Get.back();
      Get.snackbar('Success', isEditMode ? 'Event updated.' : 'New event created.');
    } catch (e) {
      Get.snackbar('Error', 'Operation failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditMode ? 'Edit Event' : 'Create New Event')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildTextFormField(controller: _titleController, label: 'Event Title'),
            const SizedBox(height: 16),
            _buildTextFormField(controller: _descriptionController, label: 'Description', maxLines: 3),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildDatePicker(context: context, label: 'Start Date', date: _selectedDate, onTap: () async {
                  final picked = await showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime.now().subtract(const Duration(days: 365)), lastDate: DateTime(2030));
                  if(picked != null) setState(() => _selectedDate = picked);
                })),
                const SizedBox(width: 16),
                Expanded(child: _buildTimePicker(context: context, label: 'Start Time', time: _selectedTime, onTap: () async {
                  final picked = await showTimePicker(context: context, initialTime: _selectedTime);
                  if(picked != null) setState(() => _selectedTime = picked);
                })),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildTextFormField(controller: _durationController, label: 'Duration (Mins)', keyboardType: TextInputType.number)),
                const SizedBox(width: 16),
                Expanded(child: _buildTextFormField(controller: _totalXpController, label: 'Total XP', keyboardType: TextInputType.number)),
              ],
            ),
            const Divider(height: 30),
            Text('Questions', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _questionForms.length,
              itemBuilder: (context, index) => _buildQuestionForm(index),
            ),
            const SizedBox(height: 16),
            TextButton.icon(icon: const Icon(Icons.add_circle_outline), label: const Text('Add Another Question'), onPressed: _addQuestionForm),
            const SizedBox(height: 30),
            NeonButton(text: isEditMode ? 'Update Event' : 'Create Event', onTap: _submitForm, gradientColors: const [AppTheme.accentColor, AppTheme.tertiaryColor]),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionForm(int index) {
    final form = _questionForms[index];
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Question ${index + 1}', style: Theme.of(context).textTheme.titleLarge),
                if (_questionForms.length > 1)
                  IconButton(icon: const Icon(Icons.close, color: Colors.redAccent), onPressed: () => _removeQuestionForm(index)),
              ],
            ),
            const SizedBox(height: 16),
            _buildTextFormField(controller: form.questionController, label: 'Question Text'),
            const SizedBox(height: 16),
            ...List.generate(3, (optionIndex) {
              return Row(
                children: [
                  Expanded(child: _buildTextFormField(controller: form.optionControllers[optionIndex], label: 'Option ${optionIndex + 1}')),
                  Radio<int>(
                    value: optionIndex,
                    groupValue: form.correctOptionIndex,
                    onChanged: (value) => setState(() => form.correctOptionIndex = value!),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  TextFormField _buildTextFormField({required TextEditingController controller, required String label, int maxLines = 1, TextInputType? keyboardType}) {
    return TextFormField(controller: controller, maxLines: maxLines, keyboardType: keyboardType, decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()), validator: (v) => (v == null || v.isEmpty) ? 'Required' : null);
  }
  Widget _buildDatePicker({required BuildContext context, required String label, required DateTime date, required VoidCallback onTap}) {
    return InkWell(onTap: onTap, child: InputDecorator(decoration: InputDecoration(labelText: label, prefixIcon: const Icon(Icons.calendar_today), border: const OutlineInputBorder()), child: Text(DateFormat.yMMMd().format(date))));
  }
  Widget _buildTimePicker({required BuildContext context, required String label, required TimeOfDay time, required VoidCallback onTap}) {
    return InkWell(onTap: onTap, child: InputDecorator(decoration: InputDecoration(labelText: label, prefixIcon: const Icon(Icons.access_time), border: const OutlineInputBorder()), child: Text(time.format(context))));
  }
}