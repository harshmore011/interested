
import 'package:dartz/dartz.dart';
import 'package:interested/core/failures/failures.dart';

abstract class Usecase<Type, Params> {

  Future<Either<Failure,Type>> call(Params params);

}