import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instproject/features/auth/presentation/pages/profile_page.dart';
import 'package:instproject/features/posts/presentation/bloc/post_cubit.dart';
import 'package:instproject/features/posts/presentation/bloc/post_states.dart';
import 'package:instproject/features/posts/data/post_model.dart';


class SearchPostsPage extends StatefulWidget {
  const SearchPostsPage({super.key});

  @override
  State<SearchPostsPage> createState() => _SearchPostsPageState();
}

class _SearchPostsPageState extends State<SearchPostsPage> {
  String searchQuery = '';
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load posts when the page opens
    context.read<PostCubit>().fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, 
      appBar: AppBar(
        title: const Text("Search Posts"),
        backgroundColor: Colors.brown.shade800,
        elevation: 0,
      ),
      body: Column(
        children: [
          
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search ',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Colors.brown.shade700.withOpacity(0.3),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white),
                        onPressed: () {
                          _controller.clear();
                          setState(() => searchQuery = '');
                        },
                      )
                    : null,
              ),
              onChanged: (query) {
                setState(() => searchQuery = query.toLowerCase());
              },
            ),
          ),

          
          Expanded(
            child: BlocBuilder<PostCubit, PostStates>(
              builder: (context, state) {
                if (state is PostLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PostLoaded) {
                  final filteredPosts = state.posts.where((post) {
                    final query = searchQuery.toLowerCase();
                    return post.caption.toLowerCase().contains(query) ||
                        post.userName.toLowerCase().contains(query);
                  }).toList();


                  if (filteredPosts.isEmpty) {
                    return const Center(
                      child: Text(
                        'No posts found.',
                        style: TextStyle(color: Colors.white70),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    itemCount: filteredPosts.length,
                    itemBuilder: (context, index) {
                      final post = filteredPosts[index];
                      return PostTile(post: post);
                    },
                  );
                } else if (state is PostError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.redAccent),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}


class PostTile extends StatelessWidget {
  final Post post;

  const PostTile({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final userName = post.userName.isNotEmpty ? post.userName : 'Unknown User';
    final profileImage = post.userProfileImage.isNotEmpty
        ? post.userProfileImage
        : 'https://cdn-icons-png.flaticon.com/512/149/149071.png';
         final currentUser = FirebaseAuth.instance.currentUser;
    final currentUid = currentUser?.uid ?? '';

    final isLiked = post.likes.contains(currentUid);
    final isMark = post.isSaved;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: GestureDetector(
              onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfilePage(uid: post.userId)),
              );
            
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(profileImage),
                radius: 22,
              ),
            ),
            title: GestureDetector(
               onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProfilePage(uid: post.userId)),
              );
               },
              child: Text(
                userName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
           
           
          ),

          
        ],
      ),
    );
  }
}
