import 'package:instproject/features/auth/domain/entities/app_user.dart';


abstract class ProfileStates {}

class ProfileInitial extends ProfileStates {}

class ProfileLoading extends ProfileStates {}

class ProfileLoaded extends ProfileStates {
  final AppUser appUser;
  ProfileLoaded(this.appUser);
}

class ProfileError extends ProfileStates {
  final String message;
  ProfileError(this.message);
}
