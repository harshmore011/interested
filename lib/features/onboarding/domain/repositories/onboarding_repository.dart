
import 'package:dartz/dartz.dart';
import 'package:interested/core/failures/failures.dart';
import 'package:interested/features/onboarding/domain/entities/onboarding_entity.dart';

abstract class OnboardingRepository {

  Future<Either<Failure, OnboardingEntity>> getOnboardingData();

}
