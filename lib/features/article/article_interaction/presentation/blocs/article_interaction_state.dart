
// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import '../../../entities/article_entity.dart';

abstract class ArticleInteractionState extends Equatable {
  @override
  List<Object> get props {
    return [];
  }
}

class InitialState extends ArticleInteractionState{}

class LoadingState extends ArticleInteractionState{}

class ArticlesFetchedState extends ArticleInteractionState{
  // final List<Article> articles;
  // final QueryDocumentSnapshot? nextLastDoc;
 final (List<Article>, QueryDocumentSnapshot<Map<String, dynamic>>?) response;
 // final (List<Article>, DocumentSnapshot<Map<String, dynamic>>?) state;

 ArticlesFetchedState({required this.response});

  // ArticlesFetchedState({required this.articles, required this.nextLastDoc});

  @override
  List<Object> get props {
    // return [articles, nextLastDoc,];
    return [response,];
  }
}

class ArticleViewedState extends ArticleInteractionState{}

class ArticleLikedState extends ArticleInteractionState{}

class ArticleUnlikedState extends ArticleInteractionState{}

class ArticleSavedState extends ArticleInteractionState{}

class ArticleUnsavedState extends ArticleInteractionState{}

class CommentAddedState extends ArticleInteractionState{}

class ReplyAddedState extends ArticleInteractionState{}

class FailureState extends ArticleInteractionState{
  final String message;

  FailureState({required this.message});

  @override
  List<Object> get props {
    return [message];
  }
}

// class OnboardingCompletedState extends OnboardingState{}

