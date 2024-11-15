
import 'package:dartz/dartz.dart';

import '../../../../../core/failures/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../entities/article_entity.dart';
import '../repositories/article_management_repository.dart';

class GetPublishedArticlesUseCase extends Usecase<List<Article>, Unit> {

  final ArticleManagementRepository repository;

  GetPublishedArticlesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Article>>> call(Unit unit)  async {

    return await repository.getPublishedArticles();
  }

}