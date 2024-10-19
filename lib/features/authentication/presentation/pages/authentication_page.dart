

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interested/features/authentication/presentation/widgets/sign_in_card.dart';
import '../blocs/authentication_bloc.dart';
import '../blocs/authentication_event.dart';
import '../blocs/authentication_state.dart';
import '../widgets/sign_up_card.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({super.key});

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
}

class _AuthenticationPageState extends State<AuthenticationPage> {


  @override
  void initState() {
    super.initState();

    BlocProvider.of<AuthenticationBloc>(context).add(SignUpPageEvent());

  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: _getAppBar(defaultTargetPlatform),

          body: Center(
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(builder: (context, state) {

              if(state is SignUpPageState) {

                return const SignUpCard();

              } else if (state is SignInPageState) {

               // final device = MediaQuery.sizeOf(context);
               // final deviceWidth = device.width;
               // final deviceHeight = device.height;
               // width: deviceWidth < Constant.STANDARD_TABLET_WIDTH ? deviceWidth : deviceWidth*0.65,
                return SignInCard();
              }

              return Container();
            }
            ),
          ),
        )
    );
  }

 AppBar? _getAppBar(TargetPlatform defaultTargetPlatform) {
    if(defaultTargetPlatform == TargetPlatform.android) {
      return AppBar(
        backgroundColor: Colors.white,
        title: const Text("interested!", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic, fontSize: 18),),
      );
    } else {
      return null;
    }
  }

}
