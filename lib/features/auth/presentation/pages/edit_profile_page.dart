import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instproject/features/auth/domain/entities/app_user.dart';
import 'package:instproject/features/auth/presentation/bloc/profile_cubit.dart';
import 'package:instproject/features/auth/presentation/bloc/profile_states.dart';
import 'package:instproject/features/auth/presentation/components/my_textfiled.dart';

class EditProfilePage extends StatefulWidget {
  final AppUser user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final bioController = TextEditingController();
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    bioController.text = widget.user.bio;
  }

  
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imagePath = picked.path);
    }
  }

 
  void updateProfile() async {
    final profileCubit = context.read<ProfileCubit>();
    await profileCubit.updateProfile(
      uid: widget.user.uid,
      newBio: bioController.text,
      imageMobilePath: _imagePath,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileStates>(
      listener: (context, state) {
        if (state is ProfileLoaded) {
          Navigator.pop(context, true); 
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('Saving changes...'),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Profile'),
            actions: [
              IconButton(
                onPressed: updateProfile,
                icon: const Icon(Icons.upload),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                GestureDetector(
                  onTap: pickImage,
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.inversePrimary,
                        backgroundImage: _buildProfileImage(),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 10,
                        child: CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 20,
                          child: const Icon(Icons.edit, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                const Text('Bio', style: TextStyle(fontSize: 16)),
                const SizedBox(height: 10),
                MyTextfiled(
                  controller: bioController,
                  hint: 'Enter your bio...',
                  obsecure: false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ImageProvider _buildProfileImage() {
    if (_imagePath != null && File(_imagePath!).existsSync()) {
      return FileImage(File(_imagePath!));
    } else if (widget.user.profileImg.isNotEmpty) {
      return NetworkImage(widget.user.profileImg);
    } else {
      return const AssetImage('images/defaultImage.jpeg');
    }
  }
}
