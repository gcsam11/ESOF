import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tree_designer/data_classes/user_model.dart';
import 'package:tree_designer/routes/router.gr.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  final UserModel user;

  const HomePage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      resizeToAvoidBottomInset: false,
      appBarBuilder: (_, tabsRouter) {
        return AppBar(
          backgroundColor: Colors.indigo,
          title: const Text('Tree Designer'),
          centerTitle: true,
          leading: const AutoLeadingButton(),
        );
      },
      routes: [
        const TreeRouter(),
        UserProfileRoute(user: user),
      ],
      bottomNavigationBuilder: (_, tabsRouter) {
        return SalomonBottomBar(
          backgroundColor: Colors.indigo,
          margin: const EdgeInsets.all(5),
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          items: [
            SalomonBottomBarItem(
              selectedColor: Colors.amberAccent,
              icon: const Icon(
                Icons.nature_outlined,
                size: 30,
              ),
              title: const Text('Trees'),
            ),
            SalomonBottomBarItem(
              selectedColor: Colors.white,
              icon: const Icon(
                Icons.person_outline_rounded,
                size: 30,
              ),
              title: const Text('Profile'),
            ),
          ],
        );
      },
    );
  }
}
