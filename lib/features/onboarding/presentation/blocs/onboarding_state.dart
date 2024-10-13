
import 'package:equatable/equatable.dart';
import 'package:interested/features/onboarding/data/models/onboarding_model.dart';
import 'package:interested/features/onboarding/domain/entities/onboarding_entity.dart';

abstract class OnboardingState extends Equatable {
  @override
  List<Object> get props {
    return [];
  }
}

class InitialState extends OnboardingState{}

class LoadingState extends OnboardingState{}

class GetOnboardingDataState extends OnboardingState {

// final OnboardingModel onboardingModel;
final OnboardingEntity onboardingModel;

  GetOnboardingDataState({required this.onboardingModel});

}

class FailureState extends OnboardingState{
  final String message;

  FailureState({required this.message});

  @override
  List<Object> get props {
    return [message];
  }
}

// class OnboardingCompletedState extends OnboardingState{}

