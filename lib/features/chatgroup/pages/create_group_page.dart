import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instproject/features/chatgroup/cubit/group_cubit.dart';
import 'package:instproject/features/storage/domain/appwrite_storage_repo.dart';

class CreateGroupPage extends StatefulWidget {
  const CreateGroupPage({super.key});

  @override
  State<CreateGroupPage> createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final nameController = TextEditingController();
  final Set<String> selectedUsers = {};
  File? groupImage;
  bool _isLoading = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => groupImage = File(picked.path));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUid = FirebaseAuth.instance.currentUser!.uid;
    final appwriteStorage = context.read<AppwriteStorageRepo>();

    return Scaffold(
      appBar: AppBar(title: const Text("Create Group")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: pickImage,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: groupImage != null
                    ? FileImage(groupImage!)
                    : null,
                child: groupImage == null
                    ? const Icon(Icons.camera_alt, size: 32)
                    : null,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Group Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            // const Align(
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //     "Select Members",
            //     style: TextStyle(fontWeight: FontWeight.bold),
            //   ),
            // ),
            // const SizedBox(height: 8),
            // Expanded(
            //   child: StreamBuilder<QuerySnapshot>(
            //     stream: FirebaseFirestore.instance
            //         .collection('users')
            //         .snapshots(),
            //     builder: (context, snapshot) {
            //       if (!snapshot.hasData) {
            //         return const Center(child: CircularProgressIndicator());
            //       }

            //       final users = snapshot.data!.docs
            //           .where((u) => u['uid'] != currentUid)
            //           .toList();

            //       return ListView.builder(
            //         itemCount: users.length,
            //         itemBuilder: (context, i) {
            //           final user = users[i];
            //           final uid = user['uid'];
            //           final name = user['name'] ?? 'User';
            //           final photoUrl =
            //               user.data().toString().contains('photoUrl')
            //               ? user['photoUrl']
            //               : null;

            //           return ListTile(
            //             leading: CircleAvatar(
            //               backgroundImage: photoUrl != null
            //                   ? NetworkImage(photoUrl)
            //                   : null,
            //               child: photoUrl == null
            //                   ? const Icon(Icons.person)
            //                   : null,
            //             ),
            //             title: Text(name),
            //             trailing: Checkbox(
            //               value: selectedUsers.contains(uid),
            //               onChanged: (v) {
            //                 setState(() {
            //                   if (v == true) {
            //                     selectedUsers.add(uid);
            //                   } else {
            //                     selectedUsers.remove(uid);
            //                   }
            //                 });
            //               },
            //             ),
            //           );
            //         },
            //       );
            //     },
            //   ),
            // ),
            const SizedBox(height: 12),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton.icon(
                    icon: const Icon(Icons.group_add),
                    label: const Text("Create Group"),
                    onPressed: () async {
                      final name = nameController.text.trim();
                      if (name.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Enter group name")),
                        );
                        return;
                      }

                      // if (selectedUsers.isEmpty) {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     const SnackBar(
                      //       content: Text("Select at least one member"),
                      //     ),
                      //   );
                      //   return;
                      // }

                      setState(() => _isLoading = true);

                      
                      String? uploadedUrl;
                      if (groupImage != null) {
                        uploadedUrl = await appwriteStorage
                            .uploadProfileImageMobile(
                              groupImage!.path, 
                              currentUid, 
                            );
                      }

                      
                      final imageUrl = uploadedUrl ?? '';

                      final memberUids = [...selectedUsers, currentUid];

                      await context.read<GroupCubit>().createGroup(
                        name,
                        memberUids,
                        imageUrl,
                      );

                      if (context.mounted) {
                        await context.read<GroupCubit>().refreshGroups();
                        Navigator.pop(context);
                      }

                      setState(() => _isLoading = false);
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
