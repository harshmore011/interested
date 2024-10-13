
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:interested/features/onboarding/domain/entities/onboarding_entity.dart';

class OnboardingModel extends OnboardingEntity {

  const OnboardingModel({required super.businessTagline, required super.businessName,
    required super.bannerImages,required super.benefits, required super.benefitsWithImages});

  factory OnboardingModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    debugPrint("Onboarding model data: $data");
    return OnboardingModel(
      businessTagline: data?['businessTagline'],
      businessName: data?['businessName'],
      benefits: List.from(data?['benefits']), benefitsWithImages: [],
      bannerImages: [],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "businessName": businessName,
      "businessTagline": businessTagline,
      "benefits": benefits,
      "benefitsWithImages": benefitsWithImages,
      "bannerImages": bannerImages
    };
  }
  
}