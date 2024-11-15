import 'package:dartz/dartz.dart';

import '../../../../../core/failures/exceptions.dart';
import '../../../../../core/failures/failures.dart';
import '../../../../../core/network/network_info.dart';
import '../../../../../core/success/success.dart';
import '../../../../../core/utils/debug_logger.dart';
import '../../../article.dart';
import '../../../entities/article_entity.dart';
import '../../../models/article_model.dart';
import '../../domain/repositories/article_management_repository.dart';
import '../datasources/article_management_datasource.dart';

class ArticleManagementRepositoryImpl implements ArticleManagementRepository {
  final NetworkInfo networkInfo;
  final ArticleManagementDataSource articleManagementDataSource;

  ArticleManagementRepositoryImpl(
      {required this.networkInfo, required this.articleManagementDataSource});

  @override
  Future<Either<Failure, Success>> createDraftArticle(ArticleParams params) async {
    logger.log("ArticleManagementRepositoryImpl:createDraftArticle()", "Started");
    if (await networkInfo.isConnected) {
      try {
      await articleManagementDataSource.createDraftArticle(params);
      return Right(Success());
    } on ServerException {
      return Left(ServerFailure());
    } on NoUserException {
      return Left(NoUserFailure());
    }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> deleteArticle(String id) async {
    logger.log("ArticleManagementRepositoryImpl:deleteArticle()", "Started");
    if (await networkInfo.isConnected) {
      try {
        await articleManagementDataSource.deleteArticle(id);
        return Right(Success());
      } on ServerException {
        return Left(ServerFailure());
      } on NoUserException {
        return Left(NoUserFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> publishArticle(String id) async {
    logger.log("ArticleManagementRepositoryImpl:publishArticle()", "Started");
    if (await networkInfo.isConnected) {
      try {
        await articleManagementDataSource.publishArticle(id);
        return Right(Success());
      } on ServerException {
        return Left(ServerFailure());
      } on NoUserException {
        return Left(NoUserFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> schedulePublishArticle(ArticleParams params) async {
    logger.log("ArticleManagementRepositoryImpl:schedulePublishArticle()", "Started");
    if (await networkInfo.isConnected) {
      try {
        await articleManagementDataSource.schedulePublishArticle(params);
        return Right(Success());
      } on ServerException {
        return Left(ServerFailure());
      } on NoUserException {
        return Left(NoUserFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> unpublishArticle(String id) async {
    logger.log("ArticleManagementRepositoryImpl:unpublishArticle()", "Started");
    if (await networkInfo.isConnected) {
      try {
        await articleManagementDataSource.unpublishArticle(id);
        return Right(Success());
      } on ServerException {
        return Left(ServerFailure());
      } on NoUserException {
        return Left(NoUserFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Success>> updateArticle(ArticleParams params) async {
    logger.log("ArticleManagementRepositoryImpl:updateArticle()", "Started");
    if (await networkInfo.isConnected) {
      try {
        await articleManagementDataSource.updateArticle(params);
        return Right(Success());
      } on ServerException {
        return Left(ServerFailure());
      } on NoUserException {
        return Left(NoUserFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<Article>>> getDraftArticles() async {
    logger.log("ArticleManagementRepositoryImpl:getDraftArticles()", "Started");

    if (await networkInfo.isConnected) {
      try {
        List<ArticleModel> articleModels = await articleManagementDataSource.getDraftArticles();
        List<Article> articles = articleModels.map((e) => e.toEntity()).toList();
        return Right(articles);
      } on ServerException {
        return Left(ServerFailure());
      } on NoUserException {
        return Left(NoUserFailure());
      }
    } else {
      return Left(OfflineFailure());
    }

  }

  @override
  Future<Either<Failure, List<Article>>> getPublishedArticles() async {
    logger.log("ArticleManagementRepositoryImpl:getPublishedArticles()", "Started");
    if (await networkInfo.isConnected) {
      try {
        List<ArticleModel> articleModels = await articleManagementDataSource.getPublishedArticles();
        List<Article> articles = articleModels.map((e) => e.toEntity()).toList();
        return Right(articles);
      } on ServerException {
        return Left(ServerFailure());
      } on NoUserException {
        return Left(NoUserFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, List<Article>>> getScheduledArticles() async {
    logger.log("ArticleManagementRepositoryImpl:getScheduledArticles()", "Started");

    if (await networkInfo.isConnected) {
      try {
        List<ArticleModel> articleModels = await articleManagementDataSource.getScheduledArticles();
        List<Article> articles = articleModels.map((e) => e.toEntity()).toList();
        return Right(articles);
      } on ServerException {
        return Left(ServerFailure());
      } on NoUserException {
        return Left(NoUserFailure());
      }
    } else {
      return Left(OfflineFailure());
    }
  }


}
