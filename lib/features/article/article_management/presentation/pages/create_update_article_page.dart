import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/debug_logger.dart';
import '../../../../../core/utils/snackbar_message.dart';
import '../../../article.dart';
import '../../../entities/article_entity.dart';
import '../blocs/article_management_bloc.dart';
import '../blocs/article_management_event.dart';
import '../blocs/article_management_state.dart';

class CreateUpdateArticlePage extends StatefulWidget {
  const CreateUpdateArticlePage({super.key});

  @override
  State<CreateUpdateArticlePage> createState() =>
      _CreateUpdateArticlePageState();
}

class _CreateUpdateArticlePageState extends State<CreateUpdateArticlePage> {
  Article? article;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _labelsController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    article = ModalRoute.of(context)!.settings.arguments as Article?;

    if(_titleController.text.isEmpty) {
      _titleController.text = article?.title ?? 'A dummy title';
      _labelsController.text = article?.labels.first ?? 'dummy label';
      _descriptionController.text = article?.description ??
          'dummy description which ideally should be too long'
              "nearly about 2000 characters but anyway that's fine";
    }
    /*_titleController.text = article?.title ?? 'A dummy title';
    _labelsController.text = article?.labels.first ?? 'dummy label';
    _descriptionController.text = article?.description ??
        'dummy description which ideally should be too long'
            "nearly about 2000 characters but anyway that's fine";*/

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Article'),
          actions: [
            BlocBuilder<ArticleManagementBloc, ArticleManagementState>(
              builder: (context, state) {
                logger.log("CreateUpdateArticlePage:build: BlocBuilder()",
                    "state: $state");

                return PopupMenuButton<String>(
                  onSelected: (value) {
                    // SnackBarMessage.showSnackBar(message: value, context: context);
                    switch (value) {
                      case 'Preview':
                        break;
                      case 'Discard':
                        Navigator.pop(context);
                        break;
                      case 'SaveAsDraft':
                        // TODO: Decide weather to create or update ,DONE!
                        final article = this.article;
                        if (_formKey.currentState!.validate()) {
                          ArticleParams params = ArticleParams(
                            title: _titleController.text,
                            description: _descriptionController.text,
                            id: article?.id,
                          );
                          params.labels
                              .addAll(_labelsController.text.split(","));

                          logger.log(
                              "CreateUpdateArticlePage:build: BlocBuilder():saveAsDraft: labels",
                              "${_labelsController.text.split(",")}");
                          if (article != null) {
                            context
                                .read<ArticleManagementBloc>()
                                .add(UpdateArticleEvent(params: params));
                          } else {
                            context
                                .read<ArticleManagementBloc>()
                                .add(CreateDraftArticleEvent(params: params));
                          }
                        }
                        break;
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: 'Preview',
                      child: Text('Preview'),
                    ),
                    PopupMenuItem<String>(
                      value: 'Discard',
                      child: Text('Discard'),
                    ),
                    PopupMenuItem<String>(
                      value: 'SaveAsDraft',
                      child: Text('Save as draft'),
                    ),
                  ],
                );
              },
              /* buildWhen: (previous, current) {
                logger.log("CreateUpdateArticlePage:build: BlocBuilder()",
                    "previous: $previous, current: $current");
                return true;
              },*/
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(children: [
              BlocListener<ArticleManagementBloc, ArticleManagementState>(
                child: Container(),
                listener: (context, state) {
                  if (state is DraftArticleCreatedState ||
                      state is ArticleUpdatedState) {
                    SnackBarMessage.showSnackBar(
                        message: "Article saved as Draft", context: context);
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        "/publisherHomePage", (Route<dynamic> route) => false);
                  } else if (state is FailureState) {
                    SnackBarMessage.showSnackBar(
                        message: state.message, context: context);
                  }

                  // return Container();
                },
                listenWhen: (previous, current) {
                  return current is FailureState ||
                      current is DraftArticleCreatedState ||
                      current is ArticleUpdatedState;
                },
              ),
              Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Title",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(
                            width: 40,
                          ),
                          Flexible(
                            fit: FlexFit.loose,
                            // constraints: BoxConstraints(maxWidth: double.infinity),
                            child: TextFormField(
                              controller: _titleController,
                              // controller: _titleController..text = article?.title ?? 'A dummy title',
                              minLines: 2,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 18, ),
                              decoration: const InputDecoration(
                                // labelText: 'Title',
                                hintText: 'Title',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Title cannot be empty';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Text(
                            "Labels",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 550),
                            child: TextFormField(
                              controller: _labelsController,
                              maxLines: 1,
                              decoration: const InputDecoration(
                                hintText: 'Labels',
                                helper: Tooltip(
                                  message:
                                      'Labels that describes what the article is about '
                                      '(Separate multiple labels by comma)',
                                  child: Icon(Icons.help_outline),
                                ),
                                // hintText: 'Separate multiple labels by comma',
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          // Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                          SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            // constraints: BoxConstraints(maxWidth: double.infinity,
                            //     maxHeight: double.infinity,),
                            child: TextFormField(
                              minLines: 30,
                              maxLines: null,
                              style: TextStyle(fontSize: 16),
                              cursorOpacityAnimates: false,
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                // labelText: 'Description',
                                hintText: 'Start writing from here...',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ]),
          ),
        ),
      ),
    );
  }
}
