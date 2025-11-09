import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demo_swapi/core/router/app_router.dart';
import 'package:demo_swapi/presentation/bloc/people_bloc.dart';
import 'package:demo_swapi/presentation/bloc/people_state.dart';
import 'package:demo_swapi/presentation/bloc/people_event.dart';
import 'package:demo_swapi/domain/entities/person_entity.dart';

@RoutePage()
class PeoplePage extends StatefulWidget {
  const PeoplePage({super.key});

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<PeopleBloc>().add(const PeopleEvent.loadPeople(page: 1));
    _searchController.addListener(_onSearchChanged);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<PeopleBloc>().state;
      state.maybeMap(
        loaded: (loadedState) {
          if (!loadedState.isLoadingMore && loadedState.people.next != null) {
            context.read<PeopleBloc>().add(const PeopleEvent.loadMorePeople());
          }
        },
        orElse: () {},
      );
    }
  }

  void _onSearchChanged() {
    context.read<PeopleBloc>().add(PeopleEvent.searchPeople(_searchController.text));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Star Wars Characters'), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search characters...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _searchController,
                    builder: (context, value, child) {
                      return value.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                context.read<PeopleBloc>().add(const PeopleEvent.clearSearch());
                              },
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<PeopleBloc, PeopleState>(
                builder: (context, state) {
                  return state.when(
                    initial: () => const SizedBox.shrink(),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    loaded: (people, isLoadingMore) => people.results.isEmpty
                        ? const Center(child: Text('No results found'))
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: people.results.length + (isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == people.results.length) {
                                return const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(child: CircularProgressIndicator()),
                                );
                              }
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
                            onPressed: () {
                              context.read<PeopleBloc>().add(PeopleEvent.searchPeople(_searchController.text));
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
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
