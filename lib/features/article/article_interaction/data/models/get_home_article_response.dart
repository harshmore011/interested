
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../models/article_model.dart';

class GetHomeArticleResponse {
  List<ArticleModel> articles;
  QueryDocumentSnapshot lastDoc;
  GetHomeArticleResponse({required this.articles, required this.lastDoc});
}