import 'package:dartz/dartz.dart';

import '../../../../core/failures/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/anonymous_entity.dart';
import '../repositories/authentication_repository.dart';

class AnonymousSignInUseCase extends Usecase<Anonymous, Unit> {
  final AuthenticationRepository repository;

  AnonymousSignInUseCase(this.repository);

  @override
  Future<Either<Failure, Anonymous>> call(Unit params) async {
    return await repository.anonymousSignIn();
  }
}
