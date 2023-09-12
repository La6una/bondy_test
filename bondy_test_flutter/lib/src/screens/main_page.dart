import 'package:bondy_test_flutter/src/blocs/cubit/locations_cubit.dart';
import 'package:bondy_test_flutter/src/screens/main_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  final String apiKey = '163lyuzif8ptzefn8zy7ejpj0rqja60fp2upcths';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LocationsCubit(widget.apiKey)),
      ], 
      child: MainView(apiKey: widget.apiKey,),
    );
  }
}
