import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tree_designer/components/ancestry_tree_widget.dart';
import 'package:tree_designer/data_classes/ancestry_tree.dart';
import 'package:tree_designer/firebase/firestore.dart';

import '../components/tree_customization_widget.dart';

@RoutePage()
class TreeManipulationPage extends StatefulWidget {
  final AncestryTree tree;

  const TreeManipulationPage({super.key, required this.tree});

  @override
  State<TreeManipulationPage> createState() => _TreeManipulationPageState();
}

class _TreeManipulationPageState extends State<TreeManipulationPage> {
  late final AncestryTree _tree;
  bool _portrait = true;

  @override
  void initState() {
    super.initState();
    _tree = widget.tree;
  }

  void updateSiblingSeparation(int value) {
    setState(() {
      _tree.setSiblingSeparation(value);
    });
  }

  void updateLevelSeparation(int value) {
    setState(() {
      _tree.setLevelSeparation(value);
    });
  }

  void updateSubtreeSeparation(int value) {
    setState(() {
      _tree.setSubtreeSeparation(value);
    });
  }

  void updateTreeOrientation(int value) {
    setState(() {
      _tree.setOrientation(value);
    });
  }

  void changeOrientation() {
    setState(() {
      _portrait = !_portrait;
      if (_portrait) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
        ]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AncestryTreeWidget(
            ancestryTree: _tree,
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Row(
              children: [
                TreeCustomizationWidget(
                  levelSeparationCallBack: updateLevelSeparation,
                  siblingSeparationCallBack: updateSiblingSeparation,
                  subtreeSeparationCallBack: updateSubtreeSeparation,
                  initialLevelSeparation: _tree.getLevelSeparation(),
                  initialSiblingSeparation: _tree.getSiblingSeparation(),
                  initialSubtreeSeparation: _tree.getSubtreeSeparation(),
                  orientationCallBack: updateTreeOrientation,

                ),
                const SizedBox(width: 20),
                FloatingActionButton(
                  heroTag: 'orientation',
                  mini: true,
                  backgroundColor: Colors.lightBlue,
                  onPressed: () {
                    changeOrientation();
                  },
                  child: const Icon(Icons.change_circle_outlined),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    FirestoreUtils.updateTreeCustomizationInDatabase(_tree.treeId, _tree.getSiblingSeparation(), _tree.getLevelSeparation(), _tree.getSubtreeSeparation(), _tree.getOrientation());
    super.dispose();
  }
}
