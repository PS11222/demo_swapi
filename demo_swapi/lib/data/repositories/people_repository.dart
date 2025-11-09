import 'package:demo_swapi/data/models/people_response_dto.dart';
import 'package:demo_swapi/data/services/swapi_service.dart';
import 'package:demo_swapi/domain/repositories/people_repository.dart';

class PeopleRepositoryImpl implements PeopleRepository {
  final SwapiService _swapiService;

  PeopleRepositoryImpl(this._swapiService);

  @override
  Future<PeopleResponseDto> getPeople({int? page, String? search}) async {
    return _swapiService.getPeople(page: page, search: search);
  }
}