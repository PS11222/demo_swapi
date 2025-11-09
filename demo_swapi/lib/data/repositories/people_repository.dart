import 'package:demo_swapi/data/models/person_dto.dart';
import 'package:demo_swapi/data/models/people_response_dto.dart';
import 'package:demo_swapi/data/services/swapi_service.dart';
import 'package:demo_swapi/domain/entities/person_entity.dart';
import 'package:demo_swapi/domain/entities/people_entity.dart';
import 'package:demo_swapi/domain/repositories/people_repository.dart';

class PeopleRepositoryImpl implements PeopleRepository {
  final SwapiService _swapiService;

  PeopleRepositoryImpl(this._swapiService);

  @override
  Future<PeopleEntity> getPeople({int? page, String? search}) async {
    final dto = await _swapiService.getPeople(page: page, search: search);
    return _mapToEntity(dto);
  }

  PeopleEntity _mapToEntity(PeopleResponseDto dto) {
    return PeopleEntity(
      count: dto.count,
      next: dto.next,
      previous: dto.previous,
      results: dto.results.map((personDto) => _mapPersonToEntity(personDto)).toList(),
    );
  }

  PersonEntity _mapPersonToEntity(PersonDto dto) {
    return PersonEntity(name: dto.name, gender: dto.gender, birthYear: dto.birthYear);
  }
}
