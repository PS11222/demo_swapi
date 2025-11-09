import 'package:demo_swapi/data/models/people_response_dto.dart';

abstract class PeopleRepository {
  Future<PeopleResponseDto> getPeople({int? page, String? search});
}