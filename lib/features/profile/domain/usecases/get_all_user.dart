import 'package:dartz/dartz.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/features/profile/domain/entities/profile.dart';
import 'package:myapp/features/profile/domain/repositories/profile_repositories.dart';

class GetAllUser{
  final ProfileRepositories profileRepository;
  const GetAllUser(this.profileRepository);

  Future<Either<Failure, List<Profile>>> execute(page) async{
    return await profileRepository.getAllUser(page);
  }
}