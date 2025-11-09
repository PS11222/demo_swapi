import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:demo_swapi/domain/entities/person_entity.dart';
import 'package:demo_swapi/domain/entities/people_entity.dart';
import 'package:demo_swapi/domain/use_cases/get_people_use_case.dart';
import 'package:demo_swapi/presentation/bloc/people_bloc.dart';
import 'package:demo_swapi/presentation/bloc/people_event.dart';
import 'package:demo_swapi/presentation/bloc/people_state.dart';

class MockGetPeopleUseCase extends Mock implements GetPeopleUseCase {}

void main() {
  late MockGetPeopleUseCase mockGetPeopleUseCase;
  late PeopleBloc peopleBloc;

  setUp(() {
    mockGetPeopleUseCase = MockGetPeopleUseCase();
    peopleBloc = PeopleBloc(mockGetPeopleUseCase);
  });

  tearDown(() {
    peopleBloc.close();
  });

  final person1 = PersonEntity(name: 'Luke Skywalker', gender: 'male', birthYear: '19BBY');
  final person2 = PersonEntity(name: 'Darth Vader', gender: 'male', birthYear: '41.9BBY');

  final peopleEntity = PeopleEntity(
    count: 2,
    next: 'https://swapi.dev/api/people/?page=2',
    previous: null,
    results: [person1, person2],
  );

  final peopleEntityPage2 = PeopleEntity(
    count: 2,
    next: null,
    previous: 'https://swapi.dev/api/people/?page=1',
    results: [person1],
  );

  group('PeopleBloc', () {
    test('initial state is PeopleState.initial()', () {
      expect(peopleBloc.state, const PeopleState.initial());
    });

    blocTest<PeopleBloc, PeopleState>(
      'emits [loading, loaded] when loadPeople succeeds',
      build: () {
        when(() => mockGetPeopleUseCase(page: 1, search: null)).thenAnswer((_) async => peopleEntity);
        return peopleBloc;
      },
      act: (bloc) => bloc.add(const PeopleEvent.loadPeople(page: 1)),
      expect: () => [const PeopleState.loading(), PeopleState.loaded(peopleEntity, isLoadingMore: false)],
      verify: (_) {
        verify(() => mockGetPeopleUseCase(page: 1, search: null)).called(1);
      },
    );

    blocTest<PeopleBloc, PeopleState>(
      'emits [loading, error] when loadPeople fails',
      build: () {
        when(() => mockGetPeopleUseCase(page: 1, search: null)).thenThrow(Exception('Network error'));
        return peopleBloc;
      },
      act: (bloc) => bloc.add(const PeopleEvent.loadPeople(page: 1)),
      expect: () => [const PeopleState.loading(), const PeopleState.error('Exception: Network error')],
    );

    blocTest<PeopleBloc, PeopleState>(
      'emits [loading, loaded] when searchPeople with valid query',
      build: () {
        when(() => mockGetPeopleUseCase(page: 1, search: 'Luke')).thenAnswer((_) async => peopleEntity);
        return peopleBloc;
      },
      act: (bloc) => bloc.add(const PeopleEvent.searchPeople('Luke')),
      wait: const Duration(milliseconds: 400),
      expect: () => [const PeopleState.loading(), PeopleState.loaded(peopleEntity, isLoadingMore: false)],
      verify: (_) {
        verify(() => mockGetPeopleUseCase(page: 1, search: 'Luke')).called(1);
      },
    );

    blocTest<PeopleBloc, PeopleState>(
      'does not emit when searchPeople with query less than 2 characters',
      build: () => peopleBloc,
      act: (bloc) => bloc.add(const PeopleEvent.searchPeople('L')),
      wait: const Duration(milliseconds: 400),
      expect: () => [],
    );

    blocTest<PeopleBloc, PeopleState>(
      'emits [loading, loaded] when clearSearch',
      build: () {
        when(() => mockGetPeopleUseCase(page: 1, search: null)).thenAnswer((_) async => peopleEntity);
        return peopleBloc;
      },
      act: (bloc) => bloc.add(const PeopleEvent.clearSearch()),
      expect: () => [const PeopleState.loading(), PeopleState.loaded(peopleEntity, isLoadingMore: false)],
    );

    blocTest<PeopleBloc, PeopleState>(
      'emits [loaded with isLoadingMore: true, loaded with isLoadingMore: false] when loadMorePeople succeeds',
      build: () {
        when(() => mockGetPeopleUseCase(page: 1, search: null)).thenAnswer((_) async => peopleEntity);
        when(() => mockGetPeopleUseCase(page: 2, search: null)).thenAnswer((_) async => peopleEntityPage2);
        return peopleBloc;
      },
      act: (bloc) async {
        bloc.add(const PeopleEvent.loadPeople(page: 1));
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(const PeopleEvent.loadMorePeople());
      },
      wait: const Duration(milliseconds: 500),
      expect: () => [
        const PeopleState.loading(),
        PeopleState.loaded(peopleEntity, isLoadingMore: false),
        PeopleState.loaded(peopleEntity, isLoadingMore: true),
        predicate<PeopleState>(
          (state) => state.maybeMap(
            loaded: (loaded) =>
                loaded.people.results.length == 3 &&
                loaded.people.results[0].name == 'Luke Skywalker' &&
                loaded.people.results[1].name == 'Darth Vader' &&
                loaded.people.results[2].name == 'Luke Skywalker' &&
                !loaded.isLoadingMore,
            orElse: () => false,
          ),
        ),
      ],
    );

    blocTest<PeopleBloc, PeopleState>(
      'does not emit when loadMorePeople called but no next page',
      build: () {
        when(() => mockGetPeopleUseCase(page: 1, search: null)).thenAnswer((_) async => peopleEntityPage2);
        return peopleBloc;
      },
      act: (bloc) async {
        bloc.add(const PeopleEvent.loadPeople(page: 1));
        await Future.delayed(const Duration(milliseconds: 100));
        bloc.add(const PeopleEvent.loadMorePeople());
      },
      wait: const Duration(milliseconds: 500),
      expect: () => [const PeopleState.loading(), PeopleState.loaded(peopleEntityPage2, isLoadingMore: false)],
    );
  });
}
