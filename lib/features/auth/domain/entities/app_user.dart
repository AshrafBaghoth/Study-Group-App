class AppUser {
  final String uid;
  final String name;
  final String email;
  final String bio;
  final String profileImg;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.bio,
    required this.profileImg,
  });

  AppUser copyWith({
    String? name,
    String? email,
    String? bio,
    String? profileImg,
  }) {
    return AppUser(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      profileImg: profileImg ?? this.profileImg,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'bio': bio,
      'profileImg': profileImg,
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      bio: map['bio'] ?? '',
      profileImg: map['profileImg'] ?? '',
    );
  }
}
