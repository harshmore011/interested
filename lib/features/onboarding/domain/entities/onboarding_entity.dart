
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class OnboardingEntity extends Equatable {

  // final String? logo;
  final String businessTagline;
  final String businessName;
  // final List<Benefit> benefits;
  final List<Map<String,dynamic>> benefits;
  // final String ctaMessage; // Call-to-Action Msg
  // final List<Feedback> feedbacks; // We can add later


  const OnboardingEntity({required this.businessTagline, required this.businessName, required this.benefits});


  @override
  List<Object?> get props => [businessName,businessTagline,benefits];

}

class Benefit extends Equatable {

  final String benefit;
  final String description;
  late final Image supportingImage;

   Benefit({required this.benefit, required this.description, /*required this.supportingImage*/});

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
