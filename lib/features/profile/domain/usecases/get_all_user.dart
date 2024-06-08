import 'package:myapp/features/profile/domain/entities/profile.dart';
import 'package:myapp/features/profile/domain/repositories/profile_repositories.dart';

class GetAllUser{
  final ProfileRepositories profileRepository;
  const GetAllUser(this.profileRepository);

  Future<List<Profile>> execute(page) async{
    return await profileRepository.getAllUser(page);
  }
}