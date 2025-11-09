import 'package:demo_swapi/core/network/api_constants.dart';
import 'package:demo_swapi/data/models/people_response_dto.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'swapi_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class SwapiService {
  factory SwapiService(Dio dio, {String baseUrl}) = _SwapiService;

  @GET('/people/')
  Future<PeopleResponseDto> getPeople({@Query('page') int? page, @Query('search') String? search});
}