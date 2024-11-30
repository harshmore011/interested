
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/di/dependency_injector.dart';
import '../../../../../core/theme/app_theme.dart';
import '../../../../../core/utils/auth_helper.dart';
import '../../../../../core/utils/debug_logger.dart';
import '../../../../../core/utils/shared_pref_helper.dart';
import '../../../../../core/utils/snackbar_message.dart';
import '../../../../authentication/domain/entities/anonymous_entity.dart';
import '../../../../authentication/domain/entities/user_entity.dart';
import '../../../../authentication/presentation/blocs/authentication_bloc.dart';
import '../../../../authentication/presentation/blocs/authentication_event.dart';
import '../../../../authentication/presentation/blocs/authentication_state.dart'
    show AuthenticationState, SignedOutState;
import '../../../article_interaction/presentation/widgets/article_widget.dart';
import '../../../entities/article_entity.dart';
import '../../domain/entities/article_interaction.dart';
import '../blocs/article_interaction_bloc.dart';
import '../blocs/article_interaction_event.dart';
import '../blocs/article_interaction_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  int _selectedTileIndex = 0;
  QueryDocumentSnapshot<Map<String, dynamic>>? _lastDoc;
  final ScrollController _scrollController = ScrollController();
  final  List<Article> _articles = [];


  @override
  void initState() {
    super.initState();
    // Dispatching the Event

    logger.log("_initState()", "Started, calling getArticlesEvent:");
    BlocProvider.of<ArticleInteractionBloc>(context)
        .add(GetArticlesEvent(params: ArticleInteractionParams(articleId: "",
    page: 1, lastDoc: null)));

    _scrollController.addListener(_loadMoreItems);

  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void _loadMoreItems() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      logger.log("_loadMoreItems()", "Listener called getArticlesEvent:");

      BlocProvider.of<ArticleInteractionBloc>(context)
          .add(GetArticlesEvent(params: ArticleInteractionParams(articleId: "",
          // page: 1,
          lastDoc: _lastDoc)));
    }
  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
          appBar: AppBar(automaticallyImplyLeading: true,
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
              if (sl.isRegistered<Anonymous>(instanceName: "currentUser"))
              TextButton(
                child: const Text("Sign up"),
                onPressed: () async {
                 /* if(!sl.isRegistered(instanceName: "currentUser")){
                    await SharedPrefHelper.reloadCurrentUser();
                  } */
                  AuthHelper.showAuthDialog(context);
                },
              ),
              if (sl.isRegistered<Anonymous>(instanceName: "currentUser"))
              MaterialButton(
                // color: AppTheme.colorPrimary,
                child: const Text("Log in"),
                onPressed: () async {
                 /* if(!sl.isRegistered(instanceName: "currentUser")){
                    await SharedPrefHelper.reloadCurrentUser();
                  } */
                  AuthHelper.showAuthDialog(context);
                },
              ),
              /*IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  SnackBarMessage.showSnackBar(
                      message: "Settings...", context: context);
                },
              ),*/
            ],
          ),
          // drawer:
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
                    child: *//*Text(
                      'interested!',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    )*//*Container(),
                  ),*/
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BlocBuilder<ArticleInteractionBloc, ArticleInteractionState>(
                              builder: (context, state) {
                                logger.log("HomePage: build: BlocBuilder",
                                    "current state: ${state.runtimeType}");

                                return Column(children: [
                                  ListTile(
                                    leading: Icon(_selectedTileIndex == 0 ?
                                    Icons.home : Icons.home_outlined),
                                    // tileColor: AppTheme.tertiaryColor,
                                    // selectedTileColor: ,
                                    // selectedColor: ,
                                    selected: _selectedTileIndex == 0,
                                    title: const Text('Home'),
                                    onTap: () {
                                      setState(() {
                                        _selectedTileIndex = 0;
                                      });
                                      logger.log("HomePage: build: BlocBuilder",
                                      "tap on Home called getArticlesEvent:");
                                      context
                                          .read<ArticleInteractionBloc>()
                                          .add(GetArticlesEvent(params: ArticleInteractionParams(
                                        lastDoc: _lastDoc, articleId: '',
                                      )));
                                    },
                                  ),
                                ]);
                              }),
                        ],
                      ),

                      BlocConsumer<AuthenticationBloc, AuthenticationState>(
                        builder: (_, state) {
                          logger.log("HomePage: build: consumer",
                              "current state: ${state.runtimeType}");

                          return Column(
                            children: [
                              const Divider(),
                              ListTile(
                                title: const Text('Sign Out'),
                                onTap: () {
                                  context.read<AuthenticationBloc>().add(SignOutEvent());
                                },
                              ),
                            ],
                          );
                        },
                        listener: (_, state) async {
                          logger.log("HomePage: LISTENER",
                              "current state: ${state.runtimeType}");

                          if (state is SignedOutState) {

                            if(sl.isRegistered<Anonymous>(instanceName: "currentUser")) {
                              sl.unregister<Anonymous>(instanceName: "currentUser");
                            }
                            if(sl.isRegistered<User>(instanceName: "currentUser")) {
                              sl.unregister<User>(instanceName: "currentUser");
                            }
                            await SharedPrefHelper.clearPersonLocally();
                            if(!context.mounted) return;
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
                                if(!sl.isRegistered(instanceName: "currentUser")){
                                  await SharedPrefHelper.reloadCurrentUser();
                                }
                                if(!sl.isRegistered(instanceName: "currentUser")) {
                                  FirebaseAuth.instance.signOut();
                                  if(!context.mounted) return;
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      "/onboardingPage", (Route<dynamic> route) => false);
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
                child: BlocBuilder<ArticleInteractionBloc, ArticleInteractionState>(
                  builder: (context, state) {
                    logger.log("HomePage: build: BlocBuilder 2",
                        "current state: ${state.runtimeType}");
                    String? emptyListMessage;
                    // emptyListMessage = "Start searching to get personalized articles!";

                    if (state is LoadingState && _articles.isEmpty) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is ArticlesFetchedState) {
                      logger.log("HomePage: build: BlocBuilder 2",
                          "_lastDoc: ${state.response.$2 != null ? "exists!" : "null"}");
                      // setState(() {
                        _articles.addAll(state.response.$1);
                        _lastDoc = state.response.$2;
                      // });
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
                              MaterialButton(
                        onPressed: () {
                          context
                              .read<ArticleInteractionBloc>()
                              .add(GetArticlesEvent(params:
                          ArticleInteractionParams(
                            lastDoc: _lastDoc, articleId: '',
                          )));
                        },
                        child: const Text("RETRY"),
                      )
                          ],
                        ),
                      );
                    }

                    if (_articles.isEmpty) {
                      // emptyListMessage = "Start searching to get personalized articles!";

                      return Center(
                        child: Text(emptyListMessage ?? "Loading..."),
                      );
                    }

                    logger.log("HomePage: build: BlocBuilder 2",
                        "total articles: ${_articles.length}");

                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Flexible(
                            child: GridView.builder(
                              controller: _scrollController,
                              padding: EdgeInsets.all(10),
                              itemCount: _articles.length,
                              itemBuilder: (context, index) {
                                return ArticleWidget(
                                    homePageState: state, article: _articles[index]);
                              },
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                // mainAxisExtent: 200,
                              ),
                            ),
                          ),
                          if (state is LoadingState)
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ],
                            ),

                        ],
                      ),
                    );
                  },
                   buildWhen: (previous, current) {
              return current is ArticlesFetchedState ||
                  current is LoadingState ||
                  current is FailureState;
            },
                ),
              ),
            ],
          ),
        ));
  }

}
