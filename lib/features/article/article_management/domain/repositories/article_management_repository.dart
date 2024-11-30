
import 'package:dartz/dartz.dart';
import 'package:interested/core/failures/failures.dart';

import '../../../../../core/success/success.dart';
import '../../../article.dart';
import '../../../entities/article_entity.dart';

abstract class ArticleManagementRepository {

  Future<Either<Failure, Success>> createDraftArticle(ArticleParams params);
  Future<Either<Failure, List<Article>>> getDraftArticles();
  Future<Either<Failure, Success>> schedulePublishArticle(ArticleParams params);
  Future<Either<Failure, List<Article>>> getScheduledArticles();
  Future<Either<Failure, Success>> publishArticle(String articleId);
  Future<Either<Failure, List<Article>>> getPublishedArticles();
  Future<Either<Failure, Success>> unpublishArticle(String articleId);
  Future<Either<Failure, Success>> updateArticle(ArticleParams params);
  Future<Either<Failure, Success>> deleteArticle(String articleId);

}
