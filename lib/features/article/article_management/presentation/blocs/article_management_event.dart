
import 'package:equatable/equatable.dart';

import '../../../article.dart';

abstract class ArticleManagementEvent extends Equatable {
  @override
  List<Object> get props {
    return [];
  }
}

class GetDraftArticlesEvent extends ArticleManagementEvent{
}

class GetPublishedArticlesEvent extends ArticleManagementEvent{
}

class GetScheduledArticlesEvent extends ArticleManagementEvent{
}

class CreateDraftArticleEvent extends ArticleManagementEvent{

  final ArticleParams params;

  CreateDraftArticleEvent({required this.params});

  @override
  List<Object> get props {
    return [params];
  }
}

class SchedulePublishArticleEvent extends ArticleManagementEvent{

  final ArticleParams params;

  SchedulePublishArticleEvent({required this.params});

  @override
  List<Object> get props {
    return [params];
  }
}

class PublishArticleEvent extends ArticleManagementEvent{

  final String id;

  PublishArticleEvent({required this.id});

  @override
  List<Object> get props {
    return [id];
  }
}

class UnpublishArticleEvent extends ArticleManagementEvent{

  final String id;

  UnpublishArticleEvent({required this.id});

  @override
  List<Object> get props {
    return [id];
  }
}

class UpdateArticleEvent extends ArticleManagementEvent{

  final ArticleParams params;

  UpdateArticleEvent({required this.params});

  @override
  List<Object> get props {
    return [params];
  }
}

class DeleteArticleEvent extends ArticleManagementEvent{

  final String id;

  DeleteArticleEvent({required this.id});

  @override
  List<Object> get props {
    return [id];
  }
}

