import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../../../configs/network/network.dart';
import '../../../../configs/services/user_agent_service.dart';
import '../../domain/entities/app_feedback.dart';
import '../../domain/repositories/feedback_repository.dart';
import '../datasources/feedback_remote_data.dart';

@Injectable(as: FeedbackRepository)
class FeedbackRepositoryImpl implements FeedbackRepository {
  final NetworkInfo networkInfo;
  final FeedbackRemoteData remoteData;
  final UserAgentService userAgent;
  FeedbackRepositoryImpl(this.remoteData, this.networkInfo, this.userAgent);

  @override
  Future<Either<Failure, Unit>> postFeedback(AppFeedback feedback) async {
    if (await networkInfo.isConnected) {
      try {
        await remoteData.postFeedback(feedback.copyWith(
            userAgent: await userAgent.userAgentForFeedback()));
        return const Right(unit);
      } catch (_) {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }
}
