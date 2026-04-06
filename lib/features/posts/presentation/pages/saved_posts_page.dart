import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/post_cubit.dart';
import '../bloc/post_states.dart';
import '../../data/post_model.dart';
import '../components/post_tile.dart';

class SavedPostsPage extends StatefulWidget {
  final String userId;
  const SavedPostsPage({super.key, required this.userId});

  @override
  State<SavedPostsPage> createState() => _SavedPostsPageState();
}

class _SavedPostsPageState extends State<SavedPostsPage> {
  List<Post> savedPosts = [];
  bool _isLoading = false;
  String? _error;

  Future<void> loadSaved() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final cubit = context.read<PostCubit>();
      final posts = await cubit.postRepo.getSavedPosts(widget.userId);

      if (!mounted) return;

      setState(() {
        savedPosts = posts;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadSaved();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostCubit, PostStates>(
      listener: (context, state) {
        if (state is SavedPostsUpdated && mounted) {
          loadSaved();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Saved Posts')),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(child: Text('Error: $_error'))
            : savedPosts.isEmpty
            ? const Center(child: Text('No saved posts yet.'))
            : RefreshIndicator(
                onRefresh: loadSaved,
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: savedPosts.length,
                  itemBuilder: (context, i) => PostTile(post: savedPosts[i]),
                ),
              ),
      ),
    );
  }
}
