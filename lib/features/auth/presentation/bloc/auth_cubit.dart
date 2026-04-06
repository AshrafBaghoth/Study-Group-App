import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instproject/features/auth/domain/entities/app_user.dart';
import 'package:instproject/features/auth/domain/repos/auth_repo.dart';
import 'package:instproject/features/auth/presentation/bloc/auth_states.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  AppUser? _currentUser;

  AuthCubit({required this.authRepo}) : super(AuthInitial());

  AppUser? get currentUser => _currentUser;

 
  Future<void> checkAuth() async {
    try {
      emit(AuthLoading());
      final user = await authRepo.getCurrentUser();
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthErorr('Failed to check auth: $e'));
    }
  }

  
  Future<void> register(String name, String email, String pass) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.RegisterWithEmailAndPassword(
        name,
        email,
        pass,
      );
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthErorr('Registration failed: $e'));
    }
  }

  
  Future<void> login(String email, String pass) async {
    try {
      emit(AuthLoading());
      final user = await authRepo.LoginWithEmailAndPassword(email, pass);
      if (user != null) {
        _currentUser = user;
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthErorr('Login failed: $e'));
    }
  }

  Future<void> logout() async {
    try {
      await authRepo.Logout();
      _currentUser = null;
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthErorr('Failed to log out: $e'));
    }
  }
}
