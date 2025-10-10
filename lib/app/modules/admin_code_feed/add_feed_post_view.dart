import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/feedpostmodel.dart';
import '../../theme/app_theme.dart';
import '../../widgets/neon_button.dart';

class AddFeedPostView extends StatefulWidget {
  const AddFeedPostView({super.key});
  @override
  State<AddFeedPostView> createState() => _AddFeedPostViewState();
}

class _AddFeedPostViewState extends State<AddFeedPostView> {
  final FeedPostModel? existingPost = Get.arguments;
  late bool isEditMode;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    isEditMode = existingPost != null;
    if (isEditMode) {
      _titleController.text = existingPost!.title;
      _authorController.text = existingPost!.author;
      _contentController.text = existingPost!.content;
    }
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final Map<String, dynamic> postData = {
      'title': _titleController.text,
      'author': _authorController.text,
      'content': _contentController.text,
      if (!isEditMode) 'createdAt': FieldValue.serverTimestamp(),
    };

    try {
      if (isEditMode) {
        await FirebaseFirestore.instance.collection('codeFeed').doc(existingPost!.id).update(postData);
      } else {
        await FirebaseFirestore.instance.collection('codeFeed').add(postData);
      }
      Get.back();
      Get.snackbar('Success', isEditMode ? 'Post updated successfully.' : 'New post created successfully.');
    } catch (e) {
      Get.snackbar('Error', 'Operation failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditMode ? 'Edit Post' : 'Create New Post')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildTextFormField(controller: _titleController, label: 'Title'),
            const SizedBox(height: 16),
            _buildTextFormField(controller: _authorController, label: 'Author / Source'),
            const SizedBox(height: 16),
            _buildTextFormField(controller: _contentController, label: 'Content', maxLines: 10),
            const SizedBox(height: 30),
            NeonButton(
              text: isEditMode ? 'Update Post' : 'Create Post',
              onTap: _submitForm,
              gradientColors: const [AppTheme.accentColor, AppTheme.tertiaryColor],
            ),
          ],
        ),
      ),
    );
  }

  TextFormField _buildTextFormField({required TextEditingController controller, required String label, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      validator: (v) => (v == null || v.isEmpty) ? 'This field is required' : null,
    );
  }
}
