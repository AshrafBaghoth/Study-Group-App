import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instproject/features/posts/data/appwrite_storage_post_repo.dart';
import 'package:instproject/features/posts/data/fire_post_repo.dart';
import 'package:instproject/main_shell.dart';
import '../../presentation/bloc/post_cubit.dart';
import '../../presentation/bloc/post_states.dart';

class CreatePostPage extends StatefulWidget {
  final String userId;
  final String? userName;
  final String? userProfileImage;

  const CreatePostPage({
    super.key,
    required this.userId,
    this.userName,
    this.userProfileImage,
  });

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final captionController = TextEditingController();
  String? _imagePath;
  bool isUploading = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imagePath = picked.path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PostCubit(
        postRepo: FirePostRepo(),
        storageRepo: AppwritePostStorageRepo(),
      ),
      child: BlocConsumer<PostCubit, PostStates>(
        listener: (context, state) {
          if (state is PostLoaded) {
           
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Post uploaded successfully!')),
            );

            
            Future.delayed(const Duration(milliseconds: 600), () {
              if (mounted)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MainShell(
                      
                      
                    ),
                  ),
                );
            });
          } else if (state is PostError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
            setState(() => isUploading = false);
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              title: const Text('Create Post'),
              backgroundColor: Colors.brown.shade800,
              elevation: 0,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 🖼️ Image picker
                  GestureDetector(
                    onTap: pickImage,
                    child: _imagePath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              File(_imagePath!),
                              height: 250,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            height: 250,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.brown.shade800.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.brown.shade700,
                                width: 1,
                              ),
                            ),
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_a_photo,
                                    color: Colors.white70,
                                    size: 40,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Tap to select an image',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: captionController,
                    maxLines: 3,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Write a caption...',
                      labelStyle: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                      ),
                      filled: true,
                      fillColor: Colors.brown.shade700.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: (state is PostLoading || _imagePath == null)
                          ? null
                          : () {
                              setState(() => isUploading = true);
                              context.read<PostCubit>().createPost(
                                userId: widget.userId,
                                caption: captionController.text.trim(),
                                imagePath: _imagePath!,
                              );
                            },
                      icon: isUploading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.cloud_upload),
                      label: Text(
                        state is PostLoading ? 'Uploading...' : 'Share Post',
                        style: const TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown.shade800,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
