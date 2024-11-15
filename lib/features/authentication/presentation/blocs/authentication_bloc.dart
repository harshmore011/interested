import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/failures/failures.dart';
import '../../../../core/utils/constants.dart';
import '../../../../core/utils/debug_logger.dart';
import '../../domain/entities/anonymous_entity.dart';
import '../../domain/entities/publisher_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/anonymous_sign_in_usecase.dart';
import '../../domain/usecases/anonymous_to_user_usecase.dart';
import '../../domain/usecases/publisher_sign_in_usecase.dart';
import '../../domain/usecases/publisher_sign_up_usecase.dart';
import '../../domain/usecases/sign_out_Usecasse.dart';
import '../../domain/usecases/user_sign_in_usecase.dart';
import '../../domain/usecases/user_sign_up_usecase.dart';
import '../../domain/usecases/verify_email_usecase.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AnonymousSignInUseCase anonymousSignInUseCase;
  final AnonymousToUserUseCase anonymousToUserUseCase;
  final UserSignInUseCase userSignInUseCase;
  final PublisherSignInUseCase publisherSignInUseCase;
  final UserSignUpUseCase userSignUpUseCase;
  final PublisherSignUpUseCase publisherSignUpUseCase;
  final VerifyEmailUseCase verifyEmailUseCase;
  final SignOutUseCase signOutUseCase;

  AuthenticationBloc({
    required this.anonymousSignInUseCase,
    required this.anonymousToUserUseCase,
    required this.userSignInUseCase,
    required this.publisherSignInUseCase,
    required this.userSignUpUseCase,
    required this.publisherSignUpUseCase,
    required this.verifyEmailUseCase,
    required this.signOutUseCase,
  }) : super(InitialState()) {
    on<AuthenticationEvent>((event, emit) async {
      if (event is SignUpPageEvent) {
        emit(SignUpPageState());
      } else if (event is SignInPageEvent) {
        emit(SignInPageState());
      } else if (event is AnonymousSignInEvent) {
        emit(LoadingState());

        final Either<Failure, Anonymous> result =
            await anonymousSignInUseCase.call(unit);

        result.fold(
          (failure) =>
              emit(FailureState(message: _mapFailureToMessage(failure))),
          (anonymous) => emit(AnonymousSignedInState()),
        );
      } else if (event is AnonymousToUserEvent) {
        emit(LoadingState());

        final Either<Failure, User> result =
            await anonymousToUserUseCase.call(event.params);

        result.fold(
          (failure) =>
              emit(FailureState(message: _mapFailureToMessage(failure))),
          (user) => emit(AnonymousLinkedToUserState()),
        );
      } else if (event is UserSignUpEvent) {
        emit(LoadingState());

        final Either<Failure, User> result =
            await userSignUpUseCase.call(event.params);

        result.fold(
          (failure) =>
              emit(FailureState(message: _mapFailureToMessage(failure))),
          (user) => emit(UserSignedUpState()),
        );
      } else if (event is PublisherSignUpEvent) {
        emit(LoadingState());

        final Either<Failure, Publisher> result =
            await publisherSignUpUseCase.call(event.params);

        result.fold(
          (failure) =>
              emit(FailureState(message: _mapFailureToMessage(failure))),
          (publisher) => emit(PublisherSignedUpState()),
        );
      } else if (event is UserSignInEvent) {
        emit(LoadingState());

        final Either<Failure, User> result =
            await userSignInUseCase.call(event.params);

        result.fold(
          (failure) =>
              emit(FailureState(message: _mapFailureToMessage(failure))),
          (user) => emit(UserSignedInState()),
        );
      } else if (event is PublisherSignInEvent) {
        emit(LoadingState());

        final Either<Failure, Publisher> result =
            await publisherSignInUseCase.call(event.params);

        result.fold(
          (failure) =>
              emit(FailureState(message: _mapFailureToMessage(failure))),
          (publisher) => emit(PublisherSignedInState()),
        );
      } else if (event is VerifyEmailEvent) {
        emit(LoadingState());

        final Either<Failure, Unit> result =
            await verifyEmailUseCase.call(unit);

        result.fold(
          (failure) =>
              emit(FailureState(message: _mapFailureToMessage(failure))),
          (_) => emit(VerificationEmailSentState()),
        );
      } else if (event is SignOutEvent) {
        emit(LoadingState());

        final Either<Failure, Unit> result = await signOutUseCase.call(unit);

        result.fold(
          (failure) =>
              emit(FailureState(message: _mapFailureToMessage(failure))),
          (_) => emit(SignedOutState()),
        );
      }
    });
  }

/*  AuthenticationState eitherToState ( Either either , AuthenticationState state){
    return either.fold(
          (failure) => FailureState(message: _mapFailureToMessage(failure)),
          (_) => state,
    );
  }*/

  String _mapFailureToMessage(Failure failure) {
    logger.log("AuthenticationBloc:_mapFailureToMessage()", "failureType: ${failure.runtimeType}");
    switch (failure.runtimeType) {
      case OfflineFailure:
        return Constant.OFFLINE_FAILURE_MESSAGE;
        case ServerFailure:
        return Constant.SERVER_FAILURE_MESSAGE;
      case DataNotFoundFailure:
        return Constant.DATA_NOT_FOUND_MESSAGE;
      case NoUserFailure:
        return Constant.NO_USER_FAILURE_MESSAGE;
      case TooManyRequestsFailure:
        return Constant.TOO_MANY_REQUESTS_FAILURE_MESSAGE;
      case EmailAlreadyInUseFailure:
        logger.log("AuthenticationBloc:_mapFailureToMessage()", "INSIDE EmailAlreadyInUseFailure");
        return Constant.EMAIL_ALREADY_IN_USE_FAILURE_MESSAGE;
      case InvalidEmailFailure:
        return Constant.INVALID_EMAIL_FAILURE_MESSAGE;
      case WeakPasswordFailure:
        return Constant.WEAK_PASSWORD_FAILURE_MESSAGE;
      case WrongPasswordFailure:
        return Constant.WRONG_PASSWORD_FAILURE_MESSAGE;
      case InvalidCredentialsFailure:
        return Constant.INVALID_CREDENTIALS_FAILURE_MESSAGE;
        default:
          return "Unexpected Error , Please try again later .";
    }
  }
}
