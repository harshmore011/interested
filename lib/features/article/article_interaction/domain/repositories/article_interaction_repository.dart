
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/failures/failures.dart';
import '../../../../../core/success/success.dart';
import '../../../entities/article_entity.dart';
import '../entities/article_interaction.dart';

abstract class ArticleInteractionRepository {

  Future<Either<Failure, (List<Article>, QueryDocumentSnapshot<Map<String, dynamic>>?)>>
  getHomeArticlePage(ArticleInteractionParams params);
  // Future<Either<Failure, List<Article>>> getHomeInterestLabels();
  Future<Either<Failure, Success>> viewArticle(
      String id);
  Future<Either<Failure, Success>> likeArticle(String id);
  Future<Either<Failure, Success>> unlikeArticle(String id);
  Future<Either<Failure, Success/*/Comment*/>>
  commentOnArticle(ArticleInteractionParams params/*String id, Comment comment*/);
  Future<Either<Failure, Success>>
  addReplyToComment(ArticleInteractionParams params/*String articleId,Comment comment*/);
  Future<Either<Failure, Success>> saveArticle(String articleId);
  Future<Either<Failure, Success>> unsaveArticle(String articleId);
  // Future<void> shareArticle();

}
