import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instproject/features/chatgroup/cubit/chat_cubit.dart';
import '../widgets/message_bubble.dart';
import '../../chatgroup/models/group_model.dart';

class ChatPage extends StatefulWidget {
  final GroupModel group;
  const ChatPage({super.key, required this.group});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final controller = TextEditingController();
  File? _selectedImage; 

  
  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatCubit = context.read<ChatCubit>();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage:
                  widget.group.imageUrl != null &&
                      widget.group.imageUrl!.isNotEmpty
                  ? NetworkImage(widget.group.imageUrl!)
                  : null,
              child:
                  widget.group.imageUrl == null ||
                      widget.group.imageUrl!.isEmpty
                  ? const Icon(Icons.group)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                widget.group.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),

      body: Column(
        children: [
          
          Expanded(
            child: StreamBuilder(
              stream: chatCubit.messagesStream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final msgs = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  itemCount: msgs.length,
                  itemBuilder: (_, i) => MessageBubble(msg: msgs[i]),
                );
              },
            ),
          ),

          
          if (_selectedImage != null)
            Stack(
              alignment: Alignment.topRight,
              children: [
                Container(
                  margin: const EdgeInsets.all(8),
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: FileImage(_selectedImage!),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: () {
                    setState(() => _selectedImage = null);
                  },
                ),
              ],
            ),

          
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: _pickImage, 
                ),
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Type a message...",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final text = controller.text.trim();

                    if (_selectedImage != null) {
                      
                      chatCubit.sendImage(_selectedImage!);
                      setState(() => _selectedImage = null);
                    }

                    if (text.isNotEmpty) {
                      chatCubit.sendText(text);
                      controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
