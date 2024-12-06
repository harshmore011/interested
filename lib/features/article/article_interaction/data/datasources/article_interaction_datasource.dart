import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/di/dependency_injector.dart';
import '../../../../../core/failures/exceptions.dart';
import '../../../../../core/utils/debug_logger.dart';
import '../../../../../core/utils/shared_pref_helper.dart';
import '../../../../authentication/domain/entities/anonymous_entity.dart';
import '../../../../authentication/domain/entities/user_entity.dart';
import '../../../article.dart';
import '../../../models/article_model.dart';
import '../../domain/entities/article_interaction.dart';

abstract class ArticleInteractionDataSource {
  Future<(List<ArticleModel>, QueryDocumentSnapshot<Map<String, dynamic>>?)>
      getHomeArticlePage(ArticleInteractionParams params);

  // Future<Either<Failure, List<Article>>> getHomeInterestLabels();
  // Future<Either<Failure, Article>> viewArticle(String id);
  Future<void> viewArticle(String id);

  Future<void> likeArticle(String id);

  Future<void> unlikeArticle(String id);

  Future<void /*/Comment*/ > commentOnArticle(
      ArticleInteractionParams params /*String id, Comment comment*/);

  Future<void> addReplyToComment(
      ArticleInteractionParams params /*String articleId,Comment comment*/);

  Future<void> saveArticle(String articleId);

  Future<void> unsaveArticle(String articleId);
// Future<void> shareArticle();
}

class ArticleInteractionDataSourceImpl implements ArticleInteractionDataSource {
  // Need to implement pagination
  @override
  Future<(List<ArticleModel>, QueryDocumentSnapshot<Map<String, dynamic>>?)>
      getHomeArticlePage(ArticleInteractionParams params) async {
    logger.log("ArticleInteractionDataSource:getHomeArticlePage()", "Started");

    (List<ArticleModel>, QueryDocumentSnapshot<Map<String, dynamic>>?) response;
    List<ArticleModel> articles = [];

    // try {
    QueryDocumentSnapshot<Map<String, dynamic>>? nextLastDoc;

    if (params.lastDoc == null) {
      logger.log("ArticleInteractionDataSource:getHomeArticlePage()",
          "last doc == null");
      var snapshot = await FirebaseFirestore.instance
          .collection("articles")
          .where("currentPublishState",
              isEqualTo: ArticlePublishState.published.name)
          .orderBy("dateTimePublished", descending: true)
          // .startAfter(values)
          .limit(params.pageLength)
          .get();
      logger.log("ArticleInteractionDataSource:getHomeArticlePage()",
          "total articles: ${snapshot.docs.length}");
      nextLastDoc = snapshot.docs.lastOrNull;

      for (var article in snapshot.docs) {
        await article.reference.collection("comments").get().then((comments) {
          ArticleModel articleModel = ArticleModel.fromJson(article.data());
          articleModel.commentModels.addAll(comments.docs
              .map((comment) => CommentModel.fromJson(comment.data()))
              .toList());
          articles.add(articleModel);
        });
      }

      response = (articles, nextLastDoc);

      return response;
    }
    logger.log("ArticleInteractionDataSource:getHomeArticlePage()",
        "last doc != null");
    var snapshot = await FirebaseFirestore.instance
        .collection("articles")
        .where("currentPublishState",
            isEqualTo: ArticlePublishState.published.name)
        .orderBy("dateTimePublished", descending: true)
        .limit(params.pageLength)
        .startAfterDocument(params.lastDoc!)
        .get();

    logger.log("ArticleInteractionDataSource:getHomeArticlePage()",
        "total articles: ${snapshot.docs.length}");
    nextLastDoc = snapshot.docs.lastOrNull;

    for (var article in snapshot.docs) {
      await article.reference.collection("comments").get().then((comments) {
        ArticleModel articleModel = ArticleModel.fromJson(article.data());
        articleModel.commentModels.addAll(comments.docs
            .map((comment) => CommentModel.fromJson(comment.data()))
            .toList());
        articles.add(articleModel);
      });
    }
    response = (articles, nextLastDoc);
    logger.log("ArticleInteractionDataSource:getHomeArticlePage()", "Ended");

    return response;
    // return Future.value(([] as List<ArticleModel>, nextLastDoc));
/*    } catch (e) {
      logger.log(
          "ArticleInteractionDataSource:getHomeArticlePage()", "Error: $e");
      throw ServerException();
    }*/
  }

  @override
  Future<void> addReplyToComment(ArticleInteractionParams params) async {
    logger.log("ArticleInteractionDataSource:addReplyToComment()", "Started");

    if (!sl.isRegistered<Anonymous>(instanceName: "currentUser")) {
      await SharedPrefHelper.reloadCurrentUser();
    }

    if (sl.isRegistered<Anonymous>(instanceName: "currentUser")) {
      throw UnAuthorizedException();
    }

    try {
      await FirebaseFirestore.instance
              .collection("articles")
              .doc(params.articleId)
              .collection("comments")
              .doc(params.comment!.id)
              .update({
        "replies": FieldValue.arrayUnion([params.reply!.toJson()])
      })
          /*.set({"replies": FieldValue.arrayUnion([params.reply!.toJson()])
      }, SetOptions(
          // merge: true,
         mergeFields: ["comments.replies"]))*/
          /*.onError(
              (error, stackTrace) => logger.log(
                  "ArticleInteractionDataSource:addReplyToComment()",
                  "Error: $error"))*/
          ;
      // .update({"comments.replies": FieldValue.arrayUnion([params.reply!.toJson()])});
    } catch (e) {
      logger.log(
          "ArticleInteractionDataSource:addReplyToComment()", "Error: $e");
      throw ServerException();
    }
  }

  @override
  Future<void> commentOnArticle(ArticleInteractionParams params) async {
    logger.log("ArticleInteractionDataSource:commentOnArticle()", "Started");

    if (!sl.isRegistered<Anonymous>(instanceName: "currentUser")) {
      await SharedPrefHelper.reloadCurrentUser();
    }

    if (sl.isRegistered<Anonymous>(instanceName: "currentUser")) {
      throw UnAuthorizedException();
    }

    try {
      await FirebaseFirestore.instance
          .collection("articles")
          .doc(params.articleId) /*.set(data)*/
          .collection("comments")
          .doc(params.comment!.id)
          .set(params.comment!.toJson());
    } catch (e) {
      logger.log(
          "ArticleInteractionDataSource:addReplyToComment()", "Error: $e");
      throw ServerException();
    }
  }

  @override
  Future<void> likeArticle(String id) async {
    logger.log("ArticleInteractionDataSource:likeArticle()", "Started");

    if (!sl.isRegistered<Anonymous>(instanceName: "currentUser") ||
        !sl.isRegistered<User>(instanceName: "currentUser")) {
      await SharedPrefHelper.reloadCurrentUser();
    }

    if (sl.isRegistered<Anonymous>(instanceName: "currentUser")) {
      throw UnAuthorizedException();
    }

    User user = sl.get<User>(instanceName: "currentUser");

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.email)
          .update({
        "likedArticles": FieldValue.arrayUnion([id])
      });

      return await FirebaseFirestore.instance
          .collection("articles")
          .doc(id)
          .update({"likes": FieldValue.increment(1)});
    } catch (e) {
      logger.log("ArticleInteractionDataSource:likeArticle()", "Error: $e");
      throw ServerException();
    }
  }

  @override
  Future<void> saveArticle(String articleId) async {
    logger.log("ArticleInteractionDataSource:saveArticle()", "Started");

    if (!sl.isRegistered<Anonymous>(instanceName: "currentUser") ||
        !sl.isRegistered<User>(instanceName: "currentUser")) {
      await SharedPrefHelper.reloadCurrentUser();
    }

    if (sl.isRegistered<Anonymous>(instanceName: "currentUser")) {
      throw UnAuthorizedException();
    }

    User user = sl.get<User>(instanceName: "currentUser");

    try {
      return await FirebaseFirestore.instance
          .collection("users")
          .doc(user.email)
          .update({
        "savedArticles": FieldValue.arrayUnion([articleId])
      });
    } catch (e) {
      logger.log("ArticleInteractionDataSource:saveArticle()", "Error: $e");
      throw ServerException();
    }
  }

  @override
  Future<void> unsaveArticle(String articleId) async {
    logger.log("ArticleInteractionDataSource:unsaveArticle()", "Started");

    if (!sl.isRegistered<Anonymous>(instanceName: "currentUser") ||
        !sl.isRegistered<User>(instanceName: "currentUser")) {
      await SharedPrefHelper.reloadCurrentUser();
    }

    if (sl.isRegistered<Anonymous>(instanceName: "currentUser")) {
      throw UnAuthorizedException();
    }

    User user = sl.get<User>(instanceName: "currentUser");
    try {
      return await FirebaseFirestore.instance
          .collection("users")
          .doc(user.email)
          .update({
        "savedArticles": FieldValue.arrayRemove([articleId])
      });
    } catch (e) {
      logger.log("ArticleInteractionDataSource:unsaveArticle()", "Error: $e");
      throw ServerException();
    }
  }

  @override
  Future<void> unlikeArticle(String id) async {
    logger.log("ArticleInteractionDataSource:unlikeArticle()", "Started");

    if (!sl.isRegistered<Anonymous>(instanceName: "currentUser")) {
      await SharedPrefHelper.reloadCurrentUser();
    }

    if (sl.isRegistered<Anonymous>(instanceName: "currentUser")) {
      throw UnAuthorizedException();
    }

    try {
      return await FirebaseFirestore.instance
          .collection("articles")
          .doc(id)
          .update({"likes": FieldValue.increment(-1)});
    } catch (e) {
      logger.log("ArticleInteractionDataSource:unlikeArticle()", "Error: $e");
      throw ServerException();
    }
  }

  @override
  Future<void> viewArticle(String id) async {
    logger.log(
        "ArticleInteractionDataSource:incrementArticleViews()", "Started");

    if (!sl.isRegistered<Anonymous>(instanceName: "currentUser")) {
      await SharedPrefHelper.reloadCurrentUser();
    }

    if (sl.isRegistered<Anonymous>(instanceName: "currentUser")) {
      Anonymous anonymous = sl.get<Anonymous>(instanceName: "currentUser");

      try {
        await FirebaseFirestore.instance
            .collection("anonymous")
            .doc(anonymous.uid)
            .update({
          "viewedArticles": FieldValue.arrayUnion([id])
        }).onError((error, stackTrace) => logger.log(
                "ArticleInteractionDataSource:incrementArticleViews()",
                "Error: $error"));

        return await FirebaseFirestore.instance
            .collection("articles")
            .doc(id)
            .update({"views": FieldValue.increment(1)});
      } catch (e) {
        logger.log("ArticleInteractionDataSource:incrementArticleViews()",
            "Error: $e");
      }
    }

    if (!sl.isRegistered<User>(instanceName: "currentUser")) {
      await SharedPrefHelper.reloadCurrentUser();
    }

    if (sl.isRegistered<User>(instanceName: "currentUser")) {
      User currUser = sl.get<User>(instanceName: "currentUser");

      try {
        var user = await FirebaseFirestore.instance
            .collection("users")
            .where("email", isEqualTo: currUser.email)
            .where("viewedArticles", arrayContains: id)
            .get();

        if (user.docs.isNotEmpty) {
          return;
        }

        await user.docs.first.reference.update({
          "viewedArticles": FieldValue.arrayUnion([id])
        });

        return await FirebaseFirestore.instance
            .collection("articles")
            .doc(id)
            .update({"views": FieldValue.increment(1)});
      } catch (e) {
        logger.log("ArticleInteractionDataSource:incrementArticleViews()",
            "Error: $e");
        // throw ServerException();
      }
    }
  }
}
