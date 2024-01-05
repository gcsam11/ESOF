import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tree_designer/data_classes/ancestry_tree.dart';
import 'package:tree_designer/firebase/firestore.dart';
import 'package:tree_designer/routes/router.gr.dart';

@RoutePage()
class TreeSetupPage extends StatelessWidget {
  const TreeSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    TextEditingController controller = TextEditingController();
                    String? errorMessage;
                    return StatefulBuilder(
                      builder: (context, setState) {
                        return AlertDialog(
                          title: const Text('Give a name to your tree'),
                          content: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              hintText: "Write name here",
                              errorText: errorMessage,
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('CANCEL'),
                              onPressed: () {
                                context.popRoute();
                              },
                            ),
                            TextButton(
                              child: const Text('OK'),
                              onPressed: () async {
                                final String treeId = controller.text;
                                final bool treeExists = await FirestoreUtils.treeWithSameIdAlreadyExists(treeId);

                                if (!treeExists && context.mounted) {
                                  AncestryTree tree = AncestryTree(treeId: treeId);
                                  FirestoreUtils.initTreeInDatabase(treeId);

                                  context.popRoute();
                                  context.router.push(TreeManipulationRoute(tree: tree));
                                } else {
                                  setState(() {
                                    errorMessage = 'A tree with that name already exists';
                                  });
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                );
              },
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.nature_outlined,
                    size: 120,
                    color: Colors.lightBlue,
                  ),
                  Text(
                    'Create Tree',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () async {
                List<String> treeIds = [];
                await FirestoreUtils.loadTreeIdsFromDatabase(treeIds);

                if (context.mounted) {
                  context.router.push(TreeStorageRoute(treeIds: treeIds));
                }
              },
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.drive_folder_upload_outlined,
                    size: 120,
                    color: Colors.orange,
                  ),
                  Text(
                    'Open Tree',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}