import 'package:equatable/equatable.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}

class ChatLoading extends ChatState {}

class ChatSending extends ChatState {}

class ChatSent extends ChatState {}

class ChatError extends ChatState {
  final String message;
  const ChatError(this.message);
  @override
  List<Object?> get props => [message];
}
