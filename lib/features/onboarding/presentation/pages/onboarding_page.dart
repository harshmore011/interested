

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interested/core/theme/app_theme.dart';
import 'package:interested/core/utils/constants.dart';
import 'package:interested/core/utils/snackbar_message.dart';
import 'package:interested/features/onboarding/presentation/blocs/onboarding_bloc.dart';
import 'package:interested/features/onboarding/presentation/blocs/onboarding_event.dart';
import 'package:interested/features/onboarding/presentation/blocs/onboarding_state.dart';

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
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: const Text("interested!", style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic, fontSize: 18),),
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
                child: Container(
                  color: AppTheme.colorPrimary,
                  // width: deviceWidth,
                  width: deviceWidth < Constant.STANDARD_TABLET_WIDTH ? deviceWidth : deviceWidth*0.65,
                  // height: size.height,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        // padding: const EdgeInsets.all(16),
                        padding: const EdgeInsets.only(top: 16, bottom: 16, right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: deviceWidth < Constant.STANDARD_TABLET_WIDTH ? deviceWidth*0.8 :deviceWidth*0.5,
                              height: deviceWidth < Constant.STANDARD_TABLET_WIDTH ? 200 : 300,
                              // alignment: ,
                              padding: EdgeInsets.only(left: 50,top: 40),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                // color: AppTheme.colorPrimary,
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
                                  // colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.25), BlendMode.dstATop),
                                  alignment: Alignment.centerRight,
                                  opacity: 0.8,
                                  image: onboardingModel.bannerImages.first.image,
                                 /* NetworkImage(
                                  "https://firebasestorage.googleapis.com/v0/b/interested-project-011.appspot.com"
                                      "/o/onboarding%2Ftagline.jpg?alt=media&token=d270c47c-b75f-43b8-b9c3-931b05b09385"
                                    , width: 300, height: 300,
                                  ),*/
                                  fit: BoxFit.scaleDown,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(onboardingModel.businessName,
                                    style: const TextStyle(
                                      // color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      fontStyle: FontStyle.italic, fontSize: 24),),
                                  const SizedBox(
                                    height: 24,
                                  ),
                                  ConstrainedBox(
                                    constraints: const BoxConstraints(maxWidth: 260),
                                    child: Text('"${onboardingModel.businessTagline}"',
                                         softWrap: true,
                                         style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,
                                             fontSize: 26),),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        // color: Colors.white,
                        padding: const EdgeInsets.only(top: 24,bottom: 24),
                        child: BenefitCardsList(benefits: onboardingModel.benefitsWithImages),
                      ),
                      if(defaultTargetPlatform==TargetPlatform.android)...[
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
                      ),]
                    ],
                  ),
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
