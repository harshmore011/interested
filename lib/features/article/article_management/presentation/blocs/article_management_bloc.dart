import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/failures/failures.dart';
import '../../../../../core/success/success.dart';
import '../../../../../core/utils/constants.dart';
import '../../../../../core/utils/debug_logger.dart';
import '../../domain/usecases/create_draft_article_usecase.dart';
import '../../domain/usecases/delete_article_usecase.dart';
import '../../domain/usecases/get_draft_articles_usecase.dart';
import '../../domain/usecases/get_published_articles_usecase.dart';
import '../../domain/usecases/get_scheduled_articles_usecase.dart';
import '../../domain/usecases/publish_article_usecase.dart';
import '../../domain/usecases/schedule_publish_article_usecase.dart';
import '../../domain/usecases/unpublish_article_usecase.dart';
import '../../domain/usecases/update_article_usecase.dart';
import 'article_management_event.dart';
import 'article_management_state.dart';

class ArticleManagementBloc
    extends Bloc<ArticleManagementEvent, ArticleManagementState> {
  final GetDraftArticlesUseCase getDraftArticlesUseCase;
  final GetPublishedArticlesUseCase getPublishedArticlesUseCase;
  final GetScheduledArticlesUseCase getScheduledArticlesUseCase;
  final CreateDraftArticleUseCase createDraftArticleUseCase;
  final SchedulePublishArticleUseCase schedulePublishArticleUseCase;
  final PublishArticleUseCase publishArticleUseCase;
  final UnpublishArticleUseCase unpublishArticleUseCase;
  final UpdateArticleUseCase updateArticleUseCase;
  final DeleteArticleUseCase deleteArticleUseCase;

  ArticleManagementBloc({
    required this.getDraftArticlesUseCase,
    required this.getPublishedArticlesUseCase,
    required this.getScheduledArticlesUseCase,
    required this.createDraftArticleUseCase,
    required this.schedulePublishArticleUseCase,
    required this.publishArticleUseCase,
    required this.unpublishArticleUseCase,
    required this.updateArticleUseCase,
    required this.deleteArticleUseCase,
  }) : super(InitialState()) {
    on<ArticleManagementEvent>((event, emit) async {
      logger.log("ArticleManagementBloc", event.toString());

      if (event is GetDraftArticlesEvent) {
        emit(LoadingState());
        final failureOrArticles =
        await getDraftArticlesUseCase.call(unit);

        failureOrArticles.fold((failure) {
          emit(FailureState(message: _mapFailureToMessage(failure)));
        }, (articles) {
          emit(DraftArticlesFetchedState(articles: articles));
        });
      } else if (event is GetPublishedArticlesEvent) {
        emit(LoadingState());
        final failureOrArticles =
        await getPublishedArticlesUseCase.call(unit);

        failureOrArticles.fold((failure) {
          emit(FailureState(message: _mapFailureToMessage(failure)));
        }, (articles) {
          emit(PublishedArticlesFetchedState(articles: articles));
        });
      } else if (event is GetScheduledArticlesEvent) {
        emit(LoadingState());
        final failureOrArticles =
        await getScheduledArticlesUseCase.call(unit);

        failureOrArticles.fold((failure) {
          emit(FailureState(message: _mapFailureToMessage(failure)));
        }, (articles) {
          emit(ScheduledArticlesFetchedState(articles: articles));
        });
      } else if (event is CreateDraftArticleEvent) {
        emit(LoadingState());
        final failureOrSuccess =
            await createDraftArticleUseCase.call(event.params);

        _emitFailureOrState(emit,failureOrSuccess, DraftArticleCreatedState());
      } else if (event is SchedulePublishArticleEvent) {
        emit(LoadingState());
        final failureOrSuccess =
            await schedulePublishArticleUseCase.call(event.params);

        _emitFailureOrState(emit,failureOrSuccess, ArticleScheduledState());
      } else if (event is PublishArticleEvent) {
        emit(LoadingState());
        final failureOrSuccess =
            await publishArticleUseCase.call(event.id);

        _emitFailureOrState(emit,failureOrSuccess, ArticlePublishedState());
      } else if (event is UnpublishArticleEvent) {
        emit(LoadingState());
        final failureOrSuccess =
            await unpublishArticleUseCase.call(event.id);

        _emitFailureOrState(emit,failureOrSuccess, ArticleUnpublishedState());
      } else if (event is UpdateArticleEvent) {
        emit(LoadingState());
        final failureOrSuccess =
            await updateArticleUseCase.call(event.params);

        _emitFailureOrState(emit,failureOrSuccess, ArticleUpdatedState());

      } else if (event is DeleteArticleEvent) {
        emit(LoadingState());
        final failureOrSuccess =
            await deleteArticleUseCase.call(event.id);

        _emitFailureOrState(emit,failureOrSuccess, ArticleMarkedForDeletionState());

      }
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case OfflineFailure:
        return Constant.OFFLINE_FAILURE_MESSAGE;
      case ServerFailure:
        return Constant.SERVER_FAILURE_MESSAGE;
      case NoUserFailure:
        return Constant.NO_USER_FAILURE_MESSAGE;
      default:
        return Constant.SERVER_FAILURE_MESSAGE;
    }
  }

  void _emitFailureOrState(Emitter<ArticleManagementState> emit,
      Either<Failure, Success> failureOrSuccess, ArticleManagementState state) {
    failureOrSuccess.fold((failure) {
      emit(FailureState(message: _mapFailureToMessage(failure)));
    }, (success) {
      emit(state);
    });
  }

}
