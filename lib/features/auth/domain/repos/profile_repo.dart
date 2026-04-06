
import 'package:instproject/features/auth/domain/entities/app_user.dart';


abstract class ProfileRepo {
  Future<AppUser?> fetchUserProfile(String uid);
   Future<void> updateProfile(AppUser updateProfile);


}


