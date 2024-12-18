
import 'package:dartz/dartz.dart';

import '../../../../../core/failures/failures.dart';
import '../../../../../core/success/success.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../article.dart';
import '../repositories/article_management_repository.dart';

class UpdateArticleUseCase extends Usecase<Success, ArticleParams> {

  final ArticleManagementRepository repository;

  UpdateArticleUseCase(this.repository);

  @override
  Future<Either<Failure, Success>> call(ArticleParams params)  async {

    return await repository.updateArticle(params);
  }

}