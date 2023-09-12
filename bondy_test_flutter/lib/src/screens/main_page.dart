import 'package:bondy_test_flutter/src/blocs/cubit/locations_cubit.dart';
import 'package:bondy_test_flutter/src/screens/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LocationsCubit()),
      ], 
      child: MainView(),
    );
  }
}
