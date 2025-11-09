import 'package:demo_swapi/domain/entities/people_entity.dart';

abstract class PeopleRepository {
  Future<PeopleEntity> getPeople({int? page, String? search});
}
