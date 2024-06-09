import 'dart:convert';

import 'package:myapp/features/profile/data/models/profile_model.dart';
import 'package:http/http.dart' as http;

abstract class ProfileRemoteDataSource{
  Future<List<ProfileModel>> getAllUser(int page);
  Future<ProfileModel> getUserById(int id);
}

class ProfileRemoteDataSourceImplementation extends ProfileRemoteDataSource{
  @override
  Future<ProfileModel> getUserById(int id) async{
    Uri url = Uri.parse("https://reqres.in/api/users/$id");
    var response = await http.get(url);

    Map<String, dynamic> dataBody = jsonDecode(response.body);
    Map<String, dynamic> data = dataBody['data'];

    return ProfileModel.fromJson(data);
  }

  @override
  Future<List<ProfileModel>> getAllUser(int page) async {
    Uri url = Uri.parse("https://reqres.in/api/users?page=$page");
    var response = await http.get(url);

    Map<String, dynamic> dataBody = jsonDecode(response.body);
    List<dynamic> data = dataBody['data'];

    return data.map((e) => ProfileModel.fromJson(e)).toList();
  }
}