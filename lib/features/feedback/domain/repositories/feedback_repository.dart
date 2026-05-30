import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/errors.dart';
import '../entities/app_feedback.dart';

@factoryMethod
abstract class FeedbackRepository {
  Future<Either<Failure, Unit>> postFeedback(AppFeedback feedback);
}
