import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/mock/mock_data.dart';
import '../../data/models/user_model.dart';
import 'auth_state.dart';

/// Handles Login / Sign Up / Sign Out. There is no backend yet, so
/// [login] and [signUp] simply validate input locally and simulate a
/// network delay before "authenticating" with the mock user profile.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(const AuthState());

  Future<void> login({required String email, required String password}) async {
    if (email.trim().isEmpty || password.trim().isEmpty) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: 'Please fill in all fields'));
      return;
    }
    emit(state.copyWith(status: AuthStatus.submitting));
    await Future.delayed(const Duration(milliseconds: 900));
    emit(state.copyWith(status: AuthStatus.authenticated, user: MockData.currentUser));
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    required bool agreedToTerms,
  }) async {
    if (fullName.trim().isEmpty || email.trim().isEmpty || password.trim().isEmpty) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: 'Please fill in all fields'));
      return;
    }
    if (password != confirmPassword) {
      emit(state.copyWith(status: AuthStatus.failure, errorMessage: 'Passwords do not match'));
      return;
    }
    if (!agreedToTerms) {
      emit(state.copyWith(
        status: AuthStatus.failure,
        errorMessage: 'Please agree to the Terms of Service',
      ));
      return;
    }
    emit(state.copyWith(status: AuthStatus.submitting));
    await Future.delayed(const Duration(milliseconds: 900));
    final newUser = UserModel(
      fullName: fullName,
      email: email,
      farmName: MockData.currentUser.farmName,
      totalScans: 0,
      diseasesFound: 0,
      farmBlocks: MockData.currentUser.farmBlocks,
    );
    emit(state.copyWith(status: AuthStatus.authenticated, user: newUser));
  }

  void updateProfile({String? fullName, String? email, String? farmName}) {
    final current = state.user;
    if (current == null) return;
    emit(state.copyWith(
      user: current.copyWith(fullName: fullName, email: email, farmName: farmName),
    ));
  }

  void signOut() {
    emit(const AuthState());
  }
}
