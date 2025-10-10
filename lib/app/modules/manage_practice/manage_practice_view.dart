// lib/modules/manage_practice/manage_practice_view.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/admin_routes.dart';
import 'manage_practice_controller.dart';

class ManagePracticeView extends GetView<ManagePracticeController> {
  const ManagePracticeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // appBar: AppBar(title: const Text('Manage Practice Arena')),
      body: StreamBuilder<QuerySnapshot>(
        stream: controller.getCategoriesStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final categories = snapshot.data!.docs;

          return ListView.builder(
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.folder_special_outlined),
                  title: Text(category['name']),
                  subtitle: Text('Order: ${category['order']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _showCategoryDialog(
                          docId: category.id,
                          currentName: category['name'],
                          currentOrder: category['order'],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => controller.deleteCategory(category.id),
                      ),
                    ],
                  ),
                  onTap: () {
                    // Navigate to manage problems for this category
                    Get.toNamed(
                      Routes.MANAGE_PRACTICE_PROBLEMS,
                      arguments: {
                        'categoryId': category.id,
                        'categoryName': category['name'],
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCategoryDialog({String? docId, String? currentName, int? currentOrder}) {
    final nameController = TextEditingController(text: currentName);
    final orderController = TextEditingController(text: currentOrder?.toString() ?? '');
    final isEditing = docId != null;

    Get.defaultDialog(
      title: isEditing ? 'Edit Category' : 'Add Category',
      content: Column(
        children: [
          TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Category Name')),
          TextField(controller: orderController, decoration: const InputDecoration(labelText: 'Order'), keyboardType: TextInputType.number),
        ],
      ),
      onConfirm: () {
        final order = int.tryParse(orderController.text) ?? 0;
        if (isEditing) {
          controller.updateCategory(docId!, nameController.text, order);
        } else {
          controller.addCategory(nameController.text, order);
        }
      },
      textConfirm: 'Save',
      textCancel: 'Cancel',
    );
  }
}