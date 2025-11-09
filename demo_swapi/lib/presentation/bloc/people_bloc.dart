import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:demo_swapi/domain/use_cases/get_people_use_case.dart';
import 'package:demo_swapi/presentation/bloc/people_state.dart';
import 'package:demo_swapi/presentation/bloc/people_event.dart';

EventTransformer<PeopleEventSearch> debounce({Duration duration = const Duration(milliseconds: 300)}) {
  return (events, mapper) => events.debounce(duration).switchMap(mapper);
}

class PeopleBloc extends Bloc<PeopleEvent, PeopleState> {
  PeopleBloc(this._getPeopleUseCase) : super(const PeopleState.initial()) {
    on<PeopleEventSearch>(_onSearchPeople, transformer: debounce());
    on<PeopleEventLoadPeople>(_onLoadPeople);
    on<PeopleEventClearSearch>(_onClearSearch);
  }

  final GetPeopleUseCase _getPeopleUseCase;
  String _lastSearchText = '';

  Future<void> _onLoadPeople(PeopleEventLoadPeople event, Emitter<PeopleState> emit) async {
    emit(const PeopleState.loading());
    try {
      final people = await _getPeopleUseCase(page: event.page, search: event.search);
      emit(PeopleState.loaded(people));
    } catch (e) {
      emit(PeopleState.error(e.toString()));
    }
  }

  Future<void> _onSearchPeople(PeopleEventSearch event, Emitter<PeopleState> emit) async {
    final searchText = event.query.trim();

    if (searchText == _lastSearchText) {
      return;
    }

    _lastSearchText = searchText;

    if (searchText.isEmpty) {
      add(const PeopleEvent.loadPeople(page: 1));
    } else if (searchText.length >= 2) {
      add(PeopleEvent.loadPeople(search: searchText));
    }
  }

  Future<void> _onClearSearch(PeopleEventClearSearch event, Emitter<PeopleState> emit) async {
    _lastSearchText = '';
    add(const PeopleEvent.loadPeople(page: 1));
  }
}
