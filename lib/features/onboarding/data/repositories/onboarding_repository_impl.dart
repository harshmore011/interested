

import 'package:dartz/dartz.dart';
import 'package:interested/core/failures/exceptions.dart';

import 'package:interested/core/failures/failures.dart';
import 'package:interested/core/network/network_info.dart';
import 'package:interested/features/onboarding/data/datasources/onboarding_datasource.dart';
import 'package:interested/features/onboarding/data/models/onboarding_model.dart';

import 'package:interested/features/onboarding/domain/entities/onboarding_entity.dart';

import '../../../../core/di/dependency_injector.dart';
import '../../domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {

  final NetworkInfo networkInfo;
  final OnboardingDataSource onboardingDataSource;

  OnboardingRepositoryImpl({required this.networkInfo, required this.onboardingDataSource});

  @override
  Future<Either<Failure, OnboardingEntity>> getOnboardingData() async {

    if(await networkInfo.isConnected) {
      try {
        var onboardingData =  await onboardingDataSource.getOnboardingData();

        return Right(onboardingData);
      } on OnboardingDataNotFoundException {
        return Left(OnboardingDataNotFoundFailure());
      } on ServerException {
          return Left(ServerFailure());
        }
    } else {
      return Left(OfflineFailure());
    }

  }

}