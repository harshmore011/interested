
import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class OnboardingEntity extends Equatable {

  // final String? logo;
  final String businessTagline;
  final String businessName;
  final List<Uint8List> bannerImages;
  // final List<Image> bannerImages;
  final List<Benefit> benefitsWithImages;
  final List<Map<String,dynamic>> benefits;
  // final String ctaMessage; // Call-to-Action Msg
  // final List<Feedback> feedbacks; // We can add later


  const OnboardingEntity({required this.businessTagline, required this.businessName,
    required this.bannerImages, required this.benefits, required this.benefitsWithImages});


  @override
  List<Object?> get props => [businessName,businessTagline,bannerImages,benefits,benefitsWithImages];

}



// Going with Map object so of no use as of now.

class Benefit extends Equatable {

  final String benefit;
  final String description;
  // /*late*/ final Image supportingImage;
  /*late*/ final Uint8List supportingImage;


   const Benefit({required this.benefit, required this.description, required this.supportingImage});

  @override
  List<Object?> get props => [benefit,description,supportingImage];

}

class Feedback extends Equatable {

  final String feedback;
  final String personName;

  const Feedback({required this.feedback, required this.personName});

  @override
  List<Object?> get props => [feedback, personName];

}
