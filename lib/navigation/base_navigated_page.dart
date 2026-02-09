import 'package:flutter/material.dart';

abstract class BaseNavigatedPageArgument {
  String get id;
}

sealed class BaseNavigatedPage {
  String get path;
  String get fullPath;
}

abstract class RequiredNavigatedPage extends BaseNavigatedPage {
  StatelessWidget getWidget({required BaseNavigatedPageArgument argument});
}

abstract class OptionalNavigatedPage extends BaseNavigatedPage {
  StatelessWidget get widget;
}
