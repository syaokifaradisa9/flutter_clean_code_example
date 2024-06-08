import 'package:myapp/features/profile/domain/entities/profile.dart';

abstract class ProfileRepositories{
  Future<List<Profile>> getAllUser(int page);
  Future<Profile> getUserById(int id);
}