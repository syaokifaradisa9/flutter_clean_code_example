import 'package:hive/hive.dart';
import 'package:myapp/features/profile/data/models/profile_model.dart';

abstract class ProfileLocalDataSource{
  Future<List<ProfileModel>> getAllUser(int page);
  Future<ProfileModel> getUserById(int id);
}

class ProfileLocalDataSourceImplementation extends ProfileLocalDataSource{
  final HiveInterface hive;
  ProfileLocalDataSourceImplementation({required this.hive});

  @override
  Future<ProfileModel> getUserById(int id) async{
    var box = hive.box("profile_box");
    return box.get('getAllUser');
  }

  @override
  Future<List<ProfileModel>> getAllUser(int page) async {
    var box = hive.box("profile_box");
    return box.get('getUser');
  }
}