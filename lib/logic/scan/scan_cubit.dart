import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/mock/mock_data.dart';
import 'scan_state.dart';

/// Drives the CameraScreen capture flow. There's no real ML backend yet,
/// so [capture] just simulates an "Analyzing..." delay before emitting a
/// mock detection result that ResultsScreen renders.
class ScanCubit extends Cubit<ScanState> {
  ScanCubit() : super(const ScanState());

  Future<void> capture() async {
    emit(state.copyWith(status: ScanStatus.analyzing));
    await Future.delayed(const Duration(seconds: 2));
    final result = MockData.simulateDetection();
    emit(state.copyWith(status: ScanStatus.success, result: result));
  }

  void reset() => emit(const ScanState());
}
