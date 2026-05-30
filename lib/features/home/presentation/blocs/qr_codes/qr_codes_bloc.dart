import 'package:albus_la_mobile/core/errors/failures.dart';
import 'package:albus_la_mobile/features/home/domain/entities/home_qr_code.dart';
import 'package:albus_la_mobile/features/home/domain/usecases/get_qr_codes_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'qr_codes_event.dart';
part 'qr_codes_state.dart';

@lazySingleton
class QrCodesBloc extends Bloc<QrCodesEvent, QrCodesState> {
  final GetQrCodesUsecase usecase;
  QrCodesBloc(this.usecase) : super(QrCodesInitial()) {
    on<QrCodesEvent>((event, emit) {
      if (event is GetQrCodesEvent) {
        emit(QrCodesLoading());
        try {
          print('1. Bloc try');
          _getV(event.uid);

          print('5. Bloc emit loaded');
          // emit(VehiclesLoaded(vs));
        } catch (_) {
          // TODO:
          print('ServerException catch');
          emit(QrCodesFailure(ServerFailure()));
        }

        /*         dataOrFailure.fold(
          (failure) => emit(VehiclesFailure(failure)),
          // (failure) => VehiclesFailure(failure),
          (streamVehicles) async {
            List<Vehicle> vehicles = [];
            await streamVehicles.listen((vehiclesList) {
              print('=> stream listen');
              print('vehiclesList');
              print(vehiclesList);
              vehicles = vehiclesList;
              // emit(VehiclesLoaded(vehiclesList));
              //  VehiclesLoaded(vehiclesList);
              // return emit(VehiclesLoaded(vehicles));
              return emit(VehiclesLoaded(vehiclesList));
            });
          },
        ); */
      }
    });
  }

  // Future<void> _getV(Stream<List<Vehicle>> stream) async {
  Future<void> _getV(String uid) async {
    final stream = await usecase.call(uid);
    print('2. Bloc get v');
    // List<Vehicle> vs = [];
    stream.listen((vehicles) {
      // vs = vehicles;
      print('3. Bloc listen');
      // emit(VehiclesLoaded(vs));
      emit(QrCodesLoaded(vehicles));
    });
    print('4. Bloc return vs');
    // return vs;
  }

  /*   VehiclesState _mapSigninOrFailureToState(
      // Either<Failure, List<Vehicle>> either) {
      Either<Failure, Stream<List<Vehicle>>> either) {
    print('=> in bloc  _mapSigninOrFailureToState(');
    return either.fold(
      (failure) => VehiclesFailure(failure),
      (streamVehicles) {
        List<Vehicle> vehicles = [];
        streamVehicles.listen((vehiclesList) {
          print('=> stream listen');
          print('vehiclesList');
          print(vehiclesList);
          vehicles = vehiclesList;
          emit(VehiclesLoaded(vehicles));
        });
        return VehiclesLoaded(vehicles);
      },
    );
  } */
}
