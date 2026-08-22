import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(),
        super(const AuthState());

  Future<void> login({required String email, required String password}) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      emit(state.copyWith(
          status: AuthStatus.failure, errorMessage: 'Please fill in all fields'));
      return;
    }
    emit(state.copyWith(status: AuthStatus.submitting));
    try {
      final credential = await _authRepository.signIn(
        email: email.trim(),
        password: password.trim(),
      );
      final user = UserModel(
        fullName: credential.user?.displayName ?? 'PalmSense User',
        email: credential.user?.email ?? email,
        farmName: 'Main Grove',
        totalScans: 0,
        diseasesFound: 0,
        farmBlocks: 2,
      );
      emit(state.copyWith(status: AuthStatus.authenticated, user: user));
    } catch (e) {
      emit(state.copyWith(
          status: AuthStatus.failure, errorMessage: _cleanFirebaseError(e)));
    }
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    if (fullName.trim().isEmpty ||
        email.trim().isEmpty ||
        password.trim().isEmpty) {
      emit(state.copyWith(
          status: AuthStatus.failure, errorMessage: 'Please fill in all fields'));
      return;
    }
    if (password != confirmPassword) {
      emit(state.copyWith(
          status: AuthStatus.failure, errorMessage: 'Passwords do not match'));
      return;
    }

    emit(state.copyWith(status: AuthStatus.submitting));
    try {
      await _authRepository.signUp(
        email: email.trim(),
        password: password.trim(),
        fullName: fullName.trim(),
      );
      final newUser = UserModel(
        fullName: fullName.trim(),
        email: email.trim(),
        farmName: 'Main Grove',
        totalScans: 0,
        diseasesFound: 0,
        farmBlocks: 2,
      );
      emit(state.copyWith(status: AuthStatus.authenticated, user: newUser));
    } catch (e) {
      emit(state.copyWith(
          status: AuthStatus.failure, errorMessage: _cleanFirebaseError(e)));
    }
  }

  Future<void> updateProfile({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? farmName,
  }) async {
    final current = state.user;
    if (current == null) return;
    final updated = current.copyWith(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      farmName: farmName,
    );
    emit(state.copyWith(user: updated));
    await _authRepository.updateProfile(
      fullName: fullName,
      phoneNumber: phoneNumber,
      farmName: farmName,
    );
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    emit(const AuthState());
  }

  static String _cleanFirebaseError(dynamic e) {
    final msg = e.toString();
    if (msg.contains('user-not-found')) return 'No user found with this email.';
    if (msg.contains('wrong-password')) return 'Incorrect password.';
    if (msg.contains('email-already-in-use')) return 'Email is already registered.';
    if (msg.contains('invalid-email')) return 'Invalid email address.';
    if (msg.contains('weak-password')) return 'Password should be at least 6 characters.';
    return msg.replaceAll(RegExp(r'\[.*?\]'), '').trim();
  }
}
