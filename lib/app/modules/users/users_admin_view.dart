import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../data/dummy_data.dart';
import '../../data/models/user_model.dart';
import '../../routes/admin_routes.dart';

class UsersAdminView extends StatefulWidget {
  const UsersAdminView({super.key});

  @override
  State<UsersAdminView> createState() => _UsersAdminViewState();
}

class _UsersAdminViewState extends State<UsersAdminView> {
  late List<UserModel> _filteredUsers;

  @override
  void initState() {
    super.initState();
    _filteredUsers = DummyData.users;
  }

  void _filterUsers(String query) {
    final filtered = DummyData.users.where((user) {
      return user.name.toLowerCase().contains(query.toLowerCase()) ||
          user.email.toLowerCase().contains(query.toLowerCase());
    }).toList();
    setState(() => _filteredUsers = filtered);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Management')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: _filterUsers,
              decoration: InputDecoration(
                labelText: 'Search by name or email...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredUsers.length,
              itemBuilder: (context, index) {
                final user = _filteredUsers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: ListTile(
                    leading: const CircleAvatar(child: Icon(Icons.person)),
                    title: Text(user.name),
                    subtitle: Text(user.email),
                    trailing: user.isSuspended ? const Icon(Icons.block, color: Colors.red) : null,
                    onTap: () => Get.toNamed(Routes.USER_DETAIL, arguments: user),
                  ),
                ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.5);
              },
            ),
          ),
        ],
      ),
    );
  }
}