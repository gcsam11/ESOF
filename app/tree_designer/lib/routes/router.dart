import 'package:auto_route/auto_route.dart';
import 'package:tree_designer/routes/router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends $AppRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      initial: true,
      path: '/',
      page: SplashScreenRoute.page,
    ),
    AutoRoute(
      path: '/login',
      page: LoginRoute.page,
    ),
    AutoRoute(
      path: '/register',
      page: RegisterAccountRoute.page,
    ),
    AutoRoute(
      path: '/home',
      page: HomeRoute.page,
      children: [
        AutoRoute(
            path: 'tree_setup',
            page: TreeRouter.page,
            children: [
              AutoRoute(path: '', page: TreeSetupRoute.page),
              AutoRoute(path: 'tree_manipulation', page: TreeManipulationRoute.page),
              AutoRoute(path: 'tree_storage', page: TreeStorageRoute.page),
            ]
        ),
        AutoRoute(
          path: 'user_profile',
          page: UserProfileRoute.page,
        ),
      ],
    ),
  ];
}

@RoutePage(name: 'TreeRouter')
class TreeSetupRouterPage extends AutoRouter {
  const TreeSetupRouterPage({super.key});
}
