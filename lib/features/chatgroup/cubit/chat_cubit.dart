import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instproject/core/rebos/appwrite_storage_api.dart';
import 'package:instproject/features/chatgroup/cubit/chat_state.dart';
import 'package:instproject/features/chatgroup/data/fire_chat_repo.dart';
import 'package:instproject/features/chatgroup/models/message_model.dart';
import 'dart:io';

class ChatCubit extends Cubit<ChatState> {
  final FireChatRepo repo;
  final String groupId;

  ChatCubit({required this.repo, required this.groupId}) : super(ChatLoading());

  Stream<List<MessageModel>> get messagesStream => repo.streamMessages(groupId);

  Future<void> sendText(String text) async {
    final user = FirebaseAuth.instance.currentUser!;
    final msg = MessageModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: user.uid,
      senderName: user.displayName ?? user.email ?? 'User',
      text: text,
      timestamp: DateTime.now(),
    );
    await repo.sendMessage(groupId, msg);
  }

  Future<void> sendImage(File file) async {
    try {
      emit(ChatSending());
      final url = await AppwriteStorageAPI.uploadImage(
        file,
        file.path.split('/').last,
      );
      if (url == null) throw Exception("Upload failed");

      final user = FirebaseAuth.instance.currentUser!;
      final msg = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: user.uid,
        senderName: user.displayName ?? user.email ?? 'User',
        text: '',
        imageUrl: url,
        timestamp: DateTime.now(),
      );
      await repo.sendMessage(groupId, msg);
      emit(ChatSent());
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}
