
import 'package:dartz/dartz.dart';

import '../../../../../core/failures/failures.dart';
import '../../../../../core/success/success.dart';
import '../../../../../core/usecase/usecase.dart';
import '../repositories/article_interaction_repository.dart';

class UnSaveArticleUseCase extends Usecase<Success, String> {

  final ArticleInteractionRepository repository;

  UnSaveArticleUseCase(this.repository);

  @override
  Future<Either<Failure, Success>> call(String articleId)  async {

    return await repository.unsaveArticle(articleId);
  }

}