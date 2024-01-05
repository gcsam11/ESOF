// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i10;
import 'package:flutter/material.dart' as _i11;
import 'package:tree_designer/data_classes/ancestry_tree.dart' as _i12;
import 'package:tree_designer/data_classes/user_model.dart' as _i13;
import 'package:tree_designer/pages/home_page.dart' as _i6;
import 'package:tree_designer/pages/login_page.dart' as _i8;
import 'package:tree_designer/pages/register_page.dart' as _i2;
import 'package:tree_designer/pages/splash_screen.dart' as _i9;
import 'package:tree_designer/pages/tree_manipulation_page.dart' as _i3;
import 'package:tree_designer/pages/tree_setup_page.dart' as _i4;
import 'package:tree_designer/pages/tree_storage_page.dart' as _i5;
import 'package:tree_designer/pages/user_profile_page.dart' as _i7;
import 'package:tree_designer/routes/router.dart' as _i1;

abstract class $AppRouter extends _i10.RootStackRouter {
  $AppRouter({super.navigatorKey});

  @override
  final Map<String, _i10.PageFactory> pagesMap = {
    TreeRouter.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.TreeSetupRouterPage(),
      );
    },
    RegisterAccountRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i2.RegisterAccountPage(),
      );
    },
    TreeManipulationRoute.name: (routeData) {
      final args = routeData.argsAs<TreeManipulationRouteArgs>();
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i3.TreeManipulationPage(
          key: args.key,
          tree: args.tree,
        ),
      );
    },
    TreeSetupRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i4.TreeSetupPage(),
      );
    },
    TreeStorageRoute.name: (routeData) {
      final args = routeData.argsAs<TreeStorageRouteArgs>();
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i5.TreeStoragePage(
          key: args.key,
          treeIds: args.treeIds,
        ),
      );
    },
    HomeRoute.name: (routeData) {
      final args = routeData.argsAs<HomeRouteArgs>();
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i6.HomePage(
          key: args.key,
          user: args.user,
        ),
      );
    },
    UserProfileRoute.name: (routeData) {
      final args = routeData.argsAs<UserProfileRouteArgs>();
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: _i7.UserProfilePage(
          key: args.key,
          user: args.user,
        ),
      );
    },
    LoginRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i8.LoginPage(),
      );
    },
    SplashScreenRoute.name: (routeData) {
      return _i10.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i9.SplashScreen(),
      );
    },
  };
}

/// generated route for
/// [_i1.TreeSetupRouterPage]
class TreeRouter extends _i10.PageRouteInfo<void> {
  const TreeRouter({List<_i10.PageRouteInfo>? children})
      : super(
          TreeRouter.name,
          initialChildren: children,
        );

  static const String name = 'TreeRouter';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i2.RegisterAccountPage]
class RegisterAccountRoute extends _i10.PageRouteInfo<void> {
  const RegisterAccountRoute({List<_i10.PageRouteInfo>? children})
      : super(
          RegisterAccountRoute.name,
          initialChildren: children,
        );

  static const String name = 'RegisterAccountRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i3.TreeManipulationPage]
class TreeManipulationRoute
    extends _i10.PageRouteInfo<TreeManipulationRouteArgs> {
  TreeManipulationRoute({
    _i11.Key? key,
    required _i12.AncestryTree tree,
    List<_i10.PageRouteInfo>? children,
  }) : super(
          TreeManipulationRoute.name,
          args: TreeManipulationRouteArgs(
            key: key,
            tree: tree,
          ),
          initialChildren: children,
        );

  static const String name = 'TreeManipulationRoute';

  static const _i10.PageInfo<TreeManipulationRouteArgs> page =
      _i10.PageInfo<TreeManipulationRouteArgs>(name);
}

class TreeManipulationRouteArgs {
  const TreeManipulationRouteArgs({
    this.key,
    required this.tree,
  });

  final _i11.Key? key;

  final _i12.AncestryTree tree;

  @override
  String toString() {
    return 'TreeManipulationRouteArgs{key: $key, tree: $tree}';
  }
}

/// generated route for
/// [_i4.TreeSetupPage]
class TreeSetupRoute extends _i10.PageRouteInfo<void> {
  const TreeSetupRoute({List<_i10.PageRouteInfo>? children})
      : super(
          TreeSetupRoute.name,
          initialChildren: children,
        );

  static const String name = 'TreeSetupRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i5.TreeStoragePage]
class TreeStorageRoute extends _i10.PageRouteInfo<TreeStorageRouteArgs> {
  TreeStorageRoute({
    _i11.Key? key,
    required List<String> treeIds,
    List<_i10.PageRouteInfo>? children,
  }) : super(
          TreeStorageRoute.name,
          args: TreeStorageRouteArgs(
            key: key,
            treeIds: treeIds,
          ),
          initialChildren: children,
        );

  static const String name = 'TreeStorageRoute';

  static const _i10.PageInfo<TreeStorageRouteArgs> page =
      _i10.PageInfo<TreeStorageRouteArgs>(name);
}

class TreeStorageRouteArgs {
  const TreeStorageRouteArgs({
    this.key,
    required this.treeIds,
  });

  final _i11.Key? key;

  final List<String> treeIds;

  @override
  String toString() {
    return 'TreeStorageRouteArgs{key: $key, treeIds: $treeIds}';
  }
}

/// generated route for
/// [_i6.HomePage]
class HomeRoute extends _i10.PageRouteInfo<HomeRouteArgs> {
  HomeRoute({
    _i11.Key? key,
    required _i13.UserModel user,
    List<_i10.PageRouteInfo>? children,
  }) : super(
          HomeRoute.name,
          args: HomeRouteArgs(
            key: key,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'HomeRoute';

  static const _i10.PageInfo<HomeRouteArgs> page =
      _i10.PageInfo<HomeRouteArgs>(name);
}

class HomeRouteArgs {
  const HomeRouteArgs({
    this.key,
    required this.user,
  });

  final _i11.Key? key;

  final _i13.UserModel user;

  @override
  String toString() {
    return 'HomeRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [_i7.UserProfilePage]
class UserProfileRoute extends _i10.PageRouteInfo<UserProfileRouteArgs> {
  UserProfileRoute({
    _i11.Key? key,
    required _i13.UserModel user,
    List<_i10.PageRouteInfo>? children,
  }) : super(
          UserProfileRoute.name,
          args: UserProfileRouteArgs(
            key: key,
            user: user,
          ),
          initialChildren: children,
        );

  static const String name = 'UserProfileRoute';

  static const _i10.PageInfo<UserProfileRouteArgs> page =
      _i10.PageInfo<UserProfileRouteArgs>(name);
}

class UserProfileRouteArgs {
  const UserProfileRouteArgs({
    this.key,
    required this.user,
  });

  final _i11.Key? key;

  final _i13.UserModel user;

  @override
  String toString() {
    return 'UserProfileRouteArgs{key: $key, user: $user}';
  }
}

/// generated route for
/// [_i8.LoginPage]
class LoginRoute extends _i10.PageRouteInfo<void> {
  const LoginRoute({List<_i10.PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}

/// generated route for
/// [_i9.SplashScreen]
class SplashScreenRoute extends _i10.PageRouteInfo<void> {
  const SplashScreenRoute({List<_i10.PageRouteInfo>? children})
      : super(
          SplashScreenRoute.name,
          initialChildren: children,
        );

  static const String name = 'SplashScreenRoute';

  static const _i10.PageInfo<void> page = _i10.PageInfo<void>(name);
}
