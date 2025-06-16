import 'package:equatable/equatable.dart';

abstract class LogsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LogsFetched extends LogsEvent {
  LogsFetched();
  
  @override
  List<Object?> get props => [];
} 