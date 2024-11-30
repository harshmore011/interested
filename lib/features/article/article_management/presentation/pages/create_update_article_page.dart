import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

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
  XFile? _image;

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
      String? articleLabels;
      if (article != null) {
        articleLabels = article!.labels
            .map<String>((e) => e)
            .toList()
            .join(",");
      }
      _labelsController.text = articleLabels ?? 'dummy label';
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
                          if (_image != null) {
                            params.images.add(_image!);
                          }
                          logger.log(
                              "CreateUpdateArticlePage:build: BlocBuilder():saveAsDraft: labels",
                              "${_labelsController.text.split(",")}");
                          if (article != null) {
                            if (_image != null) {
                            for (var imgUrl in article.images) {
                              if (!imgUrl.contains(_image!.name)) {
                                params.imageDeleteList.add(imgUrl);
                                // _deleteImageList.add(imgUrl);
                              }
                            }
                            }
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
                          const Text(
                            "Title",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const  SizedBox(
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
                              style: const TextStyle(
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
                      const  SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          const  Text(
                            "Labels",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          const  SizedBox(
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
                          const SizedBox(width: 20,),
                          const Text("Tools", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                          const SizedBox(width: 20,),
                           IconButton(onPressed: () async
                           // => await _pickImage(),
                             {
                             if (_image == null) {
                               final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                               if(image != null) {
                                 logger.log(
                                     "CreateUpdateArticlePage:build: _pickImage()",
                                     "image: ${image.name}");
                                 setState(() {
                                   _image = image;
                                 });
                               } else {
                                 logger.log(
                                     "CreateUpdateArticlePage:build: _pickImage()",
                                     "image: null");
                               }

                             }else {
                               if (!context.mounted) return;
                               logger.log("CreateUpdateArticlePage:build: _pickImage()",
                                   "image: null");
                               var imageBytes = await _image!.readAsBytes();
                               if(!context.mounted) return;
                               showDialog(context: context, builder:
                               (context)  {

                                 return Dialog(
                                   elevation: 2,
                                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                   child: Card(
                                     child: Padding(
                                       padding: const EdgeInsets.all(32.0),
                                       child: Row(
                                         mainAxisSize: MainAxisSize.min,
                                         children: [
                                           Image(image: MemoryImage(imageBytes),
                                           width: 400,
                                           height: 400,),
                                           const SizedBox(width: 32,),
                                           IconButton(onPressed: () {
                                             setState(() {
                                               _image = null;
                                             });
                                             Navigator.pop(context);
                                           }, icon: Icon(Icons.delete, color: Colors.red),),
                                         ],
                                       ),
                                     ),
                                   ),
                                 );
                               });
                             }
                             },
                             icon: Icon(Icons.image),),
                          // const SizedBox(width: 20,),
                          // if (_image != null) Text(_image!.name, style: TextStyle(color:
                          // Colors.blue, fontSize: 18, fontStyle: FontStyle.italic),),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          // Text("Description", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                          const  SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            // constraints: BoxConstraints(maxWidth: double.infinity,
                            //     maxHeight: double.infinity,),
                            child: TextFormField(
                              minLines: 30,
                              maxLines: null,
                              style: const TextStyle(fontSize: 16),
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
