import 'package:flutter_bloc/flutter_bloc.dart';

/// Index of the currently visible tab inside [MainShell].
/// 0 = Home, 1 = Library, 2 = Profile.
/// "Scan" is not a tab — it pushes the full-screen CameraScreen instead.
class MainNavCubit extends Cubit<int> {
  MainNavCubit() : super(0);

  void goToHome() => emit(0);
  void goToLibrary() => emit(1);
  void goToProfile() => emit(2);
  void setIndex(int index) => emit(index);
}
