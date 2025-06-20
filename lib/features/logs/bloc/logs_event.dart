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

class LogsPollingStarted extends LogsEvent {
  LogsPollingStarted({this.interval = const Duration(seconds: 30)});
  final Duration interval;
  
  @override
  List<Object?> get props => [interval];
}

class LogsPollingStop extends LogsEvent {
  LogsPollingStop();
  
  @override
  List<Object?> get props => [];
}

class LogsRefresh extends LogsEvent {
  LogsRefresh();
  
  @override
  List<Object?> get props => [];
} 