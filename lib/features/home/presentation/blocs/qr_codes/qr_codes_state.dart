part of 'qr_codes_bloc.dart';

class QrCodesState extends Equatable {
  const QrCodesState();

  @override
  List<Object> get props => [];
}

class QrCodesInitial extends QrCodesState {}

class QrCodesLoading extends QrCodesState {}

class QrCodesLoaded extends QrCodesState {
  final List<HomeQrCode> qrCodes;
  const QrCodesLoaded(this.qrCodes);

  @override
  List<Object> get props => [qrCodes];
}

class QrCodesFailure extends QrCodesState {
  final Failure failure;
  const QrCodesFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
