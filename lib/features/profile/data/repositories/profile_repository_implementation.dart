import 'package:dartz/dartz.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';
import 'package:myapp/core/error/failure.dart';
import 'package:myapp/features/profile/data/datasources/local_datasource.dart';
import 'package:myapp/features/profile/data/datasources/remote_datasource.dart';
import 'package:myapp/features/profile/data/models/profile_model.dart';
import 'package:myapp/features/profile/domain/entities/profile.dart';
import 'package:myapp/features/profile/domain/repositories/profile_repositories.dart';

class ProfileRepositoryImplementation extends ProfileRepositories{
  final ProfileRemoteDataSource remoteDataSource;
  final ProfileLocalDataSource localDataSource;
  final HiveInterface hive;

  ProfileRepositoryImplementation({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.hive,
  });

  @override
  Future<Either<Failure, List<Profile>>> getAllUser(int page) async{
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    try{
      if(connectivityResult.contains(ConnectivityResult.none)){
        List<ProfileModel> results = await localDataSource.getAllUser(page);
        return Right(results);
      }else{
        List<ProfileModel> results = await remoteDataSource.getAllUser(page);
        var box = hive.box("profile_box");
        box.put("getAllUser", results);
        return Right(results);
      }
    }catch(e){
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, Profile>> getUserById(int id) async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity().checkConnectivity());
    try{
      if(connectivityResult.contains(ConnectivityResult.none)){
        ProfileModel result = await localDataSource.getUserById(id);
        return Right(result);
      }else{
        ProfileModel result = await remoteDataSource.getUserById(id);
        var box = hive.box("profile_box");
        box.put("getUser", result);
        return Right(result);
      }
    }catch(e){
      return Left(Failure());
    }
  }
}