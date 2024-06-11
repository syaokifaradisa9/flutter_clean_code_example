// [Flutter test Terminal Command]
// [1] >> dart run build_runner build --delete-conflicting-outputs (Mocking File)
// [2] >> flutter test --machine > test.output
// [3] >> flutter test --coverage (Test All Folder)
// [3] >> flutter test test/profile --coverage (Test Spesific File)
// [3] >> lcov --remove coverage/lcov.info "lib/core/error/*" "another file/folder" -o coverage/lcov.info (Optional For Remove Coverage)
// [4] >> genhtml coverage/lcov.info -o coverage/html --legend -t "Coverage Test" --function-coverage
// [5] >> open coverage/html/index.html

import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:myapp/core/error/exception.dart';
import 'package:myapp/features/profile/data/datasources/remote_datasource.dart';
import 'package:myapp/features/profile/data/models/profile_model.dart';
import 'package:http/http.dart' as http;

@GenerateNiceMocks([MockSpec<ProfileRemoteDataSource>(), MockSpec<http.Client>()])
import 'remote_datasource_test.mocks.dart';

void main() async{
  const int userId = 1;
  const int page = 1;

  Map<String, dynamic> fakeDataJson = {
    "data": {
      "id": 1,
      "email": "george.bluth@reqres.in",
      "first_name": "George",
      "last_name": "Bluth",
      "avatar": "https://reqres.in/img/faces/1-image.jpg"
    }
  };

  Uri urlGetAllUser = Uri.parse("https://reqres.in/api/users?page=$page");
  Uri urlGetUser = Uri.parse("https://reqres.in/api/users/$userId");
  ProfileModel fakeProfileModel = ProfileModel.fromJson(fakeDataJson);

  // Mocking
  var remoteDataSource = MockProfileRemoteDataSource();
  MockClient mockClient = MockClient();
  var remoteDataSourceImplementation = ProfileRemoteDataSourceImplementation(
    client: mockClient,
  );

  group('profile remote data source', (){
    group('getUserById', (){
      test('should return profile model when success (200)', () async {
        when(remoteDataSource.getUserById(userId)).thenAnswer(
          (_) async => fakeProfileModel
        );

        var result = await remoteDataSource.getUserById(userId);
        expect(result, fakeProfileModel);
      });

      test('should throw EmptyException when user data not found (404)', () async {
        when(remoteDataSource.getUserById(userId + 100)).thenThrow(
          (_) async => EmptyException(
            message: "data not found"
          )
        );

        try{
          await remoteDataSource.getUserById(userId);
        }catch(e){
          expect(e, isException);
        }
      });
    });

    group('getAllUser', (){
      test('should return list of profile model when success (200)', () async {
        when(remoteDataSource.getAllUser(page)).thenAnswer(
          (_) async => [fakeProfileModel]
        );

        var result = await remoteDataSource.getAllUser(page);
        expect(result, [fakeProfileModel]);
      });

      test('should throw EmptyException when list user data not found (404)', () async {
        when(remoteDataSource.getAllUser(page + 100)).thenThrow(
          (_) async => EmptyException(
            message: "data not found"
          )
        );

        try{
          await remoteDataSource.getUserById(userId);
        }catch(e){
          expect(e, isException);
        }
      });
    });
  });

  group('profile remote data source implementation', (){
    group('getUserById', (){
      test('should return profile model when success (200)', () async {
        when(mockClient.get(urlGetUser)).thenAnswer(
          (_) async => http.Response(
            jsonEncode({ "data": fakeDataJson }),
            200
          ),
        );

        var result = await remoteDataSourceImplementation.getUserById(userId);
        expect(result, fakeProfileModel);
      });

      test('should throw empty exception when not found (404)', () async {
        when(mockClient.get(urlGetUser)).thenThrow(
          EmptyException(message: 'Data Not Found')
        );

        try{
          await remoteDataSourceImplementation.getUserById(userId);
        } on EmptyException catch (e){
          expect(e, isException);
        }
      });
    });

    group('getAllUser', (){
      test('should return list of profile when getAllUser success (200)', () async{
        when(mockClient.get(urlGetAllUser)).thenAnswer(
          (_) async => http.Response(
            jsonEncode({
              "data": [fakeDataJson]
            }),
            200,
        ));

        var result = await remoteDataSourceImplementation.getAllUser(page);
        expect(result, [fakeProfileModel]);
      });

      test('should throw empty exception when data is empty (200)', () async{
        when(mockClient.get(urlGetAllUser)).thenAnswer(
          (_) async => http.Response(
            jsonEncode({
              'data' : []
            }),
            200
        ));

        try{
          await remoteDataSourceImplementation.getAllUser(page);
        } on EmptyException catch (e){
          expect(e, isException);
        }
      });

      test('should throw empty exception when data is not found (404)', () async{
        when(mockClient.get(urlGetAllUser)).thenAnswer(
          (_) async => http.Response(
            jsonEncode({
              'data' : []
            }),
            404
        ));

        try{
          await remoteDataSourceImplementation.getAllUser(page);
        } on EmptyException catch (e){
          expect(e, isException);
        }
      });

      test('should throw exception when server is invalid (500)', () async{
        when(mockClient.get(urlGetAllUser)).thenAnswer(
          (_) async => http.Response(
            jsonEncode({
              'data' : []
            }),
            500
        ));

        try{
          await remoteDataSourceImplementation.getAllUser(page);
        } catch (e){
          expect(e, isException);
        }
      });
    });
  });
}