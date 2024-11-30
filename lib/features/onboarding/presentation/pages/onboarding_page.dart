

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/constants.dart';
import '../../../authentication/presentation/pages/authentication_page.dart';
import '../blocs/onboarding_bloc.dart';
import '../blocs/onboarding_event.dart';
import '../blocs/onboarding_state.dart';
import '../widgets/benefit_cards_list.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {


  @override
  void initState() {

    // Dispatching the Event
    BlocProvider.of<OnboardingBloc>(context).add(ShowOnboardingDataEvent());

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(automaticallyImplyLeading: false,
            // backgroundColor: Colors.white,
            title: const Text("interested!", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic, fontSize: 18),),
            actions: [

              IconButton(
                icon: const Icon(Icons.color_lens_sharp),
                onPressed: () {
                  Navigator.of(context).pushNamed("/appColors");
                },
              ),
            ],
          ),
          body: BlocBuilder<OnboardingBloc, OnboardingState>(builder: (context, state) {
            
            if(state is LoadingState) {
              
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GetOnboardingDataState) {

              final onboardingModel = state.onboardingModel;
             final device = MediaQuery.sizeOf(context);
             final deviceWidth = device.width;
             final deviceHeight = device.height;

              return SingleChildScrollView(
                // physics: BouncingScrollPhysics(),
                // controller: ,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      // color: AppTheme.colorPrimary.withOpacity(0.75),
                      color: Colors.white,
                      // width: deviceWidth,
                      width: deviceWidth < Constant.STANDARD_TABLET_WIDTH ? deviceWidth : deviceWidth*0.62,
                      // height: size.height,
                      padding: const EdgeInsets.only(left: 24,top: 24,bottom: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            // padding: const EdgeInsets.all(16),
                            padding: const EdgeInsets.only(top: 16, bottom: 16, left: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: deviceWidth < Constant.STANDARD_TABLET_WIDTH ? deviceWidth*0.7 :deviceWidth*0.58,
                                  height: deviceWidth < Constant.STANDARD_TABLET_WIDTH ? 200 : 400,
                                  // alignment: ,
                                  padding: EdgeInsets.only(right: 20,top: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    // color: ,
                                    borderRadius: BorderRadius.only(topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                                    // borderRadius: BorderRadius.circular(12),
                                    // gradient: LinearGradient(colors: [Colors.white]),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(0, 2),
                                        blurRadius: 6.0,
                                      ),
                                    ],
                                    image: DecorationImage(
                                      // scale: 0.5,
                                      fit: BoxFit.scaleDown,
                                      // colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.25), BlendMode.dstATop),
                                      alignment: Alignment.centerLeft,
                                      opacity: 0.7,
                                      image: MemoryImage(onboardingModel.bannerImages.first,),
                                     /* NetworkImage(
                                      "https://firebasestorage.googleapis.com/v0/b/interested-project-011.appspot.com"
                                          "/o/onboarding%2Ftagline.jpg?alt=media&token=d270c47c-b75f-43b8-b9c3-931b05b09385"
                                        , width: 300, height: 300,
                                      ),*//*
                                      fit: BoxFit.scaleDown,
                                    ),*/
                                  ),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Center(
                                        child: Text("${onboardingModel.businessName}!",
                                          style: const TextStyle(
                                            // color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            fontStyle: FontStyle.italic, fontSize: 26),),
                                      ),
                                      const SizedBox(
                                        height: 72,
                                      ),
                                      ConstrainedBox(
                                        constraints: const BoxConstraints(maxWidth: 350),
                                        child: Text('"${onboardingModel.businessTagline}"',
                                             softWrap: true,
                                             style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,
                                                 fontSize: 36),),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Flexible(
                            child: Container(
                              height: 440,
                              // color: Colors.white,
                              padding: const EdgeInsets.only(top: 24,bottom: 24),
                              child: BenefitCardsList(benefits: onboardingModel.benefitsWithImages),
                            ),
                          ),
                          const SizedBox(height: 75,),
                          /*if(defaultTargetPlatform==TargetPlatform.android)...[
                            MaterialButton(
                              color: Colors.white,
                              onPressed: (){
                             SnackBarMessage.showSnackBar(
                               message: "Coming Soon", context: context
                             ) ;
                            }
                            , child: const Text("Get Started!"),)
                          ] else...[ SizedBox(
                            width: 100,
                          ),],*/
                        ],
                      ),
                    ),
                    Container(
                      width: deviceWidth < Constant.STANDARD_TABLET_WIDTH ? deviceWidth : deviceWidth*0.35,
                      height: deviceHeight,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: AuthenticationPage(),
                      ),
                    )
                  ],
                ),
              );
              
            } else if (state is FailureState) {
              
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message),
                   const SizedBox(height: 4,),
                    MaterialButton(onPressed: (){
                      BlocProvider.of<OnboardingBloc>(context).add(ShowOnboardingDataEvent());
                    },
                    child: const Text("RETRY"),
                    )
                  ],
                ),
              );
              
            }

            return Container();
          }
          ),
        )
    );
  }

}
