import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../../data/models/feedpostmodel.dart';
import '../../routes/admin_routes.dart';
import 'feed_controller.dart';

class FeedAdminView extends GetView<FeedAdminController> {
  const FeedAdminView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Code Feed Management')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('codeFeed').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final posts = snapshot.data!.docs.map((doc) => FeedPostModel.fromFirestore(doc)).toList();

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text(post.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('By ${post.author} on ${DateFormat.yMMMd().format(post.createdAt.toDate())}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: const Icon(Icons.edit), onPressed: () => Get.toNamed(Routes.ADD_FEED_POST, arguments: post)),
                      IconButton(icon: const Icon(Icons.delete, color: Colors.redAccent), onPressed: () => controller.deletePost(post.id, post.title)),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: (100 * index).ms);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(Routes.ADD_FEED_POST),
        label: const Text('New Post'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
