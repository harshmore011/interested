
import 'package:equatable/equatable.dart';

import '../../domain/entities/article_interaction.dart';

abstract class ArticleInteractionEvent extends Equatable {
  @override
  List<Object> get props {
    return [];
  }
}

class GetArticlesEvent extends ArticleInteractionEvent{
  final ArticleInteractionParams params;

  GetArticlesEvent({required this.params});

  @override
  List<Object> get props {
    return [params];
  }
}

class ViewArticleEvent extends ArticleInteractionEvent{
  final String articleId;

  ViewArticleEvent({required this.articleId});

  @override
  List<Object> get props {
    return [articleId];
  }
}

class LikeArticleEvent extends ArticleInteractionEvent{
  final String articleId;

  LikeArticleEvent({required this.articleId});

  @override
  List<Object> get props {
    return [articleId];
  }
}

class UnlikeArticleEvent extends ArticleInteractionEvent{
  final String articleId;

  UnlikeArticleEvent({required this.articleId});

  @override
  List<Object> get props {
    return [articleId];
  }
}

class SaveArticleEvent extends ArticleInteractionEvent{

  final String articleId;

  SaveArticleEvent({required this.articleId});

  @override
  List<Object> get props {
    return [articleId];
  }
}
class UnSaveArticleEvent extends ArticleInteractionEvent{

  final String articleId;

  UnSaveArticleEvent({required this.articleId});

  @override
  List<Object> get props {
    return [articleId];
  }
}

class CommentOnArticleEvent extends ArticleInteractionEvent{

  final ArticleInteractionParams params;

  CommentOnArticleEvent({required this.params});

  @override
  List<Object> get props {
    return [params];
  }
}

class AddReplyToCommentEvent extends ArticleInteractionEvent{

  final ArticleInteractionParams params;

  AddReplyToCommentEvent({required this.params});

  @override
  List<Object> get props {
    return [params];
  }
}

