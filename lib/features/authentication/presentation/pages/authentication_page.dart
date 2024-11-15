import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interested/core/utils/debug_logger.dart';
import 'package:interested/features/authentication/domain/entities/auth.dart';

import '../../../../core/theme/app_theme.dart';
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

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
      logger.log("AuthenticationPage", "Selected Index: $_selectedIndex");
    });

    BlocProvider.of<AuthenticationBloc>(context, listen: false)
        .add(SignUpPageEvent());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    _tabController.dispose();

  }
  @override
  void reassemble() {
    super.reassemble();


  }

  @override
  void deactivate() {
    super.deactivate();


  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

  }

  @override
  void didUpdateWidget(AuthenticationPage oldWidget) {
    super.didUpdateWidget(oldWidget);

    logger.log("AuthenticationPage", "didUpdateWidget");

    _tabController.addListener(() {
      setState(() {
        _selectedIndex = _tabController.index;
      });
    });

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: _getAppBar(defaultTargetPlatform),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Column(
              children: [
                TabBar(
                  controller: _tabController,
                  tabs: [
                    Tab(
                      text: "User",
                    ),
                    Tab(
                      text: "Publisher",
                    ),
                  ],
                ),
                BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                    logger.log("AuthenticationPage: build",
                        "current state: ${state.runtimeType}");

                    PersonRole role;

                    if (_selectedIndex == 0) {
                      // logger.log("AuthenticationPage: build", "USER SELECTED");
                      role = PersonRole.user;
                    } else {
                      // logger.log("AuthenticationPage: build", "PUBLISHER SELECTED");
                      role = PersonRole.publisher;
                    }

                    if (state is SignUpPageState) {
                      return SignUpCard(personRole: role);
                    } else if (state is SignInPageState) {
                      // final device = MediaQuery.sizeOf(context);
                      // final deviceWidth = device.width;
                      // final deviceHeight = device.height;
                      // width: deviceWidth < Constant.STANDARD_TABLET_WIDTH ? deviceWidth : deviceWidth*0.65,
                      return SignInCard(
                        personRole: role,
                      );
                    }

                    return Container();

                    return Container(
                      child: Center(
                        child: Text("Unexpected state: ${state.runtimeType}"),
                      ),
                    );
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
    ));
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

}
