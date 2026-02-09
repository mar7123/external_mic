import 'dart:collection';

import 'package:external_mic/navigation/base_navigated_page.dart';

class PageArgumentRepository {
  static const _maxArgument = 20;

  static final PageArgumentRepository _instance =
      PageArgumentRepository._internal();

  factory PageArgumentRepository() => _instance;

  PageArgumentRepository._internal();

  final LinkedHashMap<String, BaseNavigatedPageArgument> _arguments =
      LinkedHashMap();

  BaseNavigatedPageArgument? getArgument({required String id}) =>
      _arguments[id];

  void setArgument({required BaseNavigatedPageArgument argument}) {
    if (_arguments.length >= _maxArgument) {
      _arguments.remove(_arguments.keys.last);
    }
    _arguments.remove(argument.id);
    _arguments[argument.id] = argument;
  }
}
