import 'package:dartz/dartz.dart';

import '../../../../core/failures/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/authentication_repository.dart';

class VerifyEmailUseCase extends Usecase<Unit, Unit> {
  final AuthenticationRepository repository;

  VerifyEmailUseCase(this.repository);

  @override
  Future<Either<Failure, Unit>> call(Unit params) async {
    return await repository.verifyEmail();
  }
}
