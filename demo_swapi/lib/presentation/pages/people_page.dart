import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demo_swapi/core/router/app_router.dart';
import 'package:demo_swapi/presentation/bloc/people_cubit.dart';
import 'package:demo_swapi/presentation/bloc/people_state.dart';
import 'package:demo_swapi/domain/entities/person_entity.dart';

@RoutePage()
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
      appBar: AppBar(title: const Text('Star Wars Characters'), centerTitle: true),
      body: BlocBuilder<PeopleCubit, PeopleState>(
        builder: (context, state) {
          return state.when(
            initial: () => const SizedBox.shrink(),
            loading: () => const Center(child: CircularProgressIndicator()),
            loaded: (people) => ListView.builder(
              itemCount: people.results.length,
              itemBuilder: (context, index) {
                final person = people.results[index];
                return _PersonListItem(
                  person: person,
                  onTap: () {
                    context.router.push(PersonDetailRoute(person: person));
                  },
                );
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
  const _PersonListItem({required this.person, required this.onTap});

  final PersonEntity person;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(onTap: onTap, title: Text(person.name), trailing: const Icon(Icons.arrow_forward_ios)),
    );
  }
}
