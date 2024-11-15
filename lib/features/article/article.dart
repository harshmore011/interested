import 'package:equatable/equatable.dart';

import 'entities/article_entity.dart';

enum ArticleState { created, updated, markedForDeletion, deleted }
enum ArticlePublishState { draft, scheduled, published, /*unpublished*/ }

class ArticleParams extends Equatable {

  final String? id;
  final String? title;
  final String? description;
  final List<String> labels = [];
  final List<String> images = []; // ??
  final DateTime? scheduledDateTime;

  ArticleParams({
    this.id,
    this.title,
    this.description,/*
    this.labels,
    this.images,*/
    this.scheduledDateTime
  });

  @override
  List<Object?> get props => [id, title, description, labels, images,scheduledDateTime,];
}

/*class ArticleManagementParams extends Equatable {

  final DraftArticleParams? draftArticleParams;
  final SchedulePublishParams? schedulePublishParams;
  final PublishArticleParams? publishArticleParams;
  final UnpublishArticleParams? unpublishArticleParams;
  final UpdateArticleParams? updateArticleParams;
  final DeleteArticleParams? deleteArticleParams;

  const ArticleParams({
    this.draftArticleParams,
    this.schedulePublishParams,
    this.publishArticleParams,
    this.unpublishArticleParams,
    this.updateArticleParams,
    this.deleteArticleParams,
  });

  @override
  List<Object?> get props => [
        draftArticleParams,
        schedulePublishParams,
        publishArticleParams,
        unpublishArticleParams,
        updateArticleParams,
        deleteArticleParams,
      ];
}*/

/*
class DraftArticleParams extends Equatable {
  final String title;
  final String description;
  final List<Interest> labels = const [];
  final List<String> images = const []; // ??

  const DraftArticleParams({
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [title, description, labels, images];
}

class SchedulePublishParams extends Equatable {
  final String id;
  final DateTime scheduledDateTime;

  const SchedulePublishParams(
      {required this.id, required this.scheduledDateTime});

  @override
  List<Object?> get props => [id, scheduledDateTime];
}

class PublishArticleParams extends Equatable {
  final String id;

  const PublishArticleParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class UnpublishArticleParams extends Equatable {
  final String id;

  const UnpublishArticleParams({required this.id});

  @override
  List<Object?> get props => [id];
}

class UpdateArticleParams extends Equatable {
  final String id;
  final String? title;
  final String? description;
  final List<Interest> labels = const [];
  final List<String> images = const []; // ??

  const UpdateArticleParams({
    required this.id,
    required this.title,
    required this.description,
  });

  @override
  List<Object?> get props => [id, title, description, labels, images];
}

class DeleteArticleParams extends Equatable {
  final String id;

  const DeleteArticleParams({required this.id});

  @override
  List<Object?> get props => [id];
}
*/
