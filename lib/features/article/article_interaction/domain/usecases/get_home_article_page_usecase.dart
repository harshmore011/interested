
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../../../core/failures/failures.dart';
import '../../../../../core/usecase/usecase.dart';
import '../../../entities/article_entity.dart';
import '../entities/article_interaction.dart';
import '../repositories/article_interaction_repository.dart';

class GetHomeArticlePageUseCase extends Usecase<(List<Article>, QueryDocumentSnapshot<Map<String, dynamic>>?), ArticleInteractionParams> {

  final ArticleInteractionRepository repository;

  GetHomeArticlePageUseCase(this.repository);

  @override
  Future<Either<Failure, (List<Article>, QueryDocumentSnapshot<Map<String, dynamic>>?)>>
  call(ArticleInteractionParams params)  async {

    return await repository.getHomeArticlePage(params);
  }

}