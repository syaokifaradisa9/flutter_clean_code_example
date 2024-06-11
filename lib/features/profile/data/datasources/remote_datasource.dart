import 'dart:convert';

import 'package:myapp/core/error/exception.dart';
import 'package:myapp/features/profile/data/models/profile_model.dart';
import 'package:http/http.dart' as http;

abstract class ProfileRemoteDataSource{
  Future<List<ProfileModel>> getAllUser(int page);
  Future<ProfileModel> getUserById(int id);
}

class ProfileRemoteDataSourceImplementation extends ProfileRemoteDataSource{
  final http.Client client;
  ProfileRemoteDataSourceImplementation({
    required this.client
  });

  @override
  Future<ProfileModel> getUserById(int id) async{
    Uri url = Uri.parse("https://reqres.in/api/users/$id");
    var response = await client.get(url);

    if (response.statusCode == 404) {
      throw EmptyException(
        message: "Data not found - Error 404"
      );
    }else if(response.statusCode != 200){
      throw GeneralException(message: 'cannot get data');
    }

    Map<String, dynamic> dataBody = jsonDecode(response.body);
    Map<String, dynamic> data = dataBody['data'];

    return ProfileModel.fromJson(data);
  }

  @override
  Future<List<ProfileModel>> getAllUser(int page) async {
    Uri url = Uri.parse("https://reqres.in/api/users?page=$page");
    var response = await client.get(url);

    if (response.statusCode == 404) {
      throw EmptyException(
        message: "Data not found - Error 404"
      );
    }else if(response.statusCode != 200){
      throw GeneralException(message: 'cannot get data');
    }

    Map<String, dynamic> dataBody = jsonDecode(response.body);
    List<dynamic> data = dataBody['data'];
    if(data.isEmpty){
      throw EmptyException(message: 'Empty data - Error 404');
    }

    return data.map((e) => ProfileModel.fromJson(e)).toList();
  }
}