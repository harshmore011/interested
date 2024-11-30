import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/dependency_injector.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/debug_logger.dart';
import '../../../../core/utils/shared_pref_helper.dart';
import '../../domain/entities/anonymous_entity.dart';
import '../../domain/entities/auth.dart';
import '../blocs/authentication_bloc.dart';
import '../blocs/authentication_event.dart';
import '../blocs/authentication_state.dart';
import '../widgets/sign_in_card.dart';
import '../widgets/sign_up_card.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  int _selectedIndex = 0;
  PersonRole? _personRole;

  @override
  void initState() {
    logger.log("AuthenticationPage", "initState");

    Future.delayed(Duration.zero, () async {
      if (await _isAlreadyLoggedInAsAnonymous()) {
        _personRole = PersonRole.anonymous;
      } else {
        if (_selectedIndex == 0) {
          // logger.log("AuthenticationPage: build", "USER SELECTED");

          _personRole = PersonRole.user;
        } else if (_selectedIndex == 1) {
          // logger.log("AuthenticationPage: build", "PUBLISHER SELECTED");
          _personRole = PersonRole.publisher;
        }
        setState(() {});
      }
    });

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
      logger.log("AuthenticationPage", "Selected Index: $_selectedIndex");
    });

    BlocProvider.of<AuthenticationBloc>(context, listen: false)
        .add(SignInPageEvent());

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    logger.log("AuthenticationPage", "dispose");
    _tabController.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    logger.log("AuthenticationPage", "deactivate");
    super.deactivate();
  }

  @override
  void didChangeDependencies() {
    logger.log("AuthenticationPage", "didChangeDependencies");
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(AuthenticationPage oldWidget) {
    logger.log("AuthenticationPage", "didUpdateWidget");

    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    logger.log("AuthenticationPage: build", "started");

    return SafeArea(
      child: Scaffold(
        appBar: _getAppBar(defaultTargetPlatform),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_personRole != null && _personRole != PersonRole.anonymous)
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                      child: TabBar(
                        controller: _tabController,
                        tabs: [
                          const Tab(
                            text: "User",
                          ),
                          const Tab(
                            text: "Publisher",
                          ),
                        ],
                      ),
                    ),
                  BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) {
                      logger.log("AuthenticationPage: build",
                          "current state: ${state.runtimeType}");

                      if (_personRole != null &&
                          _personRole == PersonRole.anonymous) {
                        if (state is SignUpPageState) {
                          return SignUpCard(personRole: PersonRole.anonymous);
                        } else if (state is SignInPageState) {
                          return SignInCard(personRole: PersonRole.user);
                        }
                      }
                      // PersonRole _personRole;

                      if (_selectedIndex == 0) {
                        // logger.log("AuthenticationPage: build", "USER SELECTED");

                        _personRole = PersonRole.user;
                      } else if (_selectedIndex == 1) {
                        // logger.log("AuthenticationPage: build", "PUBLISHER SELECTED");
                        _personRole = PersonRole.publisher;
                      }

                      if (state is SignUpPageState) {
                        return SignUpCard(personRole: _personRole!);
                      } else if (state is SignInPageState) {
                        // final device = MediaQuery.sizeOf(context);
                        // final deviceWidth = device.width;
                        // final deviceHeight = device.height;
                        // width: deviceWidth < Constant.STANDARD_TABLET_WIDTH ? deviceWidth : deviceWidth*0.65,
                        return SignInCard(
                          personRole: _personRole!,
                        );
                      }

                      return Container();
                    },
                    buildWhen: (previous, current) {
                      return current is SignUpPageState ||
                          current is SignInPageState;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar? _getAppBar(TargetPlatform defaultTargetPlatform) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AppBar(
        // backgroundColor: Colors.white,
        backgroundColor: AppTheme.colorPrimary,
        title: const Text(
          "interested!",
          style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 18),
        ),
      );
    } else {
      return null;
    }
  }

  Future<bool> _isAlreadyLoggedInAsAnonymous() async {
    if (!sl.isRegistered<Anonymous>(instanceName: "currentUser")) {
      await SharedPrefHelper.reloadCurrentUser();
    }

    if (sl.isRegistered<Anonymous>(instanceName: "currentUser")) {
      logger.log("AuthenticationPage", "Already logged in as anonymous");
      return true;
    }

    return false;
  }
}
