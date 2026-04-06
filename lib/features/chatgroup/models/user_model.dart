class UserModel {
  final String id;
  final String name;
  final String email;
  final String? imageUrl;


  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.imageUrl,
  });


  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'email': email,
        'imageUrl': imageUrl,
      };


  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
        id: map['id'],
        name: map['name'],
        email: map['email'],
        imageUrl: map['imageUrl'],
      );
}
