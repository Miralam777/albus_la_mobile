import 'package:albus_la_mobile/env/env.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/errors.dart';
import '../../../../configs/network/network.dart';
import '../../domain/entities/app_feedback.dart';

@factoryMethod
abstract class FeedbackRemoteData {
  Future<Unit> postFeedback(AppFeedback feedback);
}

@Injectable(as: FeedbackRemoteData)
class FeedbackRemoteDataImpl implements FeedbackRemoteData {
  final HttpApi client;
  FeedbackRemoteDataImpl(this.client);

  @override
  Future<Unit> postFeedback(AppFeedback feedback) async {
    final url = '${Env.apiUrl}feedback';

    final response = await client.post(
      url,
      feedback.copyWith(appId: Env.apiKey).toJson(),
    );

    return response.statusCode == 200
        ? Future.value(unit)
        : throw ServerException();
  }
}
