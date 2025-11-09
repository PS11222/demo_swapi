import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:demo_swapi/data/repositories/people_repository.dart';
import 'package:demo_swapi/data/services/swapi_service.dart';
import 'package:demo_swapi/domain/repositories/people_repository.dart';
import 'package:demo_swapi/domain/use_cases/get_people_use_case.dart';
import 'package:demo_swapi/presentation/bloc/people_cubit.dart';

final getIt = GetIt.instance;

void configureDependencies() {
  getIt.registerLazySingleton(() => Dio());
  getIt.registerLazySingleton(() => SwapiService(getIt()));
  getIt.registerLazySingleton<PeopleRepository>(() => PeopleRepositoryImpl(getIt()));
  getIt.registerLazySingleton(() => GetPeopleUseCase(getIt()));
  getIt.registerSingleton(PeopleCubit(getIt()));
}
