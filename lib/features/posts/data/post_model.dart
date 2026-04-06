class Post {
  final String id;
  final String userId;
  final String userName;
  final String userProfileImage;
  final String caption;
  final String imageUrl;
  final int createdAt;
  final int likeCount;
  final bool isSaved; 
  final List<String> likes;
  final List<String> savedBy; 

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userProfileImage,
    required this.caption,
    required this.imageUrl,
    required this.createdAt,
    this.likeCount = 0,
    this.isSaved = false,
    this.likes = const [],
    this.savedBy = const [],
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'userName': userName,
    'userProfileImage': userProfileImage,
    'caption': caption,
    'imageUrl': imageUrl,
    'createdAt': createdAt,
    'likeCount': likeCount,
    'likes': likes,
    'isSaved': isSaved,
    'savedBy': savedBy, 
  };

  factory Post.fromMap(Map<String, dynamic> map) => Post(
    id: map['id'] ?? '',
    userId: map['userId'] ?? '',
    userName: map['userName'] ?? '',
    userProfileImage: map['userProfileImage'] ?? '',
    caption: map['caption'] ?? '',
    imageUrl: map['imageUrl'] ?? '',
    createdAt: (map['createdAt'] is int)
        ? map['createdAt']
        : int.tryParse(map['createdAt'].toString()) ?? 0,
    likeCount: map['likeCount'] ?? 0,
    likes: map['likes'] != null ? List<String>.from(map['likes']) : [],
    isSaved: map['isSaved'] ?? false,
    savedBy: map['savedBy'] != null ? List<String>.from(map['savedBy']) : [],
  );

  Post copyWith({bool? isSaved, List<String>? likes, List<String>? savedBy}) {
    return Post(
      id: id,
      userId: userId,
      userName: userName,
      userProfileImage: userProfileImage,
      caption: caption,
      imageUrl: imageUrl,
      createdAt: createdAt,
      likeCount: likeCount,
      isSaved: isSaved ?? this.isSaved,
      likes: likes ?? this.likes,
      savedBy: savedBy ?? this.savedBy,
    );
  }

 
  bool isLikedBy(String uid) => likes.contains(uid);
  // bool isSavedBy(String uid) => savedBy.contains(uid);
  bool isSavedBy(String userId) => savedBy.contains(userId);

}
