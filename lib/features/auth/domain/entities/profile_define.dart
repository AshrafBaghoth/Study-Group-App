class ProfileDefine {
  final String name;
  final String email;
  final String bio;

  ProfileDefine({required this.name, required this.email, required this.bio});

  Map<String, dynamic> toJson() => {'name': name, 'email': email, 'bio': bio};

  factory ProfileDefine.fromJson(Map<String, dynamic> json) =>
      ProfileDefine(
        name: json['name'] ?? "",
         email: json['email'] ?? "",
          bio: json['bio'] ?? "");
}
