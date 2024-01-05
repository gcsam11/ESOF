import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tree_designer/data_classes/user_model.dart';
import 'package:tree_designer/firebase/auth_service.dart';

import '../firebase/firestore.dart';
import '../routes/router.gr.dart';

@RoutePage(name: 'SplashScreenRoute')
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = AuthService.isUserLoggedIn();

    if (isLoggedIn) {
      return FutureBuilder<UserModel>(
        future: FirestoreUtils.loadCurrentUserFromDatabase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data != null) {
              context.router.replace(HomeRoute(user: snapshot.data!));
            } else {
              context.router.replace(const LoginRoute());
            }
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      );
    } else {
      context.router.replace(const LoginRoute());
      return const SizedBox();
    }
  }
}
