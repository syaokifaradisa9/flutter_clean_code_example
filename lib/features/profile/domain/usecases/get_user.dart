import 'package:myapp/features/profile/domain/entities/profile.dart';
import 'package:myapp/features/profile/domain/repositories/profile_repositories.dart';

class GetUser{
  final ProfileRepositories profileRepository;
  GetUser(this.profileRepository);

  Future<Profile> execute(id) async{
    return await profileRepository.getUserById(id);
  }
}