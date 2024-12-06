import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/auth_helper.dart';
import '../../../../../core/utils/datetime_helper.dart';
import '../../../../authentication/domain/entities/auth.dart';
import '../../../entities/article_entity.dart';
import '../../../models/article_model.dart';
import '../../domain/entities/article_interaction.dart';
import '../blocs/article_interaction_bloc.dart';
import '../blocs/article_interaction_event.dart';
import '../blocs/article_interaction_state.dart';

class CommentWidget extends StatefulWidget {
  final ArticleInteractionState state;
  final Comment comment;
  final bool isUnAuthorizedUser;
  final Article article;

  const CommentWidget({
    super.key,
    required this.comment,
    required this.state,
    required this.article,
    required this.isUnAuthorizedUser,
  });

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  late Comment comment;
  late Article article;
  final TextEditingController _replyController = TextEditingController();
  bool isReplying = false;

  @override
  Widget build(BuildContext context) {
    comment = widget.comment;
    article = widget.article;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(comment.user,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(width: 16),
              Text(
                DateTimeHelper.indDateString(comment.dateTimeCommented),
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment.comment,
            style: TextStyle(fontSize: 16),
          ),
          BlocBuilder<ArticleInteractionBloc, ArticleInteractionState>(
            builder: (context, state) => Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (isReplying)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextField(
                      controller: _replyController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Reply',
                      ),
                    ),
                  ),
                // const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 5.0),
                  child: TextButton(
                      onPressed: () {
                        if (widget.isUnAuthorizedUser) {
                          Future.delayed(Duration(seconds: 1), () {
                            if (!context.mounted) return;
                            AuthHelper.showAuthDialog(context,
                                navigateTo: AuthSuccessNavigation.stay);
                          });
                          return;
                        }

                        ReplyModel? reply;
                        if (isReplying && _replyController.text.isNotEmpty) {
                          reply = ReplyModel(
                            reply: _replyController.text,
                            dateTimeReplied: DateTime.now(),
                            user: comment.user,
                            // publisher: comment.publisher
                          );
                          CommentModel commentModel = CommentModel(
                            id: comment.id,
                            user: comment.user,
                            comment: comment.comment,
                            // replies: comment.replies,
                            isLikedByPublisher: comment.isLikedByPublisher,
                            dateTimeCommented: comment.dateTimeCommented,
                          );
                          context.read<ArticleInteractionBloc>().add(
                                AddReplyToCommentEvent(
                                  params: ArticleInteractionParams(
                                    articleId: article.id!,
                                    comment: commentModel,
                                    reply: reply,
                                  ),
                                ),
                              );
                        }
                        if (state is ReplyAddedState) {
                          setState(() {
                            if (reply != null) {
                              comment.replies.add(reply.toEntity());
                            }
                            isReplying = !isReplying;
                          });
                        }
                      },
                      child: const Text('Reply')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          if (comment.replies.isNotEmpty)
            Column(mainAxisSize: MainAxisSize.min, children: [
              Flexible(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: comment.replies.length,
                    itemBuilder: (context, index) {
                      return ReplyWidget(reply: comment.replies[index]);
                    }),
              ),

              /* comment.replies
                .map<ReplyWidget>((reply) => ReplyWidget(reply: reply))
                .toList(),*/
            ]),
        ],
      ),
    );
  }
}

class ReplyWidget extends StatefulWidget {
  final Reply reply;

  const ReplyWidget({super.key, required this.reply});

  @override
  State<ReplyWidget> createState() => _ReplyWidgetState();
}

class _ReplyWidgetState extends State<ReplyWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.reply.user!,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(width: 16),
              Text(
                DateTimeHelper.indDateString(widget.reply.dateTimeReplied),
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            widget.reply.reply,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
