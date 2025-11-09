import 'package:demo_swapi/domain/entities/people_entity.dart';
import 'package:demo_swapi/domain/repositories/people_repository.dart';

class GetPeopleUseCase {
  GetPeopleUseCase(this._repository);

  final PeopleRepository _repository;

  Future<PeopleEntity> call({int? page, String? search}) {
    return _repository.getPeople(page: page, search: search);
  }
}
