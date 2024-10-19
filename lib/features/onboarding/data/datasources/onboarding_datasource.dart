
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/failures/exceptions.dart';
import '../../../../core/utils/debug_logger.dart';
import '../../domain/entities/onboarding_entity.dart';
import '../models/onboarding_model.dart';

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
        logger.log("OnboardingDataSource","Onboarding model data: $onboardingModel");
        await _mapOnboardingImages(onboardingModel);

      } else {
        logger.log("OnboardingDataSource","No onboarding document found on server.");
        throw DataNotFoundException();
      }

      return onboardingModel;
        // return OnboardingModel.fromFirestore(onboardingData, null);

    } on FirebaseException catch (e) {
      logger.log("OnboardingDataSource",e.toString());
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
      logger.log("OnboardingDataSource","Signed in with temporary account.");

      return userCredential;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          logger.log("OnboardingDataSource","Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          logger.log("OnboardingDataSource","Unknown error. $e");
      }
      throw Exception("Failed to Authenticate: $e");

    }
  }

  _mapOnboardingImages(OnboardingModel onboardingModel) async {

    final ref = FirebaseStorage.instance.ref().child("onboarding");
    final result = await ref.listAll();

    Uint8List? bytes = await ref.child("tagline.jpg").getData();
    // Sending bytes data to UI instead FlutterImage to not violate ClearArchitecture dependency rule
    // var bannerImage = Image.memory(bytes!, width: 400, height: 350,);
    onboardingModel.bannerImages.add(bytes!);

    var benefitsWithImages = await _mapBenefitWithImages(result.items, onboardingModel.benefits);
    // onboardingModel.benefitsWithImages = benefitsWithImages;
    onboardingModel.benefitsWithImages.addAll(benefitsWithImages);
  }

  Future<List<Benefit>> _mapBenefitWithImages(List<Reference> items,List<Map<String, dynamic>> benefits) async {

    List<Benefit> benefitsList = [];

    for (var item in items) {
      logger.log("OnboardingDataSource","OnboardingPage:itemsString: ${ item.toString()}");
      var bytes = await item.getData();

      // var supportingImage = Image.memory(bytes!, width: 200, height: 200,);
      for(var benefit in benefits) {
        if("${benefit["benefit"].toString().toLowerCase()}.jpg" == item.name) {
        // if(item.name.contains("other")) {
          logger.log("OnboardingDataSource","OnboardingPage:itemsName: ${ item.name} == ${benefit["benefit"]}.jpg");
          benefitsList.add(Benefit(benefit: benefit["benefit"], description: benefit["description"], supportingImage: bytes!));
          break;
        }
      }
    }

    return benefitsList;
  }

}