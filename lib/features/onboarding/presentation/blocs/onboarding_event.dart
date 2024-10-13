
import 'package:equatable/equatable.dart';

abstract class OnboardingEvent extends Equatable {
  @override
  List<Object> get props {
    return [];
  }
}

class ShowOnboardingDataEvent extends OnboardingEvent{}

