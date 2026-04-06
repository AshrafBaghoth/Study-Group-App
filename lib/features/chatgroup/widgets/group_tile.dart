import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instproject/features/chatgroup/cubit/group_cubit.dart';
import 'package:instproject/features/chatgroup/models/group_model.dart';

class GroupTile extends StatelessWidget {
  final GroupModel group;
  final VoidCallback onTap;

  const GroupTile({super.key, required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 26,
        backgroundImage: group.imageUrl.isNotEmpty
            ? NetworkImage(group.imageUrl)
            : const AssetImage('assets/default_group.png') as ImageProvider,
        child: group.imageUrl.isEmpty
            ? const Icon(Icons.group, color: Colors.white)
            : null,
      ),
      title: Text(
        group.name,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      // subtitle: Text(
      //   group.description?.isNotEmpty == true
      //       ? group.description!
      //       : (group.lastMessage?.isNotEmpty == true
      //             ? group.lastMessage!
      //             : 'No messages yet'),
      //   maxLines: 1,
      //   overflow: TextOverflow.ellipsis,
      // ),
      // trailing: SizedBox(
      //   width: 100,
      //   child: ElevatedButton(
      //     style: ElevatedButton.styleFrom(
      //       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      //       textStyle: const TextStyle(fontSize: 13),
      //     ),
      //     onPressed: currentUserId == null
      //         ? null
      //         : () {
      //             context.read<GroupCubit>().joinGroup(group.id, currentUserId);
      //           },
      //     child: const Text('Join'),
      //   ),
      // ),
    );
  }
}
