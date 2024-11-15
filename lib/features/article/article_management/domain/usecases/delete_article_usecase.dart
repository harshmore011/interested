
import 'package:dartz/dartz.dart';

import '../../../../../core/failures/failures.dart';
import '../../../../../core/success/success.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../article.dart';
import '../repositories/article_management_repository.dart';

class DeleteArticleUseCase extends Usecase<Success, String> {

  final ArticleManagementRepository repository;

  DeleteArticleUseCase(this.repository);

  @override
  Future<Either<Failure, Success>> call(String articleId)  async {

    return await repository.deleteArticle(articleId);
  }

}