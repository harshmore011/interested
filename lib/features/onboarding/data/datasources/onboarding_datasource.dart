
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:interested/core/failures/exceptions.dart';
import 'package:interested/features/onboarding/data/models/onboarding_model.dart';
import 'package:interested/features/onboarding/domain/entities/onboarding_entity.dart';

abstract class OnboardingDataSource {

  Future<OnboardingModel> getOnboardingData();

  // Had entered data manually into the database, so not needed now
  // void setOnboardingData();

  // Now not needed here as we have allowed everyone to read/access the onboarding data
  Future<UserCredential> signInAnonymously();

}

class OnboardingDataSourceImpl implements OnboardingDataSource {

  @override
  Future<OnboardingModel> getOnboardingData() async {

    // supportingImage: Image.network("https://firebasestorage.googleapis.com/v0/b/interested-project-011.appspot.com/o/onboarding%2Fexplore.svg?alt=media&token=6ccddbd7-b8b9-4b5a-8efd-6aa3b15d6be0")

    try {

      var db = FirebaseFirestore.instance;

      var ref = db.collection("onboarding_data")
      .doc("getOnboardingData")
      .withConverter(fromFirestore: OnboardingModel.fromFirestore,
          toFirestore: (OnboardingModel onboardingModel, _) => onboardingModel.toFirestore());

      final docSnap = await ref.get();
      final onboardingModel = docSnap.data(); // Convert to object
      if (onboardingModel != null) {
        debugPrint("Onboarding model data: $onboardingModel");
        await _mapOnboardingImages(onboardingModel);

      } else {
        debugPrint("No onboarding document found on server.");
        throw OnboardingDataNotFoundException();
      }

      return onboardingModel;
        // return OnboardingModel.fromFirestore(onboardingData, null);

    } on FirebaseException catch (e) {
      debugPrint(e.toString());
      // throw ServerException();
      // throw Exception("Failed to get onboarding data: $e");
      throw ServerException();
    }

  }

  // Now not needed here as we have allowed everyone to read/access the onboarding data
  @override
  Future<UserCredential> signInAnonymously() async {

    try {
      final userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      print("Signed in with temporary account.");

      return userCredential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error. $e");
      }
      throw Exception("Failed to Authenticate: $e");

    }
  }

  _mapOnboardingImages(OnboardingModel onboardingModel) async {

    final ref = FirebaseStorage.instance.ref().child("onboarding");
    final result = await ref.listAll();

    var bytes = await ref.child("tagline.jpg").getData();
    var bannerImage = Image.memory(bytes!, width: 400, height: 350,);
    onboardingModel.bannerImages.add(bannerImage);

    var benefitsWithImages = await _mapBenefitWithImages(result.items, onboardingModel.benefits);
    // onboardingModel.benefitsWithImages = benefitsWithImages;
    onboardingModel.benefitsWithImages.addAll(benefitsWithImages);
  }

  Future<List<Benefit>> _mapBenefitWithImages(List<Reference> items,List<Map<String, dynamic>> benefits) async {

    List<Benefit> benefitsList = [];

    for (var item in items) {
      debugPrint("OnboardingPage:itemsString: ${ item.toString()}");
      var bytes = await item.getData();

      var supportingImage = Image.memory(bytes!, width: 200, height: 200,);
      for(var benefit in benefits) {
        if("${benefit["benefit"].toString().toLowerCase()}.jpg" == item.name) {
        // if(item.name.contains("other")) {
          debugPrint("OnboardingPage:itemsName: ${ item.name} == ${benefit["benefit"]}.jpg");
          benefitsList.add(Benefit(benefit: benefit["benefit"], description: benefit["description"], supportingImage: supportingImage));
          break;
        }
      }
    }

    return benefitsList;
  }

}