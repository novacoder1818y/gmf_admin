// lib/modules/manage_practice/problems/manage_problems_view.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'manage_problems_controller.dart';

class ManageProblemsView extends GetView<ManageProblemsController> {
  const ManageProblemsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage "${controller.categoryName}" Problems'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.getProblemsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No problems found in this category. Add one!'));
          }
          final problems = snapshot.data!.docs;

          return ListView.builder(
            itemCount: problems.length,
            itemBuilder: (context, index) {
              final problem = problems[index];
              final data = problem.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(data['title']),
                  subtitle: Text(data['difficulty']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showProblemDialog(
                          problemId: problem.id,
                          currentData: data,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => controller.deleteProblem(problem.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProblemDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showProblemDialog({String? problemId, Map<String, dynamic>? currentData}) {
    final isEditing = problemId != null;
    final titleController = TextEditingController(text: currentData?['title']);
    final descController = TextEditingController(text: currentData?['description']);
    final codeController = TextEditingController(text: currentData?['starterCode']);

    // THIS IS THE FIX:
    // Create the reactive variable using RxString() and provide the initial value.
    final difficulty = RxString(currentData?['difficulty'] ?? 'Easy');

    Get.defaultDialog(
      title: isEditing ? 'Edit Problem' : 'Add New Problem',
      content: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
              const SizedBox(height: 10),
              TextField(controller: descController, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3),
              const SizedBox(height: 10),
              TextField(controller: codeController, decoration: const InputDecoration(labelText: 'Starter Code'), maxLines: 5, style: const TextStyle(fontFamily: 'monospace')),
              const SizedBox(height: 10),
              Obx(() => DropdownButtonFormField<String>(
                value: difficulty.value,
                items: ['Easy', 'Medium', 'Hard']
                    .map((label) => DropdownMenuItem(child: Text(label), value: label))
                    .toList(),
                onChanged: (value) {
                  if (value != null) difficulty.value = value;
                },
                decoration: const InputDecoration(labelText: 'Difficulty'),
              )),
            ],
          ),
        ),
      ),
      textConfirm: 'Save',
      textCancel: 'Cancel',
      onConfirm: () {
        if (isEditing) {
          controller.updateProblem(
            problemId: problemId!,
            title: titleController.text,
            description: descController.text,
            difficulty: difficulty.value,
            starterCode: codeController.text,
          );
        } else {
          controller.addProblem(
            title: titleController.text,
            description: descController.text,
            difficulty: difficulty.value,
            starterCode: codeController.text,
          );
        }
      },
    );
  }
}