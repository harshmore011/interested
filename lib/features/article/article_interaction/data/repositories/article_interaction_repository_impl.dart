import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/failures/exceptions.dart';
import '../../../../../core/failures/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../../../../core/success/success.dart';
import '../../../../../core/utils/debug_logger.dart';
import '../../../entities/article_entity.dart';
import '../../domain/entities/article_interaction.dart';
import '../../domain/repositories/article_interaction_repository.dart';
import '../datasources/article_interaction_datasource.dart';

class ArticleInteractionRepositoryImpl implements ArticleInteractionRepository {
  final NetworkInfo networkInfo;
  final ArticleInteractionDataSource dataSource;

  ArticleInteractionRepositoryImpl(
      {required this.networkInfo, required this.dataSource});


  @override
  Future<Either<Failure, Success>> addReplyToComment(ArticleInteractionParams params) async {
    logger.log("ArticleInteractionRepositoryImpl:addReplyToComment()", "Started");
    if (await networkInfo.isConnected) {
      try {
        await dataSource.addReplyToComment(params);
        return Right(Success());
      } on ServerException {
        return Left(ServerFailure());
      } on UnAuthorizedException {
        return Left(UnAuthorizedFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> commentOnArticle(ArticleInteractionParams params) async {
    logger.log("ArticleInteractionRepositoryImpl:commentOnArticle()", "Started");
    if (await networkInfo.isConnected) {
      try {
        await dataSource.commentOnArticle(params);
        return Right(Success());
      } on ServerException {
        return Left(ServerFailure());
      } on UnAuthorizedException {
        return Left(UnAuthorizedFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, (List<Article>, QueryDocumentSnapshot<Map<String, dynamic>>?)>>
  getHomeArticlePage(ArticleInteractionParams params) async {
    logger.log("ArticleInteractionRepositoryImpl:getHomeArticlePage()", "Started");
    if (await networkInfo.isConnected) {
      try {
        return Right(await dataSource.getHomeArticlePage(params)
            .then((response) => (response.$1.map<Article>((e) => e.toEntity()).toList(),
        response.$2)));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> likeArticle(String id) async {
    logger.log("ArticleInteractionRepositoryImpl:likeArticle()", "Started");
    if (await networkInfo.isConnected) {
      try {
        await dataSource.likeArticle(id);
        return Right(Success());
      } on ServerException {
        return Left(ServerFailure());
      } on UnAuthorizedException {
        return Left(UnAuthorizedFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> saveArticle(String articleId) async {
    logger.log("ArticleInteractionRepositoryImpl:saveArticle()", "Started");
    if (await networkInfo.isConnected) {
      try {
        await dataSource.saveArticle(articleId);
        return Right(Success());
      } on ServerException {
        return Left(ServerFailure());
      } on UnAuthorizedException {
        return Left(UnAuthorizedFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> unlikeArticle(String id) async {
    logger.log("ArticleInteractionRepositoryImpl:unlikeArticle()", "Started");
    if (await networkInfo.isConnected) {
      try {
        await dataSource.unlikeArticle(id);
        return Right(Success());
      } on ServerException {
        return Left(ServerFailure());
      } on UnAuthorizedException {
        return Left(UnAuthorizedFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> unsaveArticle(String articleId) async {
    logger.log("ArticleInteractionRepositoryImpl:unsaveArticle()", "Started");
    if (await networkInfo.isConnected) {
      try {
        dataSource.unsaveArticle(articleId);
        return Right(Success());
      } on ServerException {
        return Left(ServerFailure());
      } on UnAuthorizedException {
        return Left(UnAuthorizedFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> viewArticle(String id) async {
    logger.log("ArticleInteractionRepositoryImpl:viewArticle()", "Started");
    if (await networkInfo.isConnected) {
      try {
       await dataSource.viewArticle(id);
        return Right(Success());
      } on ServerException {
        return Left(ServerFailure());
      } on UnAuthorizedException {
        return Left(UnAuthorizedFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }


}
