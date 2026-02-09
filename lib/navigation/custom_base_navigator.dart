import 'package:external_mic/navigation/base_navigated_page.dart';
import 'package:external_mic/pages/other/page_not_found_page.dart';
import 'package:external_mic/repository/page_argument_repository.dart';
import 'package:external_mic/utils/query_params_utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

abstract class CustomBaseNavigator {
  GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  List<RouteBase> get customRoutes;

  @protected
  RouteBase generateRoute({required BaseNavigatedPage page}) => GoRoute(
    parentNavigatorKey: navigatorKey,
    path: page.path,
    builder: (context, state) {
      switch (page) {
        case RequiredNavigatedPage():
          String? argId = state.uri.queryParameters[QueryParamTypes.args.name];
          argId = QueryParamsUtils.decodeParamContent(argId);
          if (argId != null) {
            var argument = PageArgumentRepository().getArgument(id: argId);
            if (argument != null) return page.getWidget(argument: argument);
          }
          return PageNotFoundPage().widget;
        case OptionalNavigatedPage():
          return page.widget;
      }
    },
  );
}
