import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/failures/failures.dart';
import '../../../../../core/success/success.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/debug_logger.dart';
import '../../domain/usecases/add_reply_to_comment_usecase.dart';
import '../../domain/usecases/comment_on_article_usecase.dart';
import '../../domain/usecases/like_article_usecase.dart';
import '../../domain/usecases/unlike_article_usecase.dart';
import '../../domain/usecases/save_article_usecase.dart';
import '../../domain/usecases/get_home_article_page_usecase.dart';
import '../../domain/usecases/unsave_article_usecase.dart';
import '../../domain/usecases/view_article_usecase.dart';
import 'article_interaction_event.dart';
import 'article_interaction_state.dart';

class ArticleInteractionBloc
    extends Bloc<ArticleInteractionEvent, ArticleInteractionState> {
  final AddReplyToCommentUseCase addReplyToCommentUseCase;
  final CommentOnArticleUseCase commentOnArticleUseCase;
  final ViewArticleUseCase viewArticleUseCase;
  final LikeArticleUseCase likeArticleUseCase;
  final UnlikeArticleUseCase unlikeArticleUseCase;
  final SaveArticleUseCase saveArticleUseCase;
  final UnSaveArticleUseCase unsaveArticleUseCase;
  final GetHomeArticlePageUseCase getArticlesUseCase;

  ArticleInteractionBloc({
    required this.addReplyToCommentUseCase,
    required this.commentOnArticleUseCase,
    required this.viewArticleUseCase,
    required this.likeArticleUseCase,
    required this.unlikeArticleUseCase,
    required this.saveArticleUseCase,
    required this.unsaveArticleUseCase,
    required this.getArticlesUseCase,
  }) : super(InitialState()) {
    on<ArticleInteractionEvent>((event, emit) async {
      logger.log("ArticleInteractionBloc", event.toString());

      if (event is GetArticlesEvent) {
        emit(LoadingState());
        final failureOrArticles =
        await getArticlesUseCase.call(event.params);

        failureOrArticles.fold((failure) {
          emit(FailureState(message: _mapFailureToMessage(failure)));
        }, (res) {
          emit(ArticlesFetchedState(response: res));
        });
      } else if (event is ViewArticleEvent) {
        final failureOrSuccess =
            await viewArticleUseCase.call(event.articleId);

        _emitFailureOrState(emit,failureOrSuccess, ArticleViewedState());
      }
      else if (event is LikeArticleEvent) {
        emit(LoadingState());
        final failureOrSuccess =
            await likeArticleUseCase.call(event.articleId);

        _emitFailureOrState(emit,failureOrSuccess, ArticleLikedState());
      } else if (event is UnlikeArticleEvent) {
        emit(LoadingState());
        final failureOrSuccess =
            await unlikeArticleUseCase.call(event.articleId);

        _emitFailureOrState(emit,failureOrSuccess, ArticleUnlikedState());
      } else if (event is CommentOnArticleEvent) {
        emit(LoadingState());
        final failureOrSuccess =
            await commentOnArticleUseCase.call(event.params);

        _emitFailureOrState(emit,failureOrSuccess, CommentAddedState());
      } else if (event is AddReplyToCommentEvent) {
        emit(LoadingState());
        final failureOrSuccess =
            await addReplyToCommentUseCase.call(event.params);

        _emitFailureOrState(emit,failureOrSuccess, ReplyAddedState());
      } else if (event is SaveArticleEvent) {
        emit(LoadingState());
        final failureOrSuccess =
            await saveArticleUseCase.call(event.articleId);

        _emitFailureOrState(emit,failureOrSuccess, ArticleSavedState());
      } else if (event is UnSaveArticleEvent) {
        emit(LoadingState());
        final failureOrSuccess =
            await saveArticleUseCase.call(event.articleId);

        _emitFailureOrState(emit,failureOrSuccess, ArticleUnsavedState());
      }
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case OfflineFailure:
        return Constant.OFFLINE_FAILURE_MESSAGE;
      case ServerFailure:
        return Constant.SERVER_FAILURE_MESSAGE;
      case UnAuthorizedFailure:
        return Constant.UNAUTHORIZED_USER_FAILURE_MESSAGE;
      default:
        return Constant.SERVER_FAILURE_MESSAGE;
    }
  }

  void _emitFailureOrState(Emitter<ArticleInteractionState> emit,
      Either<Failure, Success> failureOrSuccess, ArticleInteractionState state) {
    failureOrSuccess.fold((failure) {
      emit(FailureState(message: _mapFailureToMessage(failure)));
    }, (success) {
      emit(state);
    });
  }

}
