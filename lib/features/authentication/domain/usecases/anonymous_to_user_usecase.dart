import 'package:dartz/dartz.dart';
import '../../../../core/failures/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/auth.dart';
import '../entities/user_entity.dart';
import '../repositories/authentication_repository.dart';

class AnonymousToUserUseCase extends Usecase<User, AuthParams> {
  final AuthenticationRepository repository;

  AnonymousToUserUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(AuthParams params) async {
    return await repository.anonymousToUser(params);
  }
}
