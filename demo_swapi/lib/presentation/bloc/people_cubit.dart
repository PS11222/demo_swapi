import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demo_swapi/domain/use_cases/get_people_use_case.dart';
import 'package:demo_swapi/presentation/bloc/people_state.dart';

class PeopleCubit extends Cubit<PeopleState> {
  PeopleCubit(this._getPeopleUseCase) : super(const PeopleState.initial());

  final GetPeopleUseCase _getPeopleUseCase;

  Future<void> loadPeople({int? page, String? search}) async {
    emit(const PeopleState.loading());
    try {
      final people = await _getPeopleUseCase(page: page, search: search);
      emit(PeopleState.loaded(people));
    } catch (e) {
      emit(PeopleState.error(e.toString()));
    }
  }
}
