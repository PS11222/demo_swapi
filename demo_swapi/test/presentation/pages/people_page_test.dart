import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:demo_swapi/core/theme/star_wars_theme.dart';
import 'package:demo_swapi/domain/entities/person_entity.dart';
import 'package:demo_swapi/domain/entities/people_entity.dart';
import 'package:demo_swapi/presentation/bloc/people_bloc.dart';
import 'package:demo_swapi/presentation/bloc/people_event.dart';
import 'package:demo_swapi/presentation/bloc/people_state.dart';
import 'package:demo_swapi/presentation/pages/people_page.dart';

class MockPeopleBloc extends Mock implements PeopleBloc {}

void main() {
  late MockPeopleBloc mockPeopleBloc;

  setUp(() {
    mockPeopleBloc = MockPeopleBloc();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      theme: StarWarsTheme.darkTheme,
      home: BlocProvider<PeopleBloc>.value(value: mockPeopleBloc, child: const PeoplePage()),
    );
  }

  group('PeoplePage', () {
    testWidgets('displays app bar with correct title', (WidgetTester tester) async {
      when(() => mockPeopleBloc.state).thenReturn(const PeopleState.initial());
      when(() => mockPeopleBloc.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('STAR WARS CHARACTERS'), findsOneWidget);
    });

    testWidgets('displays search field', (WidgetTester tester) async {
      when(() => mockPeopleBloc.state).thenReturn(const PeopleState.initial());
      when(() => mockPeopleBloc.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(TextField), findsOneWidget);
    });

    testWidgets('displays loading indicator when state is loading', (WidgetTester tester) async {
      when(() => mockPeopleBloc.state).thenReturn(const PeopleState.loading());
      when(() => mockPeopleBloc.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('displays list of people when state is loaded', (WidgetTester tester) async {
      final people = PeopleEntity(
        count: 2,
        next: null,
        previous: null,
        results: [
          PersonEntity(name: 'Luke Skywalker', gender: 'male', birthYear: '19BBY'),
          PersonEntity(name: 'Darth Vader', gender: 'male', birthYear: '41.9BBY'),
        ],
      );

      when(() => mockPeopleBloc.state).thenReturn(PeopleState.loaded(people));
      when(() => mockPeopleBloc.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Luke Skywalker'), findsOneWidget);
      expect(find.text('Darth Vader'), findsOneWidget);
    });

    testWidgets('displays "No results found" when results are empty', (WidgetTester tester) async {
      final people = PeopleEntity(count: 0, next: null, previous: null, results: []);

      when(() => mockPeopleBloc.state).thenReturn(PeopleState.loaded(people));
      when(() => mockPeopleBloc.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('No results found'), findsOneWidget);
    });

    testWidgets('displays error message when state is error', (WidgetTester tester) async {
      when(() => mockPeopleBloc.state).thenReturn(const PeopleState.error('Network error'));
      when(() => mockPeopleBloc.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Error: Network error'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });

    testWidgets('calls loadPeople event on init', (WidgetTester tester) async {
      when(() => mockPeopleBloc.state).thenReturn(const PeopleState.initial());
      when(() => mockPeopleBloc.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(createWidgetUnderTest());

      verify(() => mockPeopleBloc.add(const PeopleEvent.loadPeople(page: 1))).called(1);
    });

    testWidgets('displays loading indicator when loading more', (WidgetTester tester) async {
      final people = PeopleEntity(
        count: 2,
        next: 'https://swapi.dev/api/people/?page=2',
        previous: null,
        results: [PersonEntity(name: 'Luke Skywalker', gender: 'male', birthYear: '19BBY')],
      );

      when(() => mockPeopleBloc.state).thenReturn(PeopleState.loaded(people, isLoadingMore: true));
      when(() => mockPeopleBloc.stream).thenAnswer((_) => const Stream.empty());

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text('Loading more...'), findsOneWidget);
    });
  });
}
