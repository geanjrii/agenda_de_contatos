import 'package:agenda_de_contatos/app/app_view.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'app/app_bloc_observer.dart';

void main() {
  Bloc.observer = const AppBlocObserver();
  runApp(const App());
}
