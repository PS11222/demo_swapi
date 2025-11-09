import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demo_swapi/presentation/bloc/people_cubit.dart';
import 'package:demo_swapi/presentation/bloc/people_state.dart';
import 'package:demo_swapi/domain/entities/person_entity.dart';

class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key});

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  @override
  void initState() {
    super.initState();
    context.read<PeopleCubit>().loadPeople(page: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: const Text('Star Wars Characters'))),
      body: BlocBuilder<PeopleCubit, PeopleState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (people) => ListView.builder(
              itemCount: people.results.length,
              itemBuilder: (context, index) {
                final person = people.results[index];
                return _PersonListItem(person: person);
              },
            ),
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: $message'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<PeopleCubit>().loadPeople(page: 1),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PersonListItem extends StatelessWidget {
  const _PersonListItem({required this.person});

  final PersonEntity person;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(person.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Text('Gender: ${person.gender}'), Text('Birth Year: ${person.birthYear}')],
        ),
      ),
    );
  }
}
