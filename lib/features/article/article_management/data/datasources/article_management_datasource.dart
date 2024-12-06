import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/di/dependency_injector.dart';
import '../../../../../core/failures/exceptions.dart';
import '../../../../../core/utils/debug_logger.dart';
import '../../../../../core/utils/shared_pref_helper.dart';
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

    if(!sl.isRegistered<Publisher>(instanceName: "currentUser")){
      await SharedPrefHelper.reloadCurrentUser();
    }

    Publisher publisher = sl.get<Publisher>(instanceName: "currentUser");

    // if (draftArticleParams != null) {
    if (params.title != null /*&& params.description != null*/) {
      PublisherModel articlePublisher =
          PublisherModel.fromEntity(publisher);
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
      // article.images.addAll(params.images);

      String articleId = await _storeArticleToFirestore(article);
      await _storeArticleImagesToFirebaseStorage(articleId, article, params.images);
      await _storeLabelsToFirestore(article.labels);
    } else {
      throw MissingRequiredArgumentsException();
    }
  }

  Future<void> _storeLabelsToFirestore(List<String> labels) async {
    logger.log(
        "ArticleManagementDataSource:_storeLabelsToFirestore()", "Started");
    for (var label in labels) {
      await FirebaseFirestore.instance
          .collection("interests")
          .where("label", isEqualTo: label)
          .get()
          .then((existingSameLabels) async {
        logger.log("ArticleManagementDataSource:_storeLabelsToFirestore()",
            "existingSameLabels: $existingSameLabels");

        if (existingSameLabels.size == 0) {
          InterestModel interest = InterestModel(
              label: label, totalLikes: 0, totalDislikes: 0, totalClicks: 0);
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

  Future<String> _storeArticleToFirestore(ArticleModel article) async {
    logger.log(
        "ArticleManagementDataSource:_storeArticleToFirestore()", "Started");
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      CollectionReference articles = firestore.collection("articles");
      DocumentReference newArticle = await articles.add(article.toJson());
      await newArticle.update({"id": newArticle.id});
      logger.log(
          "ArticleManagementDataSource", "New article created: $article");

      return newArticle.id;
    } catch (e) {
      logger.log("ArticleManagementDataSource", e.toString());
      throw ServerException();
    }
  }

  @override
  Future<void> schedulePublishArticle(ArticleParams params) async {
    logger.log(
        "ArticleManagementDataSource:schedulePublishArticle()", "Started");
    logger.log(
        "ArticleManagementDataSource:schedulePublishArticle() ArticleParams",
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

  Future<void> _storeArticleImagesToFirebaseStorage(String articleId,
      ArticleModel article, List<XFile> images) async {
    logger.log(
        "ArticleManagementDataSource:_storeArticleImagesToFirebaseStorage()",
        "Started");
    for (int i = 0; i < images.length; i++) {
      Uint8List imageBytes = await images[i].readAsBytes();
      String imageName = images[i].name;

      Reference imageRef =
          FirebaseStorage.instance.ref("articles/$articleId/$imageName");

      // var image = await imageRef.getData();
      // imageRef.getData()
      await imageRef.putData(imageBytes).then((snapshot) async {
        logger.log(
            "ArticleManagementDataSource:_storeArticleImagesToFirebaseStorage()",
            "snapshot: $snapshot");
        String url = await snapshot.ref.getDownloadURL();
        logger.log(
            "ArticleManagementDataSource:_storeArticleImagesToFirebaseStorage()",
            "url: $url");
        article.images.add(url);
        await FirebaseFirestore.instance
            .collection("articles")
            .doc(articleId)
            .update({
          "images": FieldValue.arrayUnion([url])
        });
      });
    }
  }
  Future<void> _updateOrDeleteArticleImagesToFirebaseStorage(
      ArticleParams params) async {
    logger.log("ArticleManagementDataSource:_updateOrDeleteArticleImagesToFirebaseStorage()",
        "Started");
    var articleDocRef = FirebaseFirestore.instance
    .collection("articles").doc(params.id);
    var storage = FirebaseStorage.instance;

    // Delete old images
    for(int i = 0; i < params.imageDeleteList.length; i++){
      storage.refFromURL(params.imageDeleteList[i]).delete();

      await articleDocRef.update({
        "images": FieldValue.arrayRemove([params.imageDeleteList[i]])
      });
    }


    for (int i = 0; i < params.images.length; i++) {
      Uint8List imageBytes = await params.images[i].readAsBytes();
      String imageName = params.images[i].name;

      Reference imageRef = storage.ref("articles/${params.id}/$imageName");

      // var image = await imageRef.getData();
      // imageRef.getData()
      await imageRef.putData(imageBytes).then((snapshot) async {
        logger.log(
            "ArticleManagementDataSource:_storeArticleImagesToFirebaseStorage()",
            "snapshot: $snapshot");
        String url = await snapshot.ref.getDownloadURL();
        logger.log(
            "ArticleManagementDataSource:_storeArticleImagesToFirebaseStorage()",
            "url: $url");

        // article.images.add(url);
        await articleDocRef.update({
          "images": FieldValue.arrayUnion([url])
        });
      });
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
    logger.log("ArticleManagementDataSource:updateArticle() ArticleParams",
        params.toString());
    // UpdateArticleParams? updateArticleParams = params.updateArticleParams;

    // if (updateArticleParams != null) {

    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection("articles").doc(params.id).update({
        "title": params.title,
        "description": params.description,
        "currentState": ArticleState.updated.name,
        "labels": params.labels,
        // "images": params.images,
        "dateTimeModified": DateTime.now(),
      });
      _updateOrDeleteArticleImagesToFirebaseStorage(params);
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
    logger.log(
        "ArticleManagementDataSource:deleteArticle() ArticleId", id.toString());
    // DeleteArticleParams? deleteArticleParams = params.deleteArticleParams;

    // if (deleteArticleParams != null) {
    try {
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection("articles").doc(id).update({
        "currentState": ArticleState.deleted.name,
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

    try {
      if (!sl.isRegistered<Publisher>(instanceName: "currentUser")) {
        await SharedPrefHelper.reloadCurrentUser();
      }

      Publisher publisher = sl.get<Publisher>(instanceName: "currentUser");

      List<ArticleModel> articles = await FirebaseFirestore.instance
          .collection("articles")
          .where("publisher.email", isEqualTo: publisher.email)
          .where(
          "currentPublishState", isEqualTo: ArticlePublishState.draft.name)
          .where("currentState", isNotEqualTo: ArticleState.deleted.name)
          .get()
          .then((snapshot) =>
          snapshot.docs
              .map((doc) => ArticleModel.fromJson(doc.data()))
              .toList());

      return articles;
    } catch (e) {
      logger.log("ArticleManagementDataSource:getDraftArticles()", e.toString());
      throw ServerException();
    }
  }

  @override
  Future<List<ArticleModel>> getPublishedArticles() async {
    logger.log("ArticleManagementDataSource:getPublishedArticles()", "Started");

    try{
    if(!sl.isRegistered<Publisher>(instanceName: "currentUser")){
      await SharedPrefHelper.reloadCurrentUser();
    }

    Publisher publisher = sl.get<Publisher>(instanceName: "currentUser");

    List<ArticleModel> articles = await FirebaseFirestore.instance
        .collection("articles")
        .where("publisher.email", isEqualTo: publisher.email)
        .where("currentPublishState",
            isEqualTo: ArticlePublishState.published.name)
        .where("currentState", isNotEqualTo: ArticleState.deleted.name)
        .get()
        .then((snapshot) => snapshot.docs
            .map((doc) => ArticleModel.fromJson(doc.data()))
            .toList());

    return articles;
    } catch (e) {
    logger.log("ArticleManagementDataSource:getDraftArticles()", e.toString());
    throw ServerException();
    }
  }

  @override
  Future<List<ArticleModel>> getScheduledArticles() async {
    logger.log("ArticleManagementDataSource:getScheduledArticles()", "Started");

    try {
    if(!sl.isRegistered<Publisher>(instanceName: "currentUser")){
      await SharedPrefHelper.reloadCurrentUser();
    }

    Publisher publisher = sl.get<Publisher>(instanceName: "currentUser");

    List<ArticleModel> articles = await FirebaseFirestore.instance
        .collection("articles")
        .where("publisher.email", isEqualTo: publisher.email)
        .where("currentPublishState",
            isEqualTo: ArticlePublishState.scheduled.name)
        .where("currentState", isNotEqualTo: ArticleState.deleted.name)
        .get()
        .then((snapshot) => snapshot.docs
            .map((doc) => ArticleModel.fromJson(doc.data()))
            .toList());

    return articles;
    } catch (e) {
      logger.log("ArticleManagementDataSource:getDraftArticles()", e.toString());
      throw ServerException();
    }
  }
}
