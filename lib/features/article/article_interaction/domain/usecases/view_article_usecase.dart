
import 'package:dartz/dartz.dart';

import '../../../../../core/failures/failures.dart';
import '../../../../../core/success/success.dart';
import '../../../../../core/usecase/usecase.dart';
import '../repositories/article_interaction_repository.dart';

class ViewArticleUseCase extends Usecase<Success, String> {

  final ArticleInteractionRepository repository;

  ViewArticleUseCase(this.repository);

  @override
  Future<Either<Failure, Success>> call(String articleId)  async {

    return await repository.viewArticle(articleId);
  }

}