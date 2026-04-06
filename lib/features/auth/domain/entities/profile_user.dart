// import 'package:instproject/features/auth/domain/entities/app_user.dart';

// class ProfileUser extends AppUser {
//   final String bio;
//   final String profileImg;

//   ProfileUser({
//     required super.uid,
//     required super.name,
//     required super.email,
//     required this.bio,
//     required this.profileImg,
//   });

//   ProfileUser copyWith({String? newBio, String? newProfileImg, required String bio, required String profileImg}) {
//     return ProfileUser(
//       uid: uid,
//       name: name,
//       email: email,
//       bio: newBio ?? bio,
//       profileImg: newProfileImg ?? profileImg,
//     );
//   }

//   Map<String, dynamic> toJson() => {
//     'uid': uid,
//     'name': name,
//     'email': email,
//     'bio': bio,
//     'profileImg': profileImg,
//   };

//   factory ProfileUser.fromJson(Map<String, dynamic> json) => ProfileUser(
//     uid: json['uid'],
//     name: json['name'] ,
//     email: json['email'],
//     bio: json['bio'] ?? '',
//     profileImg: json['profileImg'] ?? '',
//   );

  
// }
