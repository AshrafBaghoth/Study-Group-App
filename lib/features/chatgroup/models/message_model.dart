import 'package:equatable/equatable.dart';

class MessageModel extends Equatable {
  final String id;
  final String senderId;
  final String senderName;
  final String text;
  final String? imageUrl;
  final DateTime timestamp;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.text,
    this.imageUrl,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'senderId': senderId,
    'senderName': senderName,
    'text': text,
    'imageUrl': imageUrl,
    'timestamp': timestamp.toIso8601String(),
  };

  factory MessageModel.fromMap(Map<String, dynamic> map) => MessageModel(
    id: map['id'] ?? '',
    senderId: map['senderId'] ?? '',
    senderName: map['senderName'] ?? '',
    text: map['text'] ?? '',
    imageUrl: map['imageUrl'],
    timestamp: DateTime.parse(map['timestamp']),
  );

  @override
  List<Object?> get props => [id, senderId, text, imageUrl, timestamp];
}
