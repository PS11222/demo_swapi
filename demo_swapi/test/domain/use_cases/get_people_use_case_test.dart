import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:demo_swapi/domain/entities/person_entity.dart';
import 'package:demo_swapi/domain/entities/people_entity.dart';
import 'package:demo_swapi/domain/repositories/people_repository.dart';
import 'package:demo_swapi/domain/use_cases/get_people_use_case.dart';

class MockPeopleRepository extends Mock implements PeopleRepository {}

void main() {
  late MockPeopleRepository mockRepository;
  late GetPeopleUseCase useCase;

  setUp(() {
    mockRepository = MockPeopleRepository();
    useCase = GetPeopleUseCase(mockRepository);
  });

  final person1 = PersonEntity(name: 'Luke Skywalker', gender: 'male', birthYear: '19BBY');
  final person2 = PersonEntity(name: 'Darth Vader', gender: 'male', birthYear: '41.9BBY');

  final peopleEntity = PeopleEntity(
    count: 2,
    next: 'https://swapi.dev/api/people/?page=2',
    previous: null,
    results: [person1, person2],
  );

  group('GetPeopleUseCase', () {
    test('calls repository.getPeople with correct parameters', () async {
      when(() => mockRepository.getPeople(page: 1, search: null)).thenAnswer((_) async => peopleEntity);

      await useCase(page: 1, search: null);

      verify(() => mockRepository.getPeople(page: 1, search: null)).called(1);
    });

    test('returns PeopleEntity when repository succeeds', () async {
      when(() => mockRepository.getPeople(page: 1, search: null)).thenAnswer((_) async => peopleEntity);

      final result = await useCase(page: 1, search: null);

      expect(result, equals(peopleEntity));
      expect(result.count, equals(2));
      expect(result.results.length, equals(2));
    });

    test('calls repository with search parameter', () async {
      when(() => mockRepository.getPeople(page: null, search: 'Luke')).thenAnswer((_) async => peopleEntity);

      await useCase(page: null, search: 'Luke');

      verify(() => mockRepository.getPeople(page: null, search: 'Luke')).called(1);
    });

    test('calls repository with page parameter', () async {
      when(() => mockRepository.getPeople(page: 2, search: null)).thenAnswer((_) async => peopleEntity);

      await useCase(page: 2, search: null);

      verify(() => mockRepository.getPeople(page: 2, search: null)).called(1);
    });

    test('throws exception when repository throws', () async {
      when(() => mockRepository.getPeople(page: 1, search: null)).thenThrow(Exception('Network error'));

      expect(() => useCase(page: 1, search: null), throwsA(isA<Exception>()));
    });
  });
}
