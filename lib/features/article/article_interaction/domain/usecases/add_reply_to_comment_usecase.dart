
import 'package:dartz/dartz.dart';

import '../../../../../core/failures/failures.dart';
import '../../../../../core/success/success.dart';
import '../../../../../core/usecase/usecase.dart';
import '../entities/article_interaction.dart';
import '../repositories/article_interaction_repository.dart';

class AddReplyToCommentUseCase extends Usecase<Success, ArticleInteractionParams> {

  final ArticleInteractionRepository repository;

  AddReplyToCommentUseCase(this.repository);

  @override
  Future<Either<Failure, Success>> call(ArticleInteractionParams params)  async {

    return await repository.addReplyToComment(params);
  }

}