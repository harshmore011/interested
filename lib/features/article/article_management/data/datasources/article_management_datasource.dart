import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../core/di/dependency_injector.dart';
import '../../../../../core/failures/exceptions.dart';
import '../../../../../core/utils/debug_logger.dart';
import '../../../../authentication/data/models/publisher_model.dart';
import '../../../../authentication/domain/entities/publisher_entity.dart';
import '../../../article.dart';
import '../../../models/article_model.dart';

abstract class ArticleManagementDataSource {
  Future<void> createDraftArticle(ArticleParams params);

  Future<List<ArticleModel>> getDraftArticles();

  Future<void> schedulePublishArticle(ArticleParams params);

  Future<List<ArticleModel>> getScheduledArticles();

  Future<void> publishArticle(String articleId);

  Future<List<ArticleModel>> getPublishedArticles();

  Future<void> unpublishArticle(String articleId);

  Future<void> updateArticle(ArticleParams params);

  Future<void> deleteArticle(String articleId);
}

class ArticleManagementDataSourceImpl implements ArticleManagementDataSource {
  @override
  Future<void> createDraftArticle(ArticleParams params) async {
    logger.log("ArticleManagementDataSource:createDraftArticle()", "Started");
    logger.log("ArticleManagementDataSource:createDraftArticle() ArticleParams",
        params.toString());
    // DraftArticleParams? draftArticleParams = params.draftArticleParams;

    // if (draftArticleParams != null) {
    if (params.title != null /*&& params.description != null*/) {

      PublisherModel articlePublisher = PublisherModel.fromEntity(sl<Publisher>());
      // PublisherModel articlePublisher = publisher.copyWith();

      ArticleModel article = ArticleModel(
        title: params.title.toString(),
        description: params.description.toString(),
        url: "",
        currentState: ArticleState.created,
        currentPublishState: ArticlePublishState.draft,
        publisherModel: articlePublisher,
        dateTimeCreated: DateTime.now(),
        dateTimeModified: DateTime.now(),
        views: 0,
        likes: 0,
        saves: 0,
      );
      article.labels.addAll(params.labels);
      // article.images.addAll(draftArticleParams.images);

      await _storeArticleToFirestore(article);
      await _storeLabelsToFirestore(article.labels);
      // _storeArticleImagesToFirebaseStorage(article, draftArticleParams.images);
    } else {
      throw MissingRequiredArgumentsException();
    }
  }

  Future<void> _storeLabelsToFirestore(List<String> labels) async {
    logger.log("ArticleManagementDataSource:_storeLabelsToFirestore()",
        "Started");
    for (var label in labels) {

     await FirebaseFirestore.instance
          .collection("interests")
      .where("label", isEqualTo: label).get().then((existingSameLabels) async {
        logger.log("ArticleManagementDataSource:_storeLabelsToFirestore()",
            "existingSameLabels: $existingSameLabels");

        if (existingSameLabels.size == 0) {
          InterestModel interest = InterestModel(label: label,totalLikes: 0, totalDislikes: 0,totalClicks: 0);
          logger.log("ArticleManagementDataSource:_storeLabelsToFirestore()",
              "Storing new Interest: $interest");

         await FirebaseFirestore.instance
              .collection("interests")
              .doc(label)
              .set(interest.toJson());
        }
      });

    }
  }

  Future<void> _storeArticleToFirestore(ArticleModel article) async {
    logger.log(
        "ArticleManagementDataSource:_storeArticleToFirestore()", "Started");
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      CollectionReference articles = firestore.collection("articles");
      DocumentReference newArticle = await articles.add(article.toJson());
      await newArticle.update({"id": newArticle.id});
      logger.log("ArticleManagementDataSource", "New article created: $article");
    } catch (e) {
      logger.log("ArticleManagementDataSource", e.toString());
      throw ServerException();
    }
  }

  Future<void> _storeArticleImagesToFirebaseStorage(
      ArticleModel article, images) async {
    logger.log(
        "ArticleManagementDataSource:_storeArticleImagesToFirebaseStorage()",
        "Started");
    /* for (int i = 0; i < article.images.length; i++) {
      Uint8List imageBytes = article.images[i].bytes;
      String imageName = article.images[i].name;
      Reference imageRef = FirebaseStorage.instance.ref("articles/$newArticle.id/$imageName");
      await imageRef.putData(imageBytes);
  }*/
  }

  @override
  Future<void> schedulePublishArticle(ArticleParams params) async {
    logger.log("ArticleManagementDataSource:schedulePublishArticle()", "Started");
    logger.log("ArticleManagementDataSource:schedulePublishArticle() ArticleParams",
        params.toString());

    // DraftArticleParams? draftArticleParams = params.draftArticleParams;

    // if (draftArticleParams != null) {
    if (params.id != null && params.scheduledDateTime != null) {
      try {
        FirebaseFirestore firestore = FirebaseFirestore.instance;
        await firestore.collection("articles").doc(params.id).update({
          "currentPublishState": ArticlePublishState.scheduled.name,
          "dateTimeScheduled": params.scheduledDateTime,
        });
      } catch (e) {
        logger.log("ArticleManagementDataSource", e.toString());
        throw ServerException();
      }
    } else {
      throw MissingRequiredArgumentsException();
    }
  }

  @override
  Future<void> publishArticle(String id) async {
    logger.log("ArticleManagementDataSource:publishArticle()", "Started");
    logger.log("ArticleManagementDataSource:publishArticle() ArticleId", id);
    // PublishArticleParams? publishArticleParams = params.publishArticleParams;

    // if (publishArticleParams != null) {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection("articles").doc(id).update({
        "currentPublishState": ArticlePublishState.published.name,
        "dateTimePublished": DateTime.now(),
      });
    } catch (e) {
      logger.log("ArticleManagementDataSource", e.toString());
      throw ServerException();
    }
    /* } else {
      throw MissingRequiredArgumentsException();
    }*/
  }

  // TODO: Rename to "moveToDraft()"
  @override
  Future<void> unpublishArticle(String id) async {
    logger.log("ArticleManagementDataSource:unpublishArticle()", "Started");
    // UnpublishArticleParams? unpublishArticleParams = params.unpublishArticleParams;

    // if (unpublishArticleParams != null) {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection("articles").doc(id).update({
        "currentPublishState": ArticlePublishState.draft.name,
      });
    } catch (e) {
      logger.log(
          "ArticleManagementDataSource:unpublishArticle()", e.toString());
      throw ServerException();
    }
    /* } else {
      throw MissingRequiredArgumentsException();
    }*/
  }

  @override
  Future<void> updateArticle(ArticleParams params) async {
    logger.log("ArticleManagementDataSource:updateArticle()", "Started");
    logger.log("ArticleManagementDataSource:updateArticle() ArticleParams", params.toString());
    // UpdateArticleParams? updateArticleParams = params.updateArticleParams;

    // if (updateArticleParams != null) {

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection("articles").doc(params.id).update({
        "title": params.title,
        "description": params.description,
        "currentState": ArticleState.updated.name,
        "labels": params.labels,
        "dateTimeModified": DateTime.now(),
      });
      // _storeArticleImagesToFirebaseStorage(article, images);
    } catch (e) {
      logger.log("ArticleManagementDataSource:updateArticle()", e.toString());
      throw ServerException();
    }
    /* } else {
      throw MissingRequiredArgumentsException();
    }*/
  }

  @override
  Future<void> deleteArticle(String id) async {
    logger.log("ArticleManagementDataSource:deleteArticle()", "Started");
    logger.log("ArticleManagementDataSource:deleteArticle() ArticleId", id.toString());
    // DeleteArticleParams? deleteArticleParams = params.deleteArticleParams;

    // if (deleteArticleParams != null) {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection("articles").doc(id).update({
        "currentState": ArticleState.markedForDeletion.name,
        "dateTimeDeleted": DateTime.now(),
      });
    } catch (e) {
      logger.log("ArticleManagementDataSource:deleteArticle()", e.toString());
      throw ServerException();
    }
    /* } else {
      throw MissingRequiredArgumentsException();
    }*/
  }

  @override
  Future<List<ArticleModel>> getDraftArticles() async {
    logger.log("ArticleManagementDataSource:getDraftArticles()", "Started");

    PublisherModel publisher = PublisherModel.fromEntity(sl<Publisher>());

    List<ArticleModel> articles = await FirebaseFirestore.instance
        .collection("articles")
        .where("publisher.email",isEqualTo: publisher.email)
        .where("currentPublishState", isEqualTo: ArticlePublishState.draft.name)
        .get()
        .then((snapshot) => snapshot.docs
            .map((doc) => ArticleModel.fromJson(doc.data()))
            .toList());

    return articles;
  }

  @override
  Future<List<ArticleModel>> getPublishedArticles() async {
    logger.log("ArticleManagementDataSource:getPublishedArticles()", "Started");

    List<ArticleModel> articles = await FirebaseFirestore.instance
        .collection("articles")
        .where("publisher.email", isEqualTo: sl<Publisher>().email)
        .where("currentPublishState", isEqualTo: ArticlePublishState.published.name)
        .get()
        .then((snapshot) => snapshot.docs
            .map((doc) => ArticleModel.fromJson(doc.data()))
            .toList());

    return articles;
  }

  @override
  Future<List<ArticleModel>> getScheduledArticles() async {
    logger.log("ArticleManagementDataSource:getScheduledArticles()", "Started");

    List<ArticleModel> articles = await FirebaseFirestore.instance
        .collection("articles")
        .where("publisher.email", isEqualTo: sl<Publisher>().email)
        .where("currentPublishState", isEqualTo: ArticlePublishState.scheduled.name)
        .get()
        .then((snapshot) => snapshot.docs
            .map((doc) => ArticleModel.fromJson(doc.data()))
            .toList());

    return articles;
  }

}
