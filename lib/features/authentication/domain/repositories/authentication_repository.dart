
import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../entities/anonymous_entity.dart';
import '../entities/auth.dart';
import '../entities/publisher_entity.dart';

import '../entities/user_entity.dart';

abstract class AuthenticationRepository {

  Future<Either<Failure, Anonymous>> anonymousSignIn();
  Future<Either<Failure, User>> anonymousToUser(AuthParams params);
  Future<Either<Failure, User>> userSignUp(AuthParams params);
  Future<Either<Failure, User>> userSignIn(AuthParams params);
  Future<Either<Failure, Publisher>> publisherSignUp(AuthParams params);
  Future<Either<Failure, Publisher>> publisherSignIn(AuthParams params);
 // Future<Either<Failure, User>> anonymousToUser(AuthProvider authProvider, {EmailAuthCredential credential});
 //  Future<Either<Failure, User>> userSignUp(AuthProvider authProvider, {EmailAuthCredential credential});
 //  Future<Either<Failure, User>> userSignIn(AuthProvider authProvider, {EmailAuthCredential credential});
 //  Future<Either<Failure, Publisher>> publisherSignUp(AuthProvider authProvider, {EmailAuthCredential credential});
 //  Future<Either<Failure, Publisher>> publisherSignIn(AuthProvider authProvider, {EmailAuthCredential credential});
  Future<Either<Failure, Unit>> verifyEmail();
  Future<Either<Failure, Unit>> forgotPassword();
  Future<Either<Failure, Unit>> signOut();

}
