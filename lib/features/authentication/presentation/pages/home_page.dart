
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/dependency_injector.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/debug_logger.dart';
import '../../../../core/utils/shared_pref_helper.dart';
import '../../domain/entities/auth.dart';
import '../../domain/entities/user_entity.dart';
import '../blocs/authentication_bloc.dart';
import '../blocs/authentication_event.dart';
import '../blocs/authentication_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    logger.log("HomePage:build()", "started");
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(builder: (_,state){
      logger.log("HomePage: build: consumer","current state: ${state.runtimeType}");

     return Scaffold(
          appBar: AppBar(title: const Text("Home Page"),
            actions: [
              TextButton(onPressed: (){
                context.read<AuthenticationBloc>().add(SignOutEvent());
              }, child: Text("Sign out", style: TextStyle(color: Colors.white),),),
            ],),
          body: _getBody(context, state),

        );
      }, listener: (_,state){
      logger.log("home_page: LISTENER","current state: ${state.runtimeType}");

        if(state is SignedOutState) {
          // SharedPrefHelper.removePersonLocallyByKey("key");
          sl.unregister(instance: sl<User>());
          SharedPrefHelper.clearPersonLocally();
          Navigator.of(_).pushNamedAndRemoveUntil("/onboardingPage",
                  (Route<dynamic> route) => false);
        } else if (state is PublisherSignedInState) {
          // sl.unregister(instance: sl<User>());
          SharedPrefHelper.removePersonLocallyByKey("userModel");
          // SharedPrefHelper.clearPersonLocally();
          // SharedPrefHelper.clearPersonLocally();
          Navigator.of(_).pushNamedAndRemoveUntil("/publisherHomePage",
                  (Route<dynamic> route) => false);
        }
      },listenWhen: (previous, current) {
      /*return current is !SignInPageState ||
                  current is !SignUpPageState ||
                  current is !SignedOutState;*/
      return current is SignedOutState || current is PublisherSignedInState;
          // || current is FailureState;
    },
    );

  }

  _getBody(BuildContext context, Object? state) {
    if(state is LoadingState) {
      logger.log("HomePage:_getBody()", "LoadingState");
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      logger.log("HomePage:_getBody()", "else");
      return
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Welcome!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
              MaterialButton(
                color: AppTheme.colorPrimary,
                  child: Text("Switch to Publisher", style: TextStyle(color: Colors.white),),
                  onPressed: (){

                context.read<AuthenticationBloc>().add(PublisherSignInEvent(params: AuthParams(authProvider: AuthenticationProvider.google)));
              })
            ],
          ),
        );
    }
  }
}
