import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/dependency_injector.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/auth_helper.dart';
import '../../../../../core/utils/datetime_helper.dart';
import '../../../../../core/utils/debug_logger.dart';
import '../../../../../core/utils/shared_pref_helper.dart';
import '../../../../authentication/domain/entities/auth.dart';
import '../../../../authentication/domain/entities/user_entity.dart';
import '../../../../authentication/presentation/blocs/authentication_bloc.dart';
import '../../../../authentication/presentation/blocs/authentication_state.dart';
import '../../../entities/article_entity.dart';
import '../../../models/article_model.dart';
import '../../domain/entities/article_interaction.dart';
import '../blocs/article_interaction_bloc.dart';
import '../blocs/article_interaction_event.dart';
import '../blocs/article_interaction_state.dart';
import '../widgets/comment_widget.dart';

class ArticlePage extends StatefulWidget {
  final Article article;

  const ArticlePage({super.key, required this.article});

  @override
  State<ArticlePage> createState() => _ArticlePageState();
}

class _ArticlePageState extends State<ArticlePage> {
  late final Article article;
  bool _isLiked = false;
  bool _isSaved = false;

  // bool _unAuthorizedUser = false;

  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    article = widget.article;
    BlocProvider.of<ArticleInteractionBloc>(context)
        .add(ViewArticleEvent(articleId: article.id!));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /*   if (ModalRoute.of(context)!.settings.arguments != null) {
      article = ModalRoute
          .of(context)!
          .settings
          .arguments as Article;
    }*/

    return SafeArea(
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(

      buildWhen: (previous, current) {
            return current is AnonymousSignedInState ||
                current is UserSignedInState ||
                current is AnonymousLinkedToUserState ||
            current is UserSignedUpState;
          },
    builder: (context, state) {
        logger.log("ArticlePage", "rebuild with state: ${state.runtimeType}");

      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          // backgroundColor: Colors.white,
          title: const Text(
            "interested!",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                fontSize: 18),
          ),
          actions: [
            if (sl.isRegistered<User>(instanceName: "currentUser"))
              Text(
                sl<User>(instanceName: "currentUser").name,
                style: TextStyle(color: AppTheme.colorPrimary),
              ),
          ],
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  top: 130, left: 275, right: 275, bottom: 200),
              child: Column(children: [
                Text(
                  article.title,
                  style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      DateTimeHelper.indDateString(article.dateTimePublished!),
                      style: const TextStyle(
                        /*fontWeight: FontWeight.bold,*/
                          fontSize: 18),
                    ),
                    Row(
                      children: [
                        const Text("Published by ",
                            style: TextStyle(fontSize: 18)),
                        Text(
                          article.publisher.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                      ],
                    ),
                  ],
                ),
                // Image.network("src", filterQuality: FilterQuality.low,)

                if (article.images.isNotEmpty)
                  Image(
                    // image: AssetImage("images/app_icon.png"),
                    // image: Image.memory("images/app_icon.png"),
                    image: NetworkImage(article.images[0]),
                    filterQuality: FilterQuality.medium,
                    width: 625,
                    height: 500,
                  ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  article.description,
                  softWrap: true,
                  style: TextStyle(fontSize: 18),
                  // textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Text(
                      "Labels:  ",
                      // softWrap: true,
                      // textAlign: TextAlign.center,
                    ),
                    for (var label in article.labels)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Chip(label: Text(label)),
                      ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                BlocBuilder<ArticleInteractionBloc, ArticleInteractionState>(
                  builder: (context, state) {
                    logger.log(
                        "ArticlePage:build()", "state: ${state.runtimeType}");
                    CommentModel? comment;

                    /* if (state is FailureState) {
                    if (state.message == "Unauthorized user") {
                      // setState(() {
                      _unAuthorizedUser = true;
                      // });
                    }
                  }*/

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    logger.log("ArticlePage:build()",
                                        "Like button pressed");
                                    if (await AuthHelper.isUserUnAuthorized()) {
                                      // Future.delayed(Duration(seconds: 1), () {
                                      if (!context.mounted) return;
                                      AuthHelper.showAuthDialog(context,
                                          navigateTo: AuthSuccessNavigation
                                              .stay);
                                      // });
                                      return;
                                    } else {
                                      if (!context.mounted) return;

                                      if (!_isLiked) {
                                        _isLiked = !_isLiked;
                                        context
                                            .read<ArticleInteractionBloc>()
                                            .add(LikeArticleEvent(
                                            articleId: article.id!));
                                      } else {
                                        context
                                            .read<ArticleInteractionBloc>()
                                            .add(UnlikeArticleEvent(
                                            articleId: article.id!));
                                      }

                                      if (state is ArticleLikedState ||
                                          state is ArticleUnlikedState) {
                                        setState(() {
                                          _isLiked = _isLiked;
                                        });
                                      }
                                    }
                                  },
                                  icon: Icon(_isLiked
                                      ? Icons.thumb_up
                                      : Icons.thumb_up_outlined),
                                ),
                                Text("${article.likes + (_isLiked ? 1 : 0)}"),
                                const SizedBox(
                                  width: 12,
                                ),
                                IconButton(
                                  onPressed: () {
                                    // context.read<ArticleInteractionBloc>().add(CommentOnArticleEvent(articleId: article.id!));
                                  },
                                  icon: Icon(Icons.comment),
                                ),
                                Text("${article.comments.length}"),
                              ],
                            ),
                            IconButton(
                              onPressed: () async {
                                if (await AuthHelper.isUserUnAuthorized()) {
                                  // Future.delayed(Duration(seconds: 1), () {
                                  if (!context.mounted) return;
                                  AuthHelper.showAuthDialog(context,
                                      navigateTo: AuthSuccessNavigation.stay);
                                  // });
                                  return;
                                } else {
                                  _isSaved = !_isSaved;
                                  if (!context.mounted) return;
                                  if (_isSaved) {
                                    context.read<ArticleInteractionBloc>().add(
                                        SaveArticleEvent(
                                            articleId: article.id!));
                                  } else {
                                    context.read<ArticleInteractionBloc>().add(
                                        UnSaveArticleEvent(
                                            articleId: article.id!));
                                  }
                                  if (state is ArticleSavedState ||
                                      state is ArticleUnsavedState) {
                                    setState(() {});
                                  }
                                  /* context
                                  .read<ArticleInteractionBloc>()
                                  .add(SaveArticleEvent(articleId: article.id!));*/
                                }
                              },
                              icon: Icon(_isSaved
                                  ? Icons.bookmark
                                  : Icons.bookmark_border_outlined),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        TextField(
                          controller: _commentController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Comment',
                            hintText: 'Say something...',
                          ),
                        ),
                        /*EditableText(
                        controller: _commentController,
                        focusNode: FocusNode(),
                        style: TextStyle(fontSize: 16),
                        cursorColor: Colors.black,
                        backgroundCursorColor: Colors.black,
                      ),*/
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () async {
                            if (await AuthHelper.isUserUnAuthorized()) {
                              // Future.delayed(Duration(seconds: 1), () {
                              if (!context.mounted) return;
                              AuthHelper.showAuthDialog(context,
                                  navigateTo: AuthSuccessNavigation.stay);
                              // });
                              return;
                            } else {
                              if (_commentController.text.isEmpty) {
                                return;
                              }
                              if (!sl.isRegistered<User>(
                                  instanceName: "currentUser")) {
                                await SharedPrefHelper.reloadCurrentUser();
                              }

                              User user =
                              sl.get<User>(instanceName: "currentUser");

                              comment = CommentModel(
                                id: DateTime
                                    .now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                comment: _commentController.text,
                                dateTimeCommented: DateTime.now(),
                                user: user.name,
                                isLikedByPublisher: false,
                              );

                              if (!context.mounted) return;
                              context
                                  .read<ArticleInteractionBloc>()
                                  .add(CommentOnArticleEvent(
                                params: ArticleInteractionParams(
                                  articleId: article.id!,
                                  comment: comment,
                                ),
                              ));

                              if (state is CommentAddedState) {
                                article.comments.add(comment!.toEntity());
                                setState(() {
                                });
                              }
                            }
                          },
                          child: const Text("Comment"),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        if (article.comments.isEmpty)
                          const Text(
                            "No comments yet",
                            // style: TextStyle(fontWeight: FontWeight.bold),
                            // textAlign: TextAlign.center,
                          ),
                        if (article.comments.isNotEmpty)
                          Flexible(
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: article.comments.length,
                                itemBuilder: (context, index) {
                                  return CommentWidget(
                                    state: state,
                                    article: article,
                                    comment: article.comments[index],
                                  );
                                }),
                          ),
                      ],
                    );
                  },
                ),
              ]),
            ),
          ],
        ),
      );
    }
    )
    );
  }
}
