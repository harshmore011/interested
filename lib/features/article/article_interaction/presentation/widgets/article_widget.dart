import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/datetime_helper.dart';
import '../../../entities/article_entity.dart';
import '../blocs/article_interaction_state.dart';

class ArticleWidget extends StatefulWidget {
  const ArticleWidget(
      {super.key, required this.article, required this.homePageState});

  final Article article;
  final ArticleInteractionState homePageState;

  @override
  State<ArticleWidget> createState() => _ArticleWidgetState();
}

class _ArticleWidgetState extends State<ArticleWidget> {
  @override
  Widget build(BuildContext context) {
    var article = widget.article;

    // var homePageState = widget.homePageState;
    // logger.log("ArticleWidget:build", "homePageState: ${homePageState.runtimeType}");

    return Column(
      children: [
        Card(
          elevation: 2,
          child: InkWell(
            onTap: () {
              Navigator.of(context).pushNamed("/articlePage",
                  arguments: article);
            },
            child: SizedBox(
              width: 350,
              height: 340,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image(
                    // image: AssetImage("images/app_icon.png"),
                    // image: Image.memory("images/app_icon.png"),
                    image: article.images.isNotEmpty ? NetworkImage(article.images[0])
                        : AssetImage( kReleaseMode ? "assets/images/app_icon.png"
                        : "images/app_icon.png"),
                    filterQuality: FilterQuality.low,
                  width: 350,
                  height: 200,
                  fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 16,),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0,top: 16),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text(
                          article.publisher.name,
                          style: const TextStyle(fontWeight: FontWeight.bold
                          , fontSize: 16),
                        ),
                        const Text(
                          " | ",
                          style: TextStyle(fontWeight: FontWeight.bold
                          , fontSize: 16),
                        ),
                        Text(_setArticleDate(article),
                          style: const TextStyle(/*fontWeight: FontWeight.bold*/
                           fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
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
                      /*  BlocConsumer<ArticleInteractionBloc,
                                ArticleInteractionState>(
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
                             */
                        /*   case 'Update':
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
                                  _handleDeleteAction(context, article);*/
                        /*
                                  break;
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              List<PopupMenuEntry<String>> entries =
                                  <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                  value: 'ViewArticle',
                                  child: Text('View Article'),
                                ),
                                PopupMenuItem<String>(
                                  value: 'Update',
                                  child: Text('Update'),
                                ),
                                PopupMenuItem<String>(
                                  value: 'Delete',
                                  child: Text('Delete'),
                                ),
                              ];

                             *//* if (homePageState.runtimeType ==
                                      DraftArticlesFetchedState ||
                                  homePageState.runtimeType ==
                                      ScheduledArticlesFetchedState) {

                                entries.add(PopupMenuItem<String>(
                                  value: 'Publish',
                                  child: Text('Publish'),
                                ));
                              }*//*
                              return entries;
                            },
                          );
                        }, listener: (context, state) {
                          logger.log("ArticleWidget:build: BlocListener",
                              "current state: ${state.runtimeType}");
                         *//* if (state is ArticlePublishedState) {
                            SnackBarMessage.showSnackBar(
                                message: "The article is published",
                                context: context);

                            context
                                .read<ArticleInteractionBloc>()
                                .add(GetPublishedArticlesEvent());
                          } else*//* if (state is FailureState) {
                            SnackBarMessage.showSnackBar(
                                message: state.message, context: context);
                          }
                        },
                            // child: const Icon(Icons.more_vert),
                            listenWhen: (previous, current) {
                          return
                            // current is ArticlePublishedState ||
                            //   current is ArticleScheduledState ||
                            //   current is ArticleUnpublishedState ||
                            //   current is ArticleMarkedForDeletionState ||
                              current is FailureState;
                        }),*/
                      ],
                    ),
                  ),
                 /* Text(
                    article.description,
                    softWrap: true,
                    style: const TextStyle(fontSize: 16),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: 12,
                  ),*/

                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  String _setArticleDate(Article article) {
    return DateTimeHelper.indDateString(article.dateTimeCreated);

      // return "Deleted on ${article.dateTimeDeleted.toString().split(' ')[0]}";

  }


}
