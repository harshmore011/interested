
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:interested/core/failures/exceptions.dart';
import 'package:interested/features/onboarding/data/models/onboarding_model.dart';
import 'package:interested/features/onboarding/domain/entities/onboarding_entity.dart';

abstract class OnboardingDataSource {

  Future<OnboardingModel> getOnboardingData();

  void setOnboardingData();

}

class OnboardingDataSourceImpl implements OnboardingDataSource {

  @override
  Future<OnboardingModel> getOnboardingData() async {

    // supportingImage: Image.network("https://firebasestorage.googleapis.com/v0/b/interested-project-011.appspot.com/o/onboarding%2Fexplore.svg?alt=media&token=6ccddbd7-b8b9-4b5a-8efd-6aa3b15d6be0")

    try {

      var db = FirebaseFirestore.instance;

      var ref = await db.collection("onboarding_data")
      .doc("getOnboardingData")
      .withConverter(fromFirestore: OnboardingModel.fromFirestore,
          toFirestore: (OnboardingModel onboardingModel, _) => onboardingModel.toFirestore());

      final docSnap = await ref.get();
      final city = docSnap.data(); // Convert to object
      if (city != null) {
        print(city);
      } else {
        print("No such document.");
      }

      return city!;
        // return OnboardingModel.fromFirestore(onboardingData, null);

    } catch (e) {
      throw ServerException();
      // throw Exception("Failed to get onboarding data: $e");
    }
  }

  @override
  void setOnboardingData() {
    // TODO: implement setOnboardingData

   var db = FirebaseFirestore.instance;

   db.collection("onboarding_data")
    .doc("getOnboardingData")
    .set(OnboardingModel(businessTagline: 'Delve into the world of your interests',
       businessName: 'interested!',
      /* benefits: [
         Benefit(benefit: "Find",
           description: "Explore the vastness of what truly matters to your heart!"
         ),

         Benefit(benefit: "Delve",
             description: "Immerse into the depth and profoundness of the knowledge!"
             ),

         Benefit(benefit: "Share",
             description: "Interested in sharing your knowledge/experience? Share it with interested!"
             ),*/
        benefits: []).toFirestore())
    .then((value) => print("Onboarding data added"))
    .catchError((error) => print("Failed to add onboarding data: $error"));

  }


}