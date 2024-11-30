
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'package:equatable/equatable.dart';

import '../../../core/utils/debug_logger.dart';
import '../../authentication/data/models/publisher_model.dart';
import '../article.dart';
import '../entities/article_entity.dart';

class ArticleModel extends Equatable {
  final String? id;
  final String title;
  final String description;
  final String url; // ??
  final ArticleState currentState;
  final ArticlePublishState currentPublishState;
  final DateTime dateTimeCreated;
  final DateTime? dateTimeModified;
  final DateTime? dateTimeScheduled;
  final DateTime? dateTimePublished;
  final DateTime? dateTimeDeleted;

  // final List<String> videos = const [];
  final int views;
  final int likes;
  final int saves;
  final List<CommentModel> commentModels = [];
  final List<String> labels = [];
  final List<String> images = [];
  final PublisherModel publisherModel;

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    logger.log(
      'ArticleModel.fromJson',
      'json: $json',
    );

    ArticleModel articleModel = ArticleModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
/*      labels: json['labels'],
      images: json['images'],
      commentModels: json['comments']
          .map((comment) => CommentModel.fromJson(comment))
          .toList(),*/
      url: json['url'],
      currentState: ArticleState.values.byName(json['currentState']),
      currentPublishState:
          ArticlePublishState.values.byName(json['currentPublishState']),
      publisherModel: PublisherModel.fromJson(json['publisher']),
      dateTimeCreated: DateTime.parse(json['dateTimeCreated'].toDate().toString()),
      dateTimeModified: json['dateTimeModified'] == null
          ? null
          : DateTime.parse(json['dateTimeModified'].toDate().toString()),
      dateTimeScheduled: json['dateTimeScheduled'] == null
          ? null
          : DateTime.parse(json['dateTimeScheduled'].toDate().toString()),
      dateTimePublished: json['dateTimePublished'] == null
          ? null
          : DateTime.parse(json['dateTimePublished'].toDate().toString()),
      dateTimeDeleted: json['dateTimeDeleted'] == null
          ? null
          : DateTime.parse(json['dateTimeDeleted'].toDate().toString()),
      views: json['views'],
      likes: json['likes'],
      saves: json['saves'],
    );

    logger.log("ArticleModel: json", json.toString());
    logger.log("ArticleModel: json: labels", json['labels'].toString());
    // logger.log("ArticleModel: json: labels", json['labels'].runtimeType.toString());
    // logger.log("ArticleModel: json: labels", jsonDecode(json['labels']).toString());
    // logger.log("ArticleModel: json: labels", jsonDecode(json['labels']).runtimeType.toString());
// logger.log("ArticleModel: json: images", jsonDecode(json['images']).toString());
//     logger.log("ArticleModel: json: images", jsonDecode(json['images']).runtimeType.toString());
// logger.log("ArticleModel: json: comments", jsonDecode(json['comments']).toString());
//     logger.log("ArticleModel: json: comments", jsonDecode(json['comments']).runtimeType.toString());

    articleModel.labels.addAll(json['labels']
        .map<String>((label) => "$label")
        .toList() as List<String>);
    articleModel.images.addAll(json['images']
        .map<String>((image) => "$image")
        .toList() as List<String>);
   /* if (json['comments'] != null) {
      articleModel.commentModels.addAll(json['comments']
        .map<CommentModel>(
            (commentModel) => CommentModel.fromJson(commentModel))
        .toList() as List<CommentModel>);
    }*/

    return articleModel;
  }

  ArticleModel({
    this.id,
    required this.title,
    required this.description,
    required this.url,
    // required this.labels,
    required this.currentState,
    required this.currentPublishState,
    required this.dateTimeCreated,
    this.dateTimeModified,
    this.dateTimeScheduled,
    this.dateTimePublished,
    this.dateTimeDeleted,
    required this.views,
    required this.likes,
    required this.saves,
    required this.publisherModel,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'url': url,
      'labels': labels,
      'currentState': currentState.name,
      'currentPublishState': currentPublishState.name,
      'comments': commentModels.map<Map<String, dynamic>>((comment) => comment.toJson()).toList(),
      'publisher': publisherModel.toJson(),
      'dateTimeCreated': dateTimeCreated,
      'dateTimeModified': dateTimeModified,
      'dateTimeScheduled': dateTimeScheduled,
      'dateTimePublished': dateTimePublished,
      'dateTimeDeleted': dateTimeDeleted,
      // 'dateTimeCreated': dateTimeCreated.toIso8601String(),
      // 'dateTimeModified': dateTimeModified?.toIso8601String(),
      // 'dateTimeScheduled': dateTimeScheduled?.toIso8601String(),
      // 'dateTimePublished': dateTimePublished?.toIso8601String(),
      // 'dateTimeDeleted': dateTimeDeleted?.toIso8601String(),
      'images': images,
      'views': views,
      'likes': likes,
      'saves': saves,
    };
  }

  Article toEntity() {
    Article article = Article(
      id: id,
      title: title,
      description: description,
      url: url,
      // labels: labels,
      currentState: currentState,
      currentPublishState: currentPublishState,
      // comments: commentModels.map((comment) => comment.toEntity()).toList(),
      publisher: publisherModel.toEntity(),
      dateTimeCreated: dateTimeCreated,
      dateTimeModified: dateTimeModified,
      dateTimeScheduled: dateTimeScheduled,
      dateTimePublished: dateTimePublished,
      dateTimeDeleted: dateTimeDeleted,
      // images: images,
      views: views,
      likes: likes,
      saves: saves,
    );
    article.labels.addAll(labels);
    article.images.addAll(images);
    article.comments
        .addAll(commentModels.map<Comment>((comment) => comment.toEntity()).toList());

    return article;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        id,
        title,
        description,
        url,
        labels,
        currentState,
        currentPublishState,
        commentModels,
        publisherModel,
        dateTimeCreated,
        dateTimeModified,
        dateTimeScheduled,
        dateTimePublished,
        dateTimeDeleted,
        images,
        views,
        likes,
        saves,
  ];
}

class CommentModel extends Equatable {
  final String? id;
  final String comment;
  // final UserModel user;
  final String user;
  final bool isLikedByPublisher;
  final List<ReplyModel> replies = [];
  final DateTime dateTimeCommented;

  CommentModel({
    this.id,
    required this.comment,
    required this.user,
    // required this.replies,
    required this.isLikedByPublisher,
    required this.dateTimeCommented,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'comment': comment,
      'user': user,
      // 'user': user.toJson(),
      'replies': replies.map<Map<String, dynamic>>((reply) => reply.toJson()).toList(),
      'isLikedByPublisher': isLikedByPublisher,
      // 'dateTimeCommented': dateTimeCommented.toIso8601String(),
      'dateTimeCommented': dateTimeCommented,
    };
  }

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    CommentModel commentModel = CommentModel(
      id: json['id'],
      comment: json['comment'],
      user: json['user'],
      // user: UserModel.fromJson(json['user']),
      // replies:
      //     json['replies']?.map((reply) => ReplyModel.fromJson(reply)).toList(),
      isLikedByPublisher: json['isLikedByPublisher'],
      dateTimeCommented: DateTime.parse(json['dateTimeCommented'] is Timestamp ?
      json['dateTimeCommented'].toDate().toString() : json['dateTimeCommented']),
    );
    commentModel.replies.addAll(json['replies']
        ?.map<ReplyModel>((reply) => ReplyModel.fromJson(reply))
        .toList());

    return commentModel;
  }

  Comment toEntity() {
    Comment comment = Comment(
      id: id,
      comment: this.comment,
      // user: user.toEntity(),
      user: user,
      // replies: replies.map((reply) => reply.toEntity()).toList(),
      isLikedByPublisher: isLikedByPublisher,
      dateTimeCommented: dateTimeCommented,
    );

    comment.replies.addAll(replies.map<Reply>((reply) => reply.toEntity()).toList());
    return comment;
  }

  @override
  List<Object?> get props => [id, comment, user, isLikedByPublisher, replies, dateTimeCommented,];
}

class ReplyModel extends Equatable {
  final String reply;
  final DateTime dateTimeReplied;
  final String? publisher;
  // final PublisherModel publisherModel;
  final String? user;
  // final UserModel userModel;

  const ReplyModel({
    required this.reply,
    required this.dateTimeReplied,
     this.user,
     this.publisher,
  });

  Map<String, dynamic> toJson() {
    return {
      'reply': reply,
      // 'user': userModel.toJson(),
      // 'publisher': publisherModel.toJson(),
      'user': user,
      'publisher': publisher,
      'dateTimeReplied': dateTimeReplied,
      // 'dateTimeReplied': dateTimeReplied.toIso8601String(),
    };
  }

  factory ReplyModel.fromJson(Map<String, dynamic> json) {
    return ReplyModel(
      reply: json['reply'],
      // dateTimeReplied: DateTime.parse(json['dateTimeReplied'].toDate().toString()),
      dateTimeReplied: DateTime.parse(json['dateTimeReplied'] is Timestamp ?
      json['dateTimeReplied'].toDate().toString() : json['dateTimeReplied']),
      // userModel: UserModel.fromJson(json['user']),
      // publisherModel: PublisherModel.fromJson(json['publisher']),
      user: json['user'],
      publisher: json['publisher'],
    );
  }

  Reply toEntity() {
    Reply reply = Reply(
      reply: this.reply,
      dateTimeReplied: dateTimeReplied,
      // publisher: publisherModel.toEntity(),
      // user: userModel.toEntity(),
      user: user,
      publisher: publisher,
    );
    return reply;
  }

  @override
  List<Object?> get props => [reply, dateTimeReplied, publisher, user];
}

class InterestModel extends Interest {
  const InterestModel({
    required super.label,
    required super.totalLikes,
    required super.totalDislikes,
    required super.totalClicks,
  });

  factory InterestModel.fromJson(Map<String, dynamic> json) {
    return InterestModel(
      label: json['label'],
      totalLikes: json['totalLikes'],
      totalDislikes: json['totalDislikes'],
      totalClicks: json['totalClicks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'label': label,
      'totalLikes': totalLikes,
      'totalDislikes': totalDislikes,
      'totalClicks': totalClicks,
    };
  }
}
