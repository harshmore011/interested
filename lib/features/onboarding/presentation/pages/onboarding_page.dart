
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interested/core/theme/app_theme.dart';
import 'package:interested/features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:interested/features/onboarding/presentation/blocs/onboarding_bloc.dart';
import 'package:interested/features/onboarding/presentation/blocs/onboarding_event.dart';
import 'package:interested/features/onboarding/presentation/blocs/onboarding_state.dart';

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

              var onboardingModel = state.onboardingModel;
             var size = MediaQuery.sizeOf(context);

              var cards = _getBenefitCards(onboardingModel.benefitsWithImages);


              return SingleChildScrollView(
                // physics: BouncingScrollPhysics(),
                // controller: ,
                child: Container(
                  color: AppTheme.colorPrimary,
                  // width: size.width,
                  // width: size.width*0.6,
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
                              width: size.width*0.6,
                              height: 400,
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
                                  // NetworkImage(
                                  // "https://firebasestorage.googleapis.com/v0/b/interested-project-011.appspot.com"
                                  //     "/o/onboarding%2Ftagline.jpg?alt=media&token=d270c47c-b75f-43b8-b9c3-931b05b09385"
                                    // , width: 300, height: 300,
                                  // ),
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
                            // gcloud storage buckets update gs://interested-project-011.appspot.com --cors-file=C:\Users\HARSH\Desktop\cors.jsoncors.json
                            // curl --request PATCH \
                            //  'https://storage.googleapis.com/storage/v1/b/gs://interested-project-011.appspot.com?fields=cors' \
                            //  --header 'Authorization: Bearer $(gcloud auth print-access-token)' \
                            //  --header 'Content-Type: application/json' \
                            //  --data-binary @C:\Users\HARSH\Desktop\cors.json
                            // TODO: Image Source here
                            // Image.network("https://firebasestorage.googleapis.com/v0/b/interested-project-011.appspot.com/o/onboarding%2Ftagline.jpg?alt=media&token=d270c47c-b75f-43b8-b9c3-931b05b09385"
                            //   , width: 300, height: 300,),
                          ],
                        ),
                      ),
                      Container(
                        // color: Colors.white,
                        padding: const EdgeInsets.only(top: 24,bottom: 24),
                        child: Row(mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                            cards,
                         /* [
                            ListView.builder(itemBuilder: (context, index) {
                            return cards[index];
                          }
                          , itemCount: onboardingModel.benefitsWithImages.length,
                          scrollDirection: Axis.horizontal,
                            // shrinkWrap: true,
                            // physics: const NeverScrollableScrollPhysics(),
                          ),
                          ]*/
                          // [
                            // _getBenefitCards(onboardingModel.benefits),
                            // cards,
                          // ],
                        ),
                      ),
                      SizedBox(
                        width: 100,),
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

  _getBenefitCards(List<Benefit> benefits) {

    List<Widget> benefitCards = [];

    // var benefitsList = await _mapBenefitWithImages(benefits);

    for(var benefit in benefits) {

      benefitCards.add(
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          color: Colors.white,
          elevation: 4,
          child: Container(
            width: 275,
            height: 400,
            // constraints: BoxConstraints(maxHeight: ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(benefit.benefit, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
                const SizedBox(height: 12,),
                benefit.supportingImage,
                const SizedBox(height: 12,),
                Text(benefit.description, softWrap: true,textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),),
                const SizedBox(height: 12,),
              ],
            ),
          ),
        )
      );
      benefitCards.add(const SizedBox(width: 40,));

    }
  return benefitCards;
  // return Container();
  }


}
