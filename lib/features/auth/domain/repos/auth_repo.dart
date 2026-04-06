import 'package:instproject/features/auth/domain/entities/app_user.dart';

abstract class AuthRepo {
  Future<AppUser?> LoginWithEmailAndPassword(String email, String password);
  Future<AppUser?> RegisterWithEmailAndPassword(
    String username,
    String email,
    String password,
  );
  
  Future<void> Logout();

  Future<AppUser?> getCurrentUser();
}
