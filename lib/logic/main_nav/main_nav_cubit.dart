import 'package:flutter_bloc/flutter_bloc.dart';


class MainNavCubit extends Cubit<int> {
  MainNavCubit() : super(0);

  void goToHome() => emit(0);
  void goToLibrary() => emit(1);
  void goToProfile() => emit(2);
  void setIndex(int index) => emit(index);
}
