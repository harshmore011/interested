import 'package:dartz/dartz.dart';

import '../../../../core/di/dependency_injector.dart';
import '../../../../core/failures/exceptions.dart';
import '../../../../core/failures/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/utils/debug_logger.dart';
import '../../domain/entities/anonymous_entity.dart';
import '../../domain/entities/auth.dart';
import '../../domain/entities/publisher_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/authentication_repository.dart';
import '../datasources/authentication_datasource.dart';

class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final NetworkInfo networkInfo;
  final AuthenticationDataSource authenticationDataSource;

  AuthenticationRepositoryImpl(
      {required this.networkInfo, required this.authenticationDataSource});

  @override
  Future<Either<Failure, Anonymous>> anonymousSignIn() async {
    logger.log("AuthenticationRepositoryImpl:anonymousSignIn()", "Started");
    if (await networkInfo.isConnected) {
      try {
        var anonymous = await authenticationDataSource.anonymousSignIn();
        sl.registerSingleton<Anonymous>(anonymous);

        return Right(anonymous);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      logger.log(
          "AuthenticationRepositoryImpl:anonymousSignIn()", "Offline_Error");
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, User>> anonymousToUser(AuthParams params) async {
    logger.log("AuthenticationRepositoryImpl:anonymousToUser()", "Started");
    if (await networkInfo.isConnected) {
      try {
        var user = await authenticationDataSource.anonymousToUser(params);
        sl.registerSingleton<User>(user);

        return Right(user);
      } on ServerException {
        return Left(ServerFailure());
      } on NoUserException {
        return Left(NoUserFailure());
      } on EmailAlreadyInUseException {
        return Left(EmailAlreadyInUseFailure());
      } on InvalidEmailException {
        return Left(InvalidEmailFailure());
      }
    } else {
      logger.log(
          "AuthenticationRepositoryImpl:anonymousToUser()", "Offline_Error");
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, User>> userSignIn(AuthParams params) async {
    logger.log("AuthenticationRepositoryImpl:userSignIn()", "Started");
    if (await networkInfo.isConnected) {
      try {
        var user = await authenticationDataSource.userSignIn(params);
        sl.registerSingleton<User>(user);

        return Right(user);
      } on ServerException {
        return Left(ServerFailure());
      } on NoUserException {
        return Left(NoUserFailure());
      } on EmailAlreadyInUseException {
        return Left(EmailAlreadyInUseFailure());
      } on InvalidEmailException {
        return Left(InvalidEmailFailure());
      } on WeakPasswordException {
        return Left(WeakPasswordFailure());
      } on TooManyRequestsException {
        return Left(TooManyRequestsFailure());
      } on WrongPasswordException {
        return Left(WrongPasswordFailure());
      } on InvalidCredentialException {
        return Left(InvalidCredentialsFailure());
      }
    } else {
      logger.log("AuthenticationRepositoryImpl:userSignIn()", "Offline_Error");
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, User>> userSignUp(AuthParams params) async {
    logger.log("AuthenticationRepositoryImpl:userSignUp()", "Started");
    if (await networkInfo.isConnected) {
      try {
        var user = await authenticationDataSource.userSignUp(params);
        sl.registerSingleton<User>(user);

        return Right(user);
      } on ServerException {
        return Left(ServerFailure());
      } on NoUserException {
        return Left(NoUserFailure());
      } on EmailAlreadyInUseException {
        return Left(EmailAlreadyInUseFailure());
      } on InvalidEmailException {
        return Left(InvalidEmailFailure());
      } on WeakPasswordException {
        return Left(WeakPasswordFailure());
      } on TooManyRequestsException {
        return Left(TooManyRequestsFailure());
      }
    } else {
      logger.log("AuthenticationRepositoryImpl:userSignUp()", "Offline_Error");
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> switchToPublisher() {
    // TODO: implement switchToPublisher
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> switchToUser() {
    // TODO: implement switchToUser
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Publisher>> publisherSignIn(AuthParams params) async {
    logger.log("AuthenticationRepositoryImpl:publisherSignIn()", "Started");
    if (await networkInfo.isConnected) {
      try {
        var publisher = await authenticationDataSource.publisherSignIn(params);
        sl.registerSingleton<Publisher>(publisher);

        return Right(publisher);
      } on ServerException {
        return Left(ServerFailure());
      } on NoUserException {
        return Left(NoUserFailure());
      } on EmailAlreadyInUseException {
        return Left(EmailAlreadyInUseFailure());
      } on InvalidEmailException {
        return Left(InvalidEmailFailure());
      } on WeakPasswordException {
        return Left(WeakPasswordFailure());
      } on TooManyRequestsException {
        return Left(TooManyRequestsFailure());
      } on WrongPasswordException {
        return Left(WrongPasswordFailure());
      } on InvalidCredentialException {
        return Left(InvalidCredentialsFailure());
      }
    } else {
      logger.log(
          "AuthenticationRepositoryImpl:publisherSignIn()", "Offline_Error");
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Publisher>> publisherSignUp(AuthParams params) async {
    logger.log("AuthenticationRepositoryImpl:publisherSignUp()", "Started");
    if (await networkInfo.isConnected) {
      try {
        var publisher = await authenticationDataSource.publisherSignUp(params);
        sl.registerSingleton<Publisher>(publisher);

        return Right(publisher);
      } on ServerException {
        return Left(ServerFailure());
      } on NoUserException {
        return Left(NoUserFailure());
      } on EmailAlreadyInUseException {
        return Left(EmailAlreadyInUseFailure());
      } on InvalidEmailException {
        return Left(InvalidEmailFailure());
      } on WeakPasswordException {
        return Left(WeakPasswordFailure());
      } on TooManyRequestsException {
        return Left(TooManyRequestsFailure());
      }
    } else {
      logger.log(
          "AuthenticationRepositoryImpl:publisherSignUp()", "Offline_Error");
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> forgotPassword() async {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Unit>> signOut() async {
    logger.log("AuthenticationRepositoryImpl:signOut()", "Started");
    if (await networkInfo.isConnected) {
      try {
        await authenticationDataSource.signOut();
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      logger.log("AuthenticationRepositoryImpl:signOut()", "Offline_Error");
      return Left(OfflineFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> verifyEmail() async {
    logger.log("AuthenticationRepositoryImpl:verifyEmail()", "Started");
    if (await networkInfo.isConnected) {
      try {
        await authenticationDataSource.verifyEmail();
        return Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      } on NoUserException {
        return Left(NoUserFailure());
      } on TooManyRequestsException {
        return Left(TooManyRequestsFailure());
      }
    } else {
      logger.log("AuthenticationRepositoryImpl:verifyEmail()", "Offline_Error");
      return Left(OfflineFailure());
    }
  }


}
