import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:instproject/features/auth/domain/entities/app_user.dart';
import 'package:instproject/features/auth/presentation/bloc/auth_cubit.dart';
import 'package:instproject/features/auth/presentation/bloc/profile_cubit.dart';
import 'package:instproject/features/auth/presentation/bloc/profile_states.dart';
import 'package:instproject/features/auth/presentation/components/bio_box.dart';
import 'package:instproject/features/auth/presentation/pages/edit_profile_page.dart';
import 'package:instproject/features/posts/data/post_model.dart';
import 'package:instproject/features/posts/domain/post_repo.dart';
import 'package:instproject/features/posts/presentation/bloc/post_cubit.dart';
import 'package:instproject/features/posts/presentation/bloc/post_states.dart';
import 'package:instproject/features/posts/presentation/pages/post_detail_page.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final AuthCubit authCubit;
  late final ProfileCubit profileCubit;
  late final PostCubit postCubit;

  AppUser? currentUser;
  String? _localImagePath;
  String? _localBio;

  @override
  void initState() {
    super.initState();
    authCubit = context.read<AuthCubit>();
    profileCubit = context.read<ProfileCubit>();
    postCubit = context.read<PostCubit>();

    currentUser = authCubit.currentUser;

    profileCubit.fetchUserProfile(widget.uid);
    postCubit.fetchPostsByUserId(widget.uid);

    _loadLocalData();
  }

 
  Future<void> _saveBioLocally(String bio) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_bio_${widget.uid}', bio);
  }

  Future<void> _saveProfileImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_${widget.uid}', path);
  }

  Future<void> _loadLocalData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _localImagePath = prefs.getString('profile_image_${widget.uid}');
      _localBio = prefs.getString('user_bio_${widget.uid}');
    });
  }

  

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileStates>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ProfileError) {
          return Scaffold(body: Center(child: Text(state.message)));
        }

        if (state is ProfileLoaded) {
          final user = state.appUser;

          
          final displayedBio = _localBio ?? user.bio;

          return Scaffold(
            appBar: AppBar(
              title: Text(user.name),
              actions: [
                if (currentUser != null && currentUser!.uid == user.uid)
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfilePage(user: user),
                        ),
                      );

                      if (result is Map<String, dynamic>) {
                        
                        final updatedBio = result['bio'] as String?;
                        final updatedImage = result['imagePath'] as String?;

                        if (updatedBio != null) {
                          _saveBioLocally(updatedBio);
                          setState(() {
                            _localBio = updatedBio;
                          });
                        }

                        if (updatedImage != null) {
                          _saveProfileImagePath(updatedImage);
                          setState(() {
                            _localImagePath = updatedImage;
                          });
                        }

                        
                        profileCubit.fetchUserProfile(widget.uid);
                        postCubit.fetchPostsByUserId(widget.uid);
                      }
                    },
                  ),
              ],
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.inversePrimary,
                    backgroundImage: _buildProfileImage(user),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                  const SizedBox(height: 25),
                  MyBioBox(
                    text: displayedBio.isNotEmpty ? displayedBio : "No bio yet",
                  ),
                  const SizedBox(height: 40),
                  BlocBuilder<PostCubit, PostStates>(
                    builder: (context, pState) {
                      if (pState is PostLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (pState is PostError) {
                        return Text(pState.message);
                      }

                      if (pState is PostLoaded) {
                        final posts = pState.posts
                            .where((p) => p.userId == widget.uid)
                            .toList();

                        if (posts.isEmpty) {
                          return const Text('No posts yet');
                        }

                        return StreamBuilder<List<Post>>(
                          stream: context.read<PostRepo>().streamPostsByUserId(
                            widget.uid,
                          ),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }

                            if (snapshot.hasError) {
                              return Center(
                                child: Text('Error: ${snapshot.error}'),
                              );
                            }

                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return const Center(child: Text('No posts yet'));
                            }

                            final posts = snapshot.data!;

                            return GridView.builder(
                              itemCount: posts.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 4,
                                    mainAxisSpacing: 4,
                                    childAspectRatio: 1,
                                  ),
                              itemBuilder: (context, index) {
                                final post = posts[index];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            PostDetailPage(post: post),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child:
                                        post.imageUrl != null &&
                                            post.imageUrl!.isNotEmpty
                                        ? Image.network(
                                            post.imageUrl!,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            color: Colors.grey[300],
                                            child: Center(
                                              child: Text(
                                                post.caption?.isNotEmpty == true
                                                    ? post.caption!
                                                    : "No Image",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black54,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          );
        }

        return const Scaffold(body: Center(child: Text('No profile found.')));
      },
    );
  }

  ImageProvider _buildProfileImage(AppUser user) {
    if (_localImagePath != null && File(_localImagePath!).existsSync()) {
      return FileImage(File(_localImagePath!));
    } else if (user.profileImg.isNotEmpty) {
      return NetworkImage(user.profileImg);
    } else {
      return const AssetImage('images/defaultImage.jpeg');
    }
  }
}
