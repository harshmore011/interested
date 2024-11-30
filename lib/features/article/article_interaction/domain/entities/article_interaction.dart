import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../../models/article_model.dart';

class ArticleInteractionParams extends Equatable {
  final String articleId;
  final CommentModel? comment;
  final ReplyModel? reply;
  final int? page;
  final int pageLength = 9;
  final QueryDocumentSnapshot<Map<String, dynamic>>? lastDoc;


  const ArticleInteractionParams({
    required this.articleId,
    this.comment,
    this.reply,
    this.page,
    this.lastDoc,
  });

  @override
  List<Object?> get props => [
        articleId,
        comment,
        reply,
        page,
        pageLength,
      ];
}
