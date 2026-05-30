import 'package:albus_la_mobile/core/errors/failures.dart';
import 'package:albus_la_mobile/features/add_product_id/domain/entities/added_id.dart';
import 'package:albus_la_mobile/features/add_product_id/domain/repositories/add_product_id_repository.dart';
import 'package:albus_la_mobile/features/add_product_id/helpers/add_product_id.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddProductIdUsecase {
  final AddProductIdRepository repository;
  AddProductIdUsecase(this.repository);

  Future<Either<Failure, AddedId>> call(AddProductId addId) async =>
      await repository.addProductId(addId);
}
