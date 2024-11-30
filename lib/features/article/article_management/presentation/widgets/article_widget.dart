import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/datetime_helper.dart';
import '../../../../../core/utils/debug_logger.dart';
import '../../../../../core/utils/snackbar_message.dart';
import '../../../article.dart';
import '../../../entities/article_entity.dart';
import '../blocs/article_management_bloc.dart';
import '../blocs/article_management_event.dart';
import '../blocs/article_management_state.dart';

class ArticleWidget extends StatefulWidget {
  const ArticleWidget(
      {super.key, required this.article, required this.homePageState});

  final Article article;
  final ArticleManagementState homePageState;

  @override
  State<ArticleWidget> createState() => _ArticleWidgetState();
}

class _ArticleWidgetState extends State<ArticleWidget> {
  @override
  Widget build(BuildContext context) {
    var article = widget.article;

    var homePageState = widget.homePageState;
    logger.log(
        "ArticleWidget:build", "homePageState: ${homePageState.runtimeType}");

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Card(
            elevation: 4,
            child: InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamed("/createUpdateArticlePage", arguments: article);
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 750,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              article.title,
                              softWrap: true,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          BlocConsumer<ArticleManagementBloc,
                                  ArticleManagementState>(
                              builder: (context, state) {
                            logger.log("ArticleWidget:build: BlocBuilder",
                                "current state: ${state.runtimeType}");

                            return PopupMenuButton<String>(
                              onSelected: (value) {
                                switch (value) {
                                  case 'ViewArticle':
                                    SnackBarMessage.showSnackBar(
                                        message: value, context: context);
                                    break;
                                  case 'Update':
                                    Navigator.pushNamed(
                                        context, "/createUpdateArticlePage",
                                        arguments: article);
                                    break;
                                  case 'Publish':
                                    _handlePublishAction(context, article);
                                    break;
                                  case 'Schedule':
                                    _handleScheduleAction(context, article);
                                    break;
                                  case 'RevertToDraft':
                                    _handleMoveToDraftAction(context, article);
                                    break;
                                  case 'Delete':
                                    _handleDeleteAction(context, article);
                                    break;
                                }
                              },
                              itemBuilder: (BuildContext context) {
                                List<PopupMenuEntry<String>> entries =
                                    <PopupMenuEntry<String>>[
                                  PopupMenuItem<String>(
                                    value: 'ViewArticle',
                                    child: const Text('View Article'),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'Update',
                                    child: const Text('Update'),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'Delete',
                                    child: const Text('Delete'),
                                  ),
                                ];

                                if (homePageState.runtimeType ==
                                        DraftArticlesFetchedState ||
                                    homePageState.runtimeType ==
                                        ScheduledArticlesFetchedState) {
                                  entries.add(PopupMenuItem<String>(
                                    value: 'Publish',
                                    child: const Text('Publish'),
                                  ));
                                }
                                if (homePageState.runtimeType ==
                                        DraftArticlesFetchedState ||
                                    homePageState.runtimeType ==
                                        ScheduledArticlesFetchedState) {
                                  entries.add(PopupMenuItem<String>(
                                    value: 'Schedule',
                                    child: const Text('Schedule'),
                                  ));
                                }
                                if (homePageState.runtimeType ==
                                        PublishedArticlesFetchedState ||
                                    homePageState.runtimeType ==
                                        ScheduledArticlesFetchedState) {
                                  entries.add(PopupMenuItem<String>(
                                    value: 'RevertToDraft',
                                    child: const Text('Revert to Draft'),
                                  ));
                                }
                                return entries;
                              },
                            );
                          }, listener: (context, state) {
                            logger.log("ArticleWidget:build: BlocListener",
                                "current state: ${state.runtimeType}");
                            if (state is ArticlePublishedState) {
                              SnackBarMessage.showSnackBar(
                                  message: "The article is published",
                                  context: context);

                              context
                                  .read<ArticleManagementBloc>()
                                  .add(GetPublishedArticlesEvent());
                            } else if (state is ArticleScheduledState) {
                              SnackBarMessage.showSnackBar(
                                  message:
                                      "Article will be published on ${article.dateTimeScheduled}",
                                  context: context);
                              context
                                  .read<ArticleManagementBloc>()
                                  .add(GetScheduledArticlesEvent());
                            } else if (state is ArticleUnpublishedState) {
                              SnackBarMessage.showSnackBar(
                                  message: "Article moved to draft",
                                  context: context);
                              context
                                  .read<ArticleManagementBloc>()
                                  .add(GetDraftArticlesEvent());
                            } else if (state is ArticleMarkedForDeletionState) {
                              SnackBarMessage.showSnackBar(
                                  message: "Article deleted", context: context);
                              /* context.read<ArticleManagementBloc>().add(
                                    DeleteArticleEvent(id: id));*/
                              context
                                  .read<ArticleManagementBloc>()
                                  .add(GetDraftArticlesEvent());
                            } else if (state is FailureState) {
                              SnackBarMessage.showSnackBar(
                                  message: state.message, context: context);
                            }
                          },
                              // child: const Icon(Icons.more_vert),
                              listenWhen: (previous, current) {
                            return current is ArticlePublishedState ||
                                current is ArticleScheduledState ||
                                current is ArticleUnpublishedState ||
                                current is ArticleMarkedForDeletionState ||
                                current is FailureState;
                          }),
                        ],
                      ),
                      Text(
                        article.description,
                        softWrap: true,
                        style: const TextStyle(fontSize: 16),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /* Text(
                            article.publisher.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),*/
                          Text(
                            _setArticleDate(article),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  void _handlePublishAction(BuildContext context, Article article) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Publish Article'),
          content: const Text('Are you sure you want to publish this article?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Publish'),
              onPressed: () {
                context
                    .read<ArticleManagementBloc>()
                    .add(PublishArticleEvent(id: article.id!));
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleScheduleAction(BuildContext context, Article article) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        var dateTimeController = TextEditingController();
        late DateTime ScheduledDateTime;

        return Dialog(
          child: SizedBox(
            width: 550,
            // height: 300,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Schedule this Article for Publish',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: dateTimeController,
                    decoration: const InputDecoration(
                      labelText: 'Select Date and Time',
                    ),
                    readOnly: true,
                    onTap: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
                      if (!context.mounted && !mounted) {
                        return;
                      }
                      if (pickedDate != null) {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null) {
                          ScheduledDateTime = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                          dateTimeController.text =
                              ScheduledDateTime.toString().split(".").first;
                        }
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ButtonStyle(
                      // textStyle: ,
                      // backgroundColor: WidgetStateProperty.all(AppTheme.colorPrimary),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      'Schedule', /* style: TextStyle(color: Colors.white),*/
                    ),
                    onPressed: () {
                      context
                          .read<ArticleManagementBloc>()
                          .add(SchedulePublishArticleEvent(
                              params: ArticleParams(
                            id: article.id!,
                            scheduledDateTime: ScheduledDateTime,
                          )));
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleMoveToDraftAction(BuildContext context, Article article) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text('Revert to Draft?'),
            content: const Text(
                'This article will be unpublished and reverted back to draft'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: Container(
                    color: Colors.white,
                    child: const Text(
                      'Revert to draft',
                      // style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onPressed: () {
                    context
                        .read<ArticleManagementBloc>()
                        .add(UnpublishArticleEvent(id: article.id!));
                    Navigator.of(context).pop();
                  })
            ]);
      },
    );
  }

  _handleDeleteAction(BuildContext context, Article article) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: const Text('Delete Article this article?'),
            content: const Text('This article will be permanently deleted'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                  child: Container(
                    color: Colors.white,
                    child: const Text(
                      'Delete',
                      // style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onPressed: () {
                    context
                        .read<ArticleManagementBloc>()
                        .add(DeleteArticleEvent(id: article.id!));
                    Navigator.of(context).pop();
                  })
            ]);
      },
    );
  }

  String _setArticleDate(Article article) {
    if (article.currentPublishState == ArticlePublishState.draft) {
      return "Created on ${DateTimeHelper.indDateString(article.dateTimeCreated)}";
    } else if (article.currentPublishState == ArticlePublishState.scheduled) {
      return "Scheduled on ${DateTimeHelper.indDateString(article.dateTimeScheduled!)}";
    } else if (article.currentPublishState == ArticlePublishState.published) {
      return "Published on ${DateTimeHelper.indDateString(article.dateTimePublished!)}";
    } else {
      return "";
      // return "Deleted on ${article.dateTimeDeleted.toString().split(' ')[0]}";
    }
  }
}
