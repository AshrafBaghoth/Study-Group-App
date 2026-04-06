import 'package:equatable/equatable.dart';

class GroupModel extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String imageUrl;
  final String? lastMessage;
  final String? lastSender;
  final List<String> members;
  final DateTime? createdAt;

  const GroupModel({
    required this.id,
    required this.name,
    this.description,
    required this.imageUrl,
    this.lastMessage,
    this.lastSender,
    required this.members,
    this.createdAt,
  });

  
  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'description': description ?? '',
    'imageUrl': imageUrl,
    'lastMessage': lastMessage ?? '',
    'lastSender': lastSender ?? '',
    'members': members,
    'createdAt': createdAt?.millisecondsSinceEpoch,
  };

  
  factory GroupModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return GroupModel(
      id: id ?? map['id'] ?? '',
      name: map['name'] ?? '',
      description: (map['description'] is String) ? map['description'] : null,
      imageUrl: map['imageUrl'] ?? '',
      lastMessage: (map['lastMessage'] is String) ? map['lastMessage'] : null,
      lastSender: (map['lastSender'] is String) ? map['lastSender'] : null,
      members: List<String>.from(map['members'] ?? []),
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(
              (map['createdAt'] is int)
                  ? map['createdAt']
                  : int.tryParse(map['createdAt'].toString()) ?? 0,
            )
          : null,
    );
  }

 
  bool matchesQuery(String query) {
    final q = query.toLowerCase();
    final inName = name.toLowerCase().contains(q);
    final inDesc = (description?.toLowerCase().contains(q)) ?? false;
    final inLast = (lastMessage?.toLowerCase().contains(q)) ?? false;
    return inName || inDesc || inLast;
  }

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    lastMessage,
    lastSender,
    members,
  ];
}
