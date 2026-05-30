import 'package:albus_la_mobile/core/errors/failures.dart';
import 'package:albus_la_mobile/features/add_product_id/domain/entities/added_id.dart';
import 'package:albus_la_mobile/features/add_product_id/domain/usecases/add_product_id_usecase.dart';
import 'package:albus_la_mobile/features/add_product_id/helpers/add_product_id.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'add_product_id_event.dart';
part 'add_product_id_state.dart';

@lazySingleton
class AddProductIdBloc extends Bloc<AddProductIdEvent, AddProductIdState> {
  final AddProductIdUsecase usecase;
  AddProductIdBloc(this.usecase) : super(AddProductIdInitial()) {
    on<AddProductIdEvent>((event, emit) async {
      if (event is GetAddProductIdEvent) {
        emit(AddProductIdLoading());
        final addedOrFailure = await usecase.call(event.addQrcode);
        emit(
          addedOrFailure.fold(
            (failure) => AddProductIdFailure(failure),
            (addedQrcode) => AddProductIdAdded(addedQrcode),
          ),
        );
      }
    });
  }
}
