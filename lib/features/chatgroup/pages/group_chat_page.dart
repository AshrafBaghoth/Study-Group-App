import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instproject/features/chatgroup/cubit/group_cubit.dart';
import 'package:instproject/features/chatgroup/cubit/chat_cubit.dart';
import 'package:instproject/features/chatgroup/data/fire_chat_repo.dart';
import 'package:instproject/features/chatgroup/pages/chat_page.dart';
import '../widgets/group_tile.dart';
import 'create_group_page.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({super.key});

  @override
  State<GroupsPage> createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Groups"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<GroupCubit>().refreshGroups(),
          ),
        ],
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(
          bottom: 70.0,
          right: 8.0,
        ), 
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CreateGroupPage()),
            );
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: Column(
        children: [
          
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: (query) {
                context.read<GroupCubit>().searchGroups(query);
              },
              decoration: InputDecoration(
                hintText: 'Search groups...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Theme.of(
                  context,
                ).colorScheme.surface.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          
          Expanded(
            child: BlocBuilder<GroupCubit, GroupState>(
              builder: (context, state) {
                if (state is GroupLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is GroupError) {
                  return Center(child: Text(state.message));
                }

                if (state is GroupLoaded) {
                  final groups = state.groups;

                  if (groups.isEmpty) {
                    return const Center(
                      child: Text(
                        'No groups found',
                        style: TextStyle(fontSize: 16),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, i) {
                      final group = groups[i];
                      return GroupTile(
                        group: group,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (_) => ChatCubit(
                                  repo: context.read<FireChatRepo>(),
                                  groupId: group.id,
                                ),
                                child: ChatPage(group: group),
                              ),
                            ),
                          );
                        },
                      );
                    },
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
