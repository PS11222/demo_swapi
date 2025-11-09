import 'person_entity.dart';

class PeopleEntity {
  const PeopleEntity({required this.count, required this.next, required this.previous, required this.results});

  final int count;
  final String? next;
  final String? previous;
  final List<PersonEntity> results;
}
