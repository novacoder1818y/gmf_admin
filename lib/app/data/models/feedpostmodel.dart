import 'package:cloud_firestore/cloud_firestore.dart';

class FeedPostModel {
  final String id;
  final String title;
  final String author;
  final String content;
  final Timestamp createdAt;

  FeedPostModel({
    required this.id,
    required this.title,
    required this.author,
    required this.content,
    required this.createdAt,
  });

  factory FeedPostModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return FeedPostModel(
      id: doc.id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      content: data['content'] ?? '',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
}
