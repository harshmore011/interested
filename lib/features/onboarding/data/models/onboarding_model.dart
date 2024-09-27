
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:interested/features/onboarding/domain/entities/onboarding_entity.dart';

class OnboardingModel extends OnboardingEntity {

  const OnboardingModel({required super.businessTagline, required super.businessName, required super.benefits});

  factory OnboardingModel.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();
    return OnboardingModel(
      businessTagline: data?['businessTagline'],
      businessName: data?['businessName'],
      benefits: List.from(data?['benefits']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "businessName": businessName,
      "businessTagline": businessTagline,
      "benefits": benefits,
    };
  }
  
}