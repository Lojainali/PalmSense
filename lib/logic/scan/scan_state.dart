import 'package:equatable/equatable.dart';
import '../../data/models/scan_model.dart';

enum ScanStatus { idle, analyzing, success }

class ScanState extends Equatable {
  final ScanStatus status;
  final ScanModel? result;

  const ScanState({this.status = ScanStatus.idle, this.result});

  ScanState copyWith({ScanStatus? status, ScanModel? result}) {
    return ScanState(status: status ?? this.status, result: result ?? this.result);
  }

  @override
  List<Object?> get props => [status, result];
}
