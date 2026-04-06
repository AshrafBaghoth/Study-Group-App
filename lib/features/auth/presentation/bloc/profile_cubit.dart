import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instproject/features/storage/domain/storage_repo.dart';
import '../../domain/repos/profile_repo.dart';

import 'profile_states.dart';

class ProfileCubit extends Cubit<ProfileStates> {
  final ProfileRepo profileRepo;
  final StorageRepo storageRepo;

  ProfileCubit({required this.profileRepo, required this.storageRepo})
    : super(ProfileInitial());

  Future<void> fetchUserProfile(String uid) async {
    try {
      emit(ProfileLoading());
      final user = await profileRepo.fetchUserProfile(uid);

      if (user != null) {
        emit(ProfileLoaded(user));
      } else {
        emit(ProfileError('Profile not found in Firestore'));
      }
    } catch (e) {
      emit(ProfileError('Error fetching profile: $e'));
    }
  }

  Future<void> updateProfile({
    required String uid,
    String? newBio,
    String? imageMobilePath,
  }) async {
    emit(ProfileLoading());

    try {
      final currentUser = await profileRepo.fetchUserProfile(uid);
      if (currentUser == null) {
        emit(ProfileError('User profile not found'));
        return;
      }

      String? imageDownloadUrl;

      
      if (imageMobilePath != null && imageMobilePath.isNotEmpty) {
        imageDownloadUrl = await storageRepo.uploadProfileImageMobile(
          imageMobilePath,
          uid,
        );

        if (imageDownloadUrl == null) {
          emit(ProfileError('Failed to upload image'));
          return;
        }
      }

     
      final updatedUser = currentUser.copyWith(
        bio: newBio ?? currentUser.bio,
        profileImg: imageDownloadUrl ?? currentUser.profileImg,
      );

      
      await profileRepo.updateProfile(updatedUser);

      
      await fetchUserProfile(uid);
    } catch (e) {
      emit(ProfileError('Error updating profile: $e'));
    }
  }
}
