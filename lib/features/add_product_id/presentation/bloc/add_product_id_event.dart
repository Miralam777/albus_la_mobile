part of 'add_product_id_bloc.dart';

sealed class AddProductIdEvent extends Equatable {
  const AddProductIdEvent();

  @override
  List<Object> get props => [];
}

class GetAddProductIdEvent extends AddProductIdEvent {
  final AddProductId addQrcode;
  const GetAddProductIdEvent(this.addQrcode);

  @override
  List<Object> get props => [addQrcode];
}
