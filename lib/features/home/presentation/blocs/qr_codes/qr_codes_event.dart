part of 'qr_codes_bloc.dart';

class QrCodesEvent extends Equatable {
  const QrCodesEvent();

  @override
  List<Object> get props => [];
}

class GetQrCodesEvent extends QrCodesEvent {
  final String uid;
  const GetQrCodesEvent(this.uid);

  @override
  List<Object> get props => [uid];
}
