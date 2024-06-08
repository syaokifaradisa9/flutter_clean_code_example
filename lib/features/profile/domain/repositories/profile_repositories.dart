import 'package:myapp/core/error/failure.dart';
import 'package:myapp/features/profile/domain/entities/profile.dart';
import 'package:dartz/dartz.dart';

abstract class ProfileRepositories{
  Future<Either<Failure, List<Profile>>> getAllUser(int page);
  Future<Either<Failure, Profile>> getUserById(int id);
}