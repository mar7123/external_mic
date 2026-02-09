import 'package:external_mic/pages/home_page.dart';
import 'package:external_mic/pages/other/page_not_found_page.dart';
import 'package:external_mic/navigation/base_navigated_page.dart';
import 'package:external_mic/navigation/custom_base_navigator.dart';
import 'package:external_mic/repository/page_argument_repository.dart';
import 'package:external_mic/utils/query_params_utils.dart';
import 'package:go_router/go_router.dart';

class MainNavigator extends CustomBaseNavigator {
  static final MainNavigator _instance = MainNavigator._internal();

  factory MainNavigator() => _instance;

  late final GoRouter _router;

  MainNavigator._internal();

  GoRouter initialize() {
    _router = GoRouter(
      navigatorKey: navigatorKey,
      initialLocation: HomePage().path,
      errorBuilder: (context, state) => PageNotFoundPage().widget,
      routes: customRoutes,
    );
    return _router;
  }

  @override
  List<RouteBase> get customRoutes => [
    generateRoute(page: HomePage()),
    generateRoute(page: PageNotFoundPage()),
  ];

  String _setUri(
    BaseNavigatedPage page, {
    BaseNavigatedPageArgument? argument,
  }) {
    String? argId;
    if (argument != null) {
      argId = QueryParamsUtils.encodeParamContent(argument.id);
      PageArgumentRepository().setArgument(argument: argument);
    }
    return Uri(
      path: page.fullPath,
      queryParameters: argId != null
          ? {QueryParamTypes.args.name: argId}
          : null,
    ).toString();
  }

  void go(BaseNavigatedPage page, {BaseNavigatedPageArgument? argument}) {
    _router.go(_setUri(page, argument: argument));
  }

  Future<T?> push<T extends Object?>(
    BaseNavigatedPage page, {
    BaseNavigatedPageArgument? argument,
  }) {
    return _router.push(_setUri(page, argument: argument));
  }

  void pop<T extends Object?>([T? result]) {
    _router.pop(result);
  }
}
