import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:demo_swapi/domain/entities/person_entity.dart';
import 'package:demo_swapi/presentation/pages/people_page.dart';
import 'package:demo_swapi/presentation/pages/person_detail_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: PeopleRoute.page, initial: true),
    AutoRoute(page: PersonDetailRoute.page),
  ];
}
