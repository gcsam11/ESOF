import 'package:flutter/material.dart';

import 'aux_tree_widgets.dart';

class TreeCustomizationWidget extends StatelessWidget {
  final int initialLevelSeparation;
  final Function(int value) levelSeparationCallBack;
  final int initialSiblingSeparation;
  final Function(int value) siblingSeparationCallBack;
  final int initialSubtreeSeparation;
  final Function(int value) subtreeSeparationCallBack;
  final Function(int value) orientationCallBack;

  const TreeCustomizationWidget({Key? key, required this.levelSeparationCallBack, required this.siblingSeparationCallBack, required this.subtreeSeparationCallBack, required this.initialLevelSeparation, required this.initialSiblingSeparation, required this.initialSubtreeSeparation, required this.orientationCallBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      shape: const CircleBorder(),
      child: PopupMenuButton(
        offset: const Offset(70, 0),
        padding: EdgeInsets.zero,
        position: PopupMenuPosition.under,
        constraints: const BoxConstraints.tightFor(width: 180),
        child: Container(
          height: 40,
          width: 40,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.orange,
          ),
          child: const Icon(Icons.brush_rounded, color: Colors.white),
        ),
        itemBuilder: (BuildContext context) => <PopupMenuEntry>[
          PopupMenuItem(
            height: 0,
            padding: EdgeInsets.zero,
            child: TreeSeparationController(
                initialSliderValue: initialLevelSeparation.toDouble(),
                updateGraphCallBack: levelSeparationCallBack,
                title: 'Level Separation'
            ),
          ),
          PopupMenuItem(
            height: 0,
            padding: EdgeInsets.zero,
            child: TreeSeparationController(
                initialSliderValue: initialSiblingSeparation.toDouble(),
                updateGraphCallBack: siblingSeparationCallBack,
                title: 'Sibling Separation'
            ),
          ),
          PopupMenuItem(
            height: 0,
            padding: EdgeInsets.zero,
            child: TreeSeparationController(
                initialSliderValue: initialSubtreeSeparation.toDouble(),
                updateGraphCallBack: subtreeSeparationCallBack,
                title: 'Subtree Separation'
            ),
          ),
          PopupMenuItem(
            height: 0,
            padding: EdgeInsets.zero,
            child: TreeOrientationController(
              updateOrientationCallback: orientationCallBack,
            ),
          ),
        ],
      ),
    );
  }
}