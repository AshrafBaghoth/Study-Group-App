import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instproject/features/aistudy/ai_study_page.dart';
import 'package:instproject/features/auth/presentation/components/my_drawer.dart';
import 'package:instproject/features/posts/data/post_model.dart';
import 'package:instproject/features/posts/domain/post_repo.dart';
import 'package:instproject/features/storage/domain/storage_repo.dart';
import '../bloc/post_cubit.dart';
import '../components/post_tile.dart';

class FeedPage extends StatefulWidget {
  final String userId;
  const FeedPage({super.key, required this.userId});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  void initState() {
    super.initState();
    context.read<PostCubit>().fetchAllPosts();
  }

  @override
  Widget build(BuildContext context) {
    final postRepo = RepositoryProvider.of<PostRepo>(context);
    final storageRepo = RepositoryProvider.of<StorageRepo>(context);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('images/sg.png', width: 100, height: 100),
        centerTitle: true,
      ),
      drawer: MyDrawer(),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70.0, right: 8.0),
        child: SizedBox(
          height: 60,
          width: 60,
          child: FloatingActionButton(
            heroTag: null,
            backgroundColor: Theme.of(context).colorScheme.primary,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AiStudy()),
              );
            },
            child: ClipOval(
              child: Image.asset('images/sai.png', fit: BoxFit.contain),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: RefreshIndicator(
        onRefresh: () async {
          await context.read<PostCubit>().fetchAllPosts();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
      
              const Divider(height: 1),

              StreamBuilder<List<Post>>(
                stream: postRepo.streamAllPosts(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  final posts = snapshot.data ?? [];

                  if (posts.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(child: Text('No posts yet.')),
                    );
                  }

                  
                  return ListView.builder(
                    itemCount: posts.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final post = posts[index];
                      return PostTile(post: post);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
