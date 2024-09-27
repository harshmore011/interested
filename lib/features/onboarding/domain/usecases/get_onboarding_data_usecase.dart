
import 'package:dartz/dartz.dart';
import 'package:interested/core/failures/failures.dart';
import 'package:interested/core/usecase/usecase.dart';
import 'package:interested/features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:interested/features/onboarding/domain/repositories/onboarding_repository.dart';

class GetOnboardingDataUseCase extends Usecase<OnboardingEntity, Unit> {

  final OnboardingRepository repository;

  GetOnboardingDataUseCase(this.repository);

  @override
  Future<Either<Failure, OnboardingEntity>> call(Unit params)  async {

    return await repository.getOnboardingData();
  }

}