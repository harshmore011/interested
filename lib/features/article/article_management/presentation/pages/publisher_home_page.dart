import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/di/dependency_injector.dart';
import '../../../../../core/utils/debug_logger.dart';
import '../../../../../core/utils/shared_pref_helper.dart';
import '../../../../../core/utils/snackbar_message.dart';
import '../../../../authentication/domain/entities/publisher_entity.dart';
import '../../../../authentication/presentation/blocs/authentication_bloc.dart';
import '../../../../authentication/presentation/blocs/authentication_event.dart';
import '../../../../authentication/presentation/blocs/authentication_state.dart'
    show AuthenticationState, SignedOutState;
import '../blocs/article_management_bloc.dart';
import '../blocs/article_management_event.dart';
import '../blocs/article_management_state.dart';
import '../widgets/article_widget.dart';

class PublisherHomePage extends StatefulWidget {
  const PublisherHomePage({super.key});

  @override
  State<PublisherHomePage> createState() => _PublisherHomePageState();
}

class _PublisherHomePageState extends State<PublisherHomePage> {
  int _selectedTileIndex = 0;

  @override
  void initState() {
    // Dispatching the Event
    BlocProvider.of<ArticleManagementBloc>(context)
        .add(GetDraftArticlesEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              SnackBarMessage.showSnackBar(
                  message: "Settings...", context: context);
            },
          ),
        ],
      ),
      // drawer:
      floatingActionButton: FloatingActionButton(
        tooltip: "Create New Article",
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed("/createUpdateArticlePage");
        },
      ),
      body: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 4,
            child: Drawer(
              // elevation: 4,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  /* DrawerHeader(
                    decoration: BoxDecoration(
              color: Colors.white,),
                        // color: AppTheme.colorPrimary.withOpacity(0.8),),
                    child: */ /*Text(
                      'interested!',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    )*/ /*Container(),
                  ),*/
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<ArticleManagementBloc,
                          ArticleManagementState>(
                          builder: (context, state) {
                        logger.log("PublisherHomePage: build: BlocBuilder",
                            "current state: ${state.runtimeType}");

                        return Column(children: [
                          ListTile(
                            // tileColor: AppTheme.tertiaryColor,
                            // selectedTileColor: ,
                            // selectedColor: ,
                            selected: _selectedTileIndex == 0,
                            title: Text('Drafts'),
                            onTap: () {
                              setState(() {
                                _selectedTileIndex = 0;
                              });
                              context
                                  .read<ArticleManagementBloc>()
                                  .add(GetDraftArticlesEvent());
                            },
                          ),
                          ListTile(
                            selected: _selectedTileIndex == 1,
                            title: Text('Published'),
                            onTap: () {
                              setState(() {
                                _selectedTileIndex = 1;
                              });
                              context
                                  .read<ArticleManagementBloc>()
                                  .add(GetPublishedArticlesEvent());
                            },
                          ),
                          ListTile(
                            selected: _selectedTileIndex == 2,
                            title: Text('Scheduled'),
                            onTap: () {
                              setState(() {
                                _selectedTileIndex = 2;
                              });
                              context
                                  .read<ArticleManagementBloc>()
                                  .add(GetScheduledArticlesEvent());
                            },
                          )
                        ]);
                      }
                      ),
                    ],
                  ),
                  BlocConsumer<AuthenticationBloc, AuthenticationState>(
                    builder: (_, state) {
                      logger.log("PublisherHomePage: build: consumer",
                          "current state: ${state.runtimeType}");

                      return Column(
                        children: [
                          const Divider(),
                          ListTile(
                            title: Text('Sign Out'),
                            onTap: () {
                              context
                                  .read<AuthenticationBloc>()
                                  .add(SignOutEvent());
                            },
                          ),
                        ],
                      );
                    },
                    listener: (_, state) async {
                      logger.log("PublisherHomePage: LISTENER",
                          "current state: ${state.runtimeType}");

                      if (state is SignedOutState) {
                        if (sl.isRegistered<Publisher>(
                            instanceName: "currentUser")) {
                          sl.unregister<Publisher>(instanceName: "currentUser");
                        }
                        await SharedPrefHelper.clearPersonLocally();
                        if (!context.mounted) return;
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            "/onboardingPage", (Route<dynamic> route) => false);

                        /* FirebaseAuth.instance
                            .userChanges()
                            .listen((User? user) async {
                          if (user == null) {
                            if(sl.isRegistered(instanceName: "currentUser")) {
                              sl.unregister(instanceName: "currentUser");
                            }
                            await SharedPrefHelper.clearPersonLocally();
                            if(!context.mounted) return;
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                "/onboardingPage", (Route<dynamic> route) => false);
                          } else {
                            if (!sl.isRegistered(instanceName: "currentUser")) {
                              await SharedPrefHelper.reloadCurrentUser();
                            }
                            if (!sl.isRegistered(instanceName: "currentUser")) {
                              FirebaseAuth.instance.signOut();
                              if (!context.mounted) return;
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  "/onboardingPage", (
                                  Route<dynamic> route) => false);
                            }
                          }
                        });*/
                      }
                    },
                    listenWhen: (previous, current) {
                      return current is SignedOutState;
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: BlocConsumer<ArticleManagementBloc, ArticleManagementState>(
              builder: (context, state) {
                logger.log("PublisherHomePage: build: BlocBuilder 2",
                    "current state: ${state.runtimeType}");
                final articles = [];
                var emptyListMessage = "No articles found";

                if (state is LoadingState) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is DraftArticlesFetchedState) {
                  articles.addAll(state.articles);
                  if (_selectedTileIndex != 0) {
                    setState(() {
                      _selectedTileIndex = 0;
                    });
                  }
                  emptyListMessage = "Start creating a draft article!";
                } else if (state is PublishedArticlesFetchedState) {
                  articles.addAll(state.articles);
                  if (_selectedTileIndex != 1) {
                    setState(() {
                      _selectedTileIndex = 1;
                    });
                  }
                  emptyListMessage = "No published articles!";
                } else if (state is ScheduledArticlesFetchedState) {
                  articles.addAll(state.articles);
                  if (_selectedTileIndex != 2) {
                    setState(() {
                      _selectedTileIndex = 2;
                    });
                  }
                  emptyListMessage =
                      "Your scheduled articles will appear here!";
                } else if (state is FailureState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(state.message),
                        const SizedBox(
                          height: 4,
                        ),
                        /*  MaterialButton(
                        onPressed: () {
                          context
                              .read<ArticleManagementBloc>()
                              .add(GetDraftArticlesEvent());
                        },
                        child: const Text("RETRY"),
                      )*/
                      ],
                    ),
                  );
                }

                if (articles.isEmpty) {
                  return Center(
                    child: Text(emptyListMessage),
                  );
                }

                logger.log("PublisherHomePage: build: BlocBuilder 2",
                    "total articles: ${articles.length}");

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: ListView.builder(
                          padding: EdgeInsets.all(10),
                          itemCount: articles.length,
                          itemBuilder: (context, index) {
                            return ArticleWidget(
                                homePageState: state, article: articles[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },buildWhen: (previous, current) {
                return current is DraftArticlesFetchedState ||
                    current is PublishedArticlesFetchedState ||
                    current is ScheduledArticlesFetchedState ||
                    current is LoadingState ||
                    // current is ArticleScheduledState ||
                    // current is ArticlePublishedState ||
                    current is FailureState;
              },
              listener: (BuildContext context, ArticleManagementState state) {},
              listenWhen: (previous, current) {
                return current is DraftArticlesFetchedState ||
                    current is PublishedArticlesFetchedState ||
                    current is ScheduledArticlesFetchedState ||
                    current is LoadingState ||
                    // current is ArticleScheduledState ||
                    // current is ArticlePublishedState ||
                    current is FailureState;
              },
            ),
          ),
        ],
      ),
    ));
  }
}
