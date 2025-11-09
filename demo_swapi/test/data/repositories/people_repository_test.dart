import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:demo_swapi/data/models/person_dto.dart';
import 'package:demo_swapi/data/models/people_response_dto.dart';
import 'package:demo_swapi/data/repositories/people_repository.dart';
import 'package:demo_swapi/data/services/swapi_service.dart';
import 'package:demo_swapi/domain/entities/person_entity.dart';
import 'package:demo_swapi/domain/entities/people_entity.dart';

class MockSwapiService extends Mock implements SwapiService {}

void main() {
  late MockSwapiService mockSwapiService;
  late PeopleRepositoryImpl repository;

  setUp(() {
    mockSwapiService = MockSwapiService();
    repository = PeopleRepositoryImpl(mockSwapiService);
  });

  final personDto1 = PersonDto(
    name: 'Luke Skywalker',
    height: '172',
    mass: '77',
    hairColor: 'blond',
    skinColor: 'fair',
    eyeColor: 'blue',
    birthYear: '19BBY',
    gender: 'male',
    homeworld: 'https://swapi.dev/api/planets/1/',
    films: [],
    species: [],
    vehicles: [],
    starships: [],
    created: '2014-12-09T13:50:51.644000Z',
    edited: '2014-12-20T21:17:56.891000Z',
    url: 'https://swapi.dev/api/people/1/',
  );

  final personDto2 = PersonDto(
    name: 'Darth Vader',
    height: '202',
    mass: '136',
    hairColor: 'none',
    skinColor: 'white',
    eyeColor: 'yellow',
    birthYear: '41.9BBY',
    gender: 'male',
    homeworld: 'https://swapi.dev/api/planets/1/',
    films: [],
    species: [],
    vehicles: [],
    starships: [],
    created: '2014-12-10T15:18:20.704000Z',
    edited: '2014-12-20T21:17:50.313000Z',
    url: 'https://swapi.dev/api/people/4/',
  );

  final peopleResponseDto = PeopleResponseDto(
    count: 2,
    next: 'https://swapi.dev/api/people/?page=2',
    previous: null,
    results: [personDto1, personDto2],
  );

  group('PeopleRepositoryImpl', () {
    test('calls swapiService.getPeople with correct parameters', () async {
      when(() => mockSwapiService.getPeople(page: 1, search: null)).thenAnswer((_) async => peopleResponseDto);

      await repository.getPeople(page: 1, search: null);

      verify(() => mockSwapiService.getPeople(page: 1, search: null)).called(1);
    });

    test('maps PeopleResponseDto to PeopleEntity correctly', () async {
      when(() => mockSwapiService.getPeople(page: 1, search: null)).thenAnswer((_) async => peopleResponseDto);

      final result = await repository.getPeople(page: 1, search: null);

      expect(result, isA<PeopleEntity>());
      expect(result.count, equals(2));
      expect(result.next, equals('https://swapi.dev/api/people/?page=2'));
      expect(result.previous, isNull);
      expect(result.results.length, equals(2));
    });

    test('maps PersonDto to PersonEntity correctly', () async {
      when(() => mockSwapiService.getPeople(page: 1, search: null)).thenAnswer((_) async => peopleResponseDto);

      final result = await repository.getPeople(page: 1, search: null);

      expect(result.results[0], isA<PersonEntity>());
      expect(result.results[0].name, equals('Luke Skywalker'));
      expect(result.results[0].gender, equals('male'));
      expect(result.results[0].birthYear, equals('19BBY'));

      expect(result.results[1].name, equals('Darth Vader'));
      expect(result.results[1].gender, equals('male'));
      expect(result.results[1].birthYear, equals('41.9BBY'));
    });

    test('calls swapiService with search parameter', () async {
      when(() => mockSwapiService.getPeople(page: null, search: 'Luke')).thenAnswer((_) async => peopleResponseDto);

      await repository.getPeople(page: null, search: 'Luke');

      verify(() => mockSwapiService.getPeople(page: null, search: 'Luke')).called(1);
    });

    test('calls swapiService with page parameter', () async {
      when(() => mockSwapiService.getPeople(page: 2, search: null)).thenAnswer((_) async => peopleResponseDto);

      await repository.getPeople(page: 2, search: null);

      verify(() => mockSwapiService.getPeople(page: 2, search: null)).called(1);
    });

    test('throws exception when swapiService throws', () async {
      when(() => mockSwapiService.getPeople(page: 1, search: null)).thenThrow(Exception('Network error'));

      expect(() => repository.getPeople(page: 1, search: null), throwsA(isA<Exception>()));
    });

    test('handles empty results correctly', () async {
      final emptyResponse = PeopleResponseDto(count: 0, next: null, previous: null, results: []);

      when(() => mockSwapiService.getPeople(page: 1, search: null)).thenAnswer((_) async => emptyResponse);

      final result = await repository.getPeople(page: 1, search: null);

      expect(result.count, equals(0));
      expect(result.results.isEmpty, isTrue);
    });
  });
}
