part of 'add_product_id_bloc.dart';

abstract class AddProductIdState extends Equatable {
  const AddProductIdState();

  @override
  List<Object> get props => [];
}

class AddProductIdInitial extends AddProductIdState {}

class AddProductIdLoading extends AddProductIdState {}

class AddProductIdAdded extends AddProductIdState {
  final AddedId addedId;
  const AddProductIdAdded(this.addedId);

  @override
  List<Object> get props => [addedId];
}

class AddProductIdFailure extends AddProductIdState {
  final Failure failure;
  const AddProductIdFailure(this.failure);

  @override
  List<Object> get props => [failure];
}
