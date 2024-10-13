import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interested/core/failures/failures.dart';
import 'package:interested/core/utils/constants.dart';
import 'package:interested/features/onboarding/domain/usecases/get_onboarding_data_usecase.dart';
import 'package:interested/features/onboarding/presentation/blocs/onboarding_event.dart';
import 'package:interested/features/onboarding/presentation/blocs/onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {

  final GetOnboardingDataUseCase getOnboardingDataUseCase;

  OnboardingBloc({required this.getOnboardingDataUseCase})
      : super(InitialState()) {
    on<ShowOnboardingDataEvent>((event, emit) async {
      emit(LoadingState());

      final failureOrOnboardingData = await getOnboardingDataUseCase.call(unit);

      failureOrOnboardingData.fold((failure) {
        emit(FailureState(message: _mapFailureToMessage(failure)));
      }, (onboardingData) {
        emit(GetOnboardingDataState(onboardingModel: onboardingData));
      });
    });
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case OfflineFailure:
        return Constant.OFFLINE_FAILURE_MESSAGE;
      case ServerFailure:
        return Constant.SERVER_FAILURE_MESSAGE;
      case OnboardingDataNotFoundFailure:
        return Constant.DATA_NOT_FOUND_MESSAGE;
      default:
        return Constant.DATA_NOT_FOUND_MESSAGE;
    }
  }

}
