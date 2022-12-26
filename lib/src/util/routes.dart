import 'package:flutter/material.dart';
import 'package:todo_hero/src/logic/bloc/app_bloc.dart';
import 'package:todo_hero/src/screens/Login/login_view.dart';
import 'package:todo_hero/src/screens/main_screen.dart';

List<Page<dynamic>> onGenerateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  print('Bin jetzt in der Routes-Navigation');
  switch (state) {
    case AppStatus.authenticated:
      return [MainView.page()];
    case AppStatus.unauthenticated:
      return [LoginView.page()];
  }
}
