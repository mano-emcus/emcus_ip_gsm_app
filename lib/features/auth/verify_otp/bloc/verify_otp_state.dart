import 'package:equatable/equatable.dart';

abstract class VerifyOtpState extends Equatable {
  const VerifyOtpState();

  @override
  List<Object> get props => [];
}

class VerifyOtpInitial extends VerifyOtpState {}

class VerifyOtpLoading extends VerifyOtpState {}

class VerifyOtpSuccess extends VerifyOtpState {
  const VerifyOtpSuccess({required this.message});
  final String message;

  @override
  List<Object> get props => [message];
}

class VerifyOtpFailure extends VerifyOtpState {
  const VerifyOtpFailure({required this.error});
  final String error;

  @override
  List<Object> get props => [error];
}
