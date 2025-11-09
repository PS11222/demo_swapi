import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demo_swapi/core/router/app_router.dart';
import 'package:demo_swapi/core/theme/app_colors.dart';
import 'package:demo_swapi/core/theme/star_wars_theme.dart';
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
      appBar: AppBar(title: FittedBox(child: const Text('STAR WARS CHARACTERS')), centerTitle: true),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                style: Theme.of(context).textTheme.bodyLarge,
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
                        ? Center(
                            child: Text(
                              'No results found',
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            itemCount: people.results.length + (isLoadingMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == people.results.length) {
                                return Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        const CircularProgressIndicator(),
                                        const SizedBox(height: 16),
                                        Text('Loading more...', style: Theme.of(context).textTheme.bodyMedium),
                                      ],
                                    ),
                                  ),
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

class _PersonListItem extends StatefulWidget {
  const _PersonListItem({required this.person, required this.onTap});

  final PersonEntity person;
  final VoidCallback onTap;

  @override
  State<_PersonListItem> createState() => _PersonListItemState();
}

class _PersonListItemState extends State<_PersonListItem> with SingleTickerProviderStateMixin {
  bool _isPressed = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(boxShadow: _isPressed ? [StarWarsTheme.glowShadow] : [StarWarsTheme.cardShadow]),
            child: Card(
              child: InkWell(
                onTap: () {
                  widget.onTap();
                },
                onTapDown: (_) {
                  setState(() => _isPressed = true);
                  _animationController.forward();
                },
                onTapUp: (_) {
                  setState(() => _isPressed = false);
                  _animationController.reverse();
                },
                onTapCancel: () {
                  setState(() => _isPressed = false);
                  _animationController.reverse();
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: 'person_name_${widget.person.name}',
                              child: Material(
                                color: Colors.transparent,
                                child: Text(
                                  widget.person.name,
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppColors.forceYellow,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.forceYellow),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}