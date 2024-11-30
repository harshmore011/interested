
import 'package:equatable/equatable.dart';

import '../../../entities/article_entity.dart';

abstract class ArticleManagementState extends Equatable {
  @override
  List<Object> get props {
    return [];
  }
}

class InitialState extends ArticleManagementState{}

class LoadingState extends ArticleManagementState{}

class DraftArticleCreatedState extends ArticleManagementState{}

class DraftArticlesFetchedState extends ArticleManagementState{
  final List<Article> articles;

  DraftArticlesFetchedState({required this.articles});

  @override
  List<Object> get props {
    return [articles];
  }
}

class ArticleUpdatedState extends ArticleManagementState{}

class ArticleMarkedForDeletionState extends ArticleManagementState{}

class ArticlePublishedState extends ArticleManagementState{}

class PublishedArticlesFetchedState extends ArticleManagementState{
  final List<Article> articles;

  PublishedArticlesFetchedState({required this.articles});

  @override
  List<Object> get props {
    return [articles];
  }
}

class ArticleUnpublishedState extends ArticleManagementState{}

class ArticleScheduledState extends ArticleManagementState{}

class ScheduledArticlesFetchedState extends ArticleManagementState{
  final List<Article> articles;

  ScheduledArticlesFetchedState({required this.articles});

  @override
  List<Object> get props {
    return [articles];
  }
}

class FailureState extends ArticleManagementState{
  final String message;

  FailureState({required this.message});

  @override
  List<Object> get props {
    return [message];
  }
}

// class OnboardingCompletedState extends OnboardingState{}

