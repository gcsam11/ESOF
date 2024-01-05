import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:tree_designer/firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:tree_designer/components/tree_tile.dart';

import '../data_classes/ancestry_tree.dart';
import '../routes/router.gr.dart';

@RoutePage()
class TreeStoragePage extends StatefulWidget {
  final List<String> treeIds;
  const TreeStoragePage({super.key, required this.treeIds});

  @override
  State<TreeStoragePage> createState() => _TreeStoragePageState();
}

class _TreeStoragePageState extends State<TreeStoragePage> {
  late List<String> _treeIds;
  late List<Color> _colors;
  bool loading = false;

  @override
  initState() {
    super.initState();
    _treeIds = List<String>.from(widget.treeIds);
    _colors = List.generate(_treeIds.length,
            (index) => Color((Random().nextDouble() * 0xFFFFFF).toInt())
                .withOpacity(1.0));
  }

  void _removeItem(int index) {
    String treeId = _treeIds[index];
    setState(() {
      _treeIds.removeAt(index);
      _colors.removeAt(index);
    });
    FirestoreUtils.removeTreeFromDatabase(treeId);
  }
  
  void loadTreeAndSwitchRoute(String treeId) {
    setState(() { loading = true; });

    AncestryTree tree = AncestryTree(treeId: treeId);

    FirestoreUtils.loadTreeData(tree).then((value) {
      setState(() { loading = false; });
      context.pushRoute(TreeManipulationRoute(tree: tree));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading ? const Center(child: CircularProgressIndicator()) :
      _treeIds.isEmpty ? const Center(child: Text("You haven't created any trees yet", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))) : GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, crossAxisSpacing: 10, mainAxisSpacing: 10),
        itemCount: _treeIds.length,
        padding: const EdgeInsets.all(10),
        itemBuilder: (context, index) {
          return TreeTile(
            treeId: _treeIds[index],
            color: _colors[index],
            deleteCallback: () => _removeItem(index),
            loadCallback: loadTreeAndSwitchRoute,
          );
        },
      ),
    );
  }
}
