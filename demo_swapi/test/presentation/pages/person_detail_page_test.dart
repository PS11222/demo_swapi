import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:demo_swapi/core/theme/star_wars_theme.dart';
import 'package:demo_swapi/domain/entities/person_entity.dart';
import 'package:demo_swapi/presentation/pages/person_detail_page.dart';

void main() {
  group('PersonDetailPage', () {
    final person = PersonEntity(name: 'Luke Skywalker', gender: 'male', birthYear: '19BBY');

    Widget createWidgetUnderTest() {
      return MaterialApp(
        theme: StarWarsTheme.darkTheme,
        home: PersonDetailPage(person: person),
      );
    }

    testWidgets('displays person name in app bar', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('LUKE SKYWALKER'), findsOneWidget);
    });

    testWidgets('displays person details in card', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.text('Name'), findsOneWidget);
      expect(find.text('Luke Skywalker'), findsWidgets);
      expect(find.text('Gender'), findsOneWidget);
      expect(find.text('male'), findsOneWidget);
      expect(find.text('Birth Year'), findsOneWidget);
      expect(find.text('19BBY'), findsOneWidget);
    });

    testWidgets('displays avatar icon', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.person), findsWidgets);
    });

    testWidgets('displays gender icon correctly for male', (WidgetTester tester) async {
      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.male), findsOneWidget);
    });

    testWidgets('displays gender icon correctly for female', (WidgetTester tester) async {
      final femalePerson = PersonEntity(name: 'Leia Organa', gender: 'female', birthYear: '19BBY');

      await tester.pumpWidget(
        MaterialApp(
          theme: StarWarsTheme.darkTheme,
          home: PersonDetailPage(person: femalePerson),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.female), findsOneWidget);
    });

    testWidgets('does not display gender row when gender is empty', (WidgetTester tester) async {
      final personWithoutGender = PersonEntity(name: 'R2-D2', gender: '', birthYear: '33BBY');

      await tester.pumpWidget(
        MaterialApp(
          theme: StarWarsTheme.darkTheme,
          home: PersonDetailPage(person: personWithoutGender),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Gender'), findsNothing);
    });

    testWidgets('does not display birth year row when birth year is empty', (WidgetTester tester) async {
      final personWithoutBirthYear = PersonEntity(name: 'Unknown', gender: 'male', birthYear: '');

      await tester.pumpWidget(
        MaterialApp(
          theme: StarWarsTheme.darkTheme,
          home: PersonDetailPage(person: personWithoutBirthYear),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Birth Year'), findsNothing);
    });
  });
}
