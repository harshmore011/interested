import 'package:equatable/equatable.dart';

import '../../authentication/domain/entities/publisher_entity.dart';
import '../article.dart';

class Article extends Equatable {
  final String? id;
  final String title;
  final String description;
  final String url; // ??
  final List<String> labels = [];
  // final List<String> labels = const [];
  final ArticleState currentState;
  final ArticlePublishState currentPublishState;
  final List<Comment> comments = [];
  final Publisher publisher;
  final DateTime dateTimeCreated;
  final DateTime? dateTimeModified;
  final DateTime? dateTimeScheduled;
  final DateTime? dateTimePublished;
  final DateTime? dateTimeDeleted;
  final List<String> images = []; // ??

  // final List<String> videos = const [];
  final int views;
  final int likes;
  final int saves;

   Article(
      {this.id,
        required this.title,
      required this.description,/*
       required this.images,
       required this.labels,
       required this.comments,*/
      required this.url,
      required this.currentState,
      required this.currentPublishState,
      required this.publisher,
      required this.dateTimeCreated,
      this.dateTimeModified,
      this.dateTimeScheduled,
      this.dateTimePublished,
      this.dateTimeDeleted,
      required this.views,
      required this.likes,
      required this.saves});

  @override
  List<Object?> get props => [
    id,
        title,
        description,
        url,
        labels,
        currentState,
        currentPublishState,
        comments,
        publisher,
        dateTimeCreated,
        dateTimeModified,
        dateTimeScheduled,
        dateTimePublished,
        dateTimeDeleted,
        images,
        views,
        likes,
        saves
      ];

}

class Comment extends Equatable {
  final String? id;
  final String comment;
  final String user;
  // final User user;
  final bool isLikedByPublisher;
  final List<Reply> replies = [];
  final DateTime dateTimeCommented;

  Comment({
    this.id,
    required this.comment,
    required this.user,
    // required this.replies,
    required this.isLikedByPublisher,
    required this.dateTimeCommented,
  });

  @override
  List<Object?> get props =>
      [id, comment, user, isLikedByPublisher, replies, dateTimeCommented,];


}

class Reply extends Equatable {
  final String reply;
  final String? user;
  // final User? user;
  final String? publisher;
  // final Publisher? publisher;
  final DateTime dateTimeReplied;

  const Reply({
    required this.reply,
    this.user,
     this.publisher,
    required this.dateTimeReplied,
  });

  @override
  List<Object?> get props => [reply, user, publisher, dateTimeReplied];


}

class Interest extends Equatable {
  final String label;
  final int totalLikes;
  final int totalDislikes;
  final int totalClicks;

  const Interest(
      {required this.label,
      required this.totalLikes,
      required this.totalDislikes,
      required this.totalClicks});

  @override
  List<Object?> get props => [label, totalLikes, totalDislikes, totalClicks];


}
