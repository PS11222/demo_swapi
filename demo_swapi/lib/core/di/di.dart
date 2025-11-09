import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:demo_swapi/data/repositories/people_repository.dart';
import 'package:demo_swapi/data/services/swapi_service.dart';
import 'package:demo_swapi/domain/repositories/people_repository.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  getIt.registerSingleton<Dio>(Dio());
  getIt.registerFactory(() => SwapiService(getIt()));
  getIt.registerFactory<PeopleRepository>(() => PeopleRepositoryImpl(getIt()));
}