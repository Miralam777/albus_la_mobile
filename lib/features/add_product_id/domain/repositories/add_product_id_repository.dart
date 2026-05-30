import 'package:albus_la_mobile/core/errors/failures.dart';
import 'package:albus_la_mobile/features/add_product_id/domain/entities/added_id.dart';
import 'package:albus_la_mobile/features/add_product_id/helpers/add_product_id.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@factoryMethod
abstract class AddProductIdRepository {
  Future<Either<Failure, AddedId>> addProductId(AddProductId addId);
}
