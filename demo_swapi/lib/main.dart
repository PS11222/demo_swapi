import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:demo_swapi/core/di/di.dart';
import 'package:demo_swapi/core/router/app_router.dart';
import 'package:demo_swapi/presentation/bloc/people_bloc.dart';

final appRouter = AppRouter();

void main() {
  configureDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<PeopleBloc>(create: (_) => getIt<PeopleBloc>())],
      child: MaterialApp.router(
        title: 'Flutter Demo',
        theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
        routerConfig: appRouter.config(),
      ),
    );
  }
}
