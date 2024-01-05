import 'package:flutter/material.dart';
import 'package:graphview/GraphView.dart';
import 'package:tree_designer/firebase/firestore.dart';

import '../data_classes/ancestry_tree.dart';
import 'aux_tree_widgets.dart';
import '../data_classes/person.dart';

class AncestryTreeWidget extends StatefulWidget {
  final AncestryTree ancestryTree;
  
  const AncestryTreeWidget({super.key, required this.ancestryTree});

  @override
  State<AncestryTreeWidget> createState() => _AncestryTreeWidgetState();
}

class _AncestryTreeWidgetState extends State<AncestryTreeWidget> {
  late final AncestryTree _ancestryTree;

  @override
  void initState() {
    super.initState();
    _ancestryTree = widget.ancestryTree;
  }

  void addParentsToTree (Node node, Person currPerson) {
    final Person parent = Person(treeId: _ancestryTree.treeId);
    setState(() {
      _ancestryTree.addParent(node, currPerson, parent);
    });
    FirestoreUtils.addParentToDatabase(_ancestryTree.treeId, currPerson.personId, parent);
  }

  void removeAncestorFromTree (Node node, Person currPerson) {
    final Person predecessor = _ancestryTree.graph.predecessorsOf(node).first.key?.value;
    setState(() {
      _ancestryTree.removeParent(node, currPerson, predecessor);
    });
    FirestoreUtils.removeParentFromDatabase(_ancestryTree.treeId, currPerson.personId, predecessor.personId);
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      constrained: false,
      minScale: 0.5,
      maxScale: 2,
      boundaryMargin: const EdgeInsets.symmetric(horizontal: 350, vertical: 600),
      child: GraphView(
        graph: _ancestryTree.graph,
        algorithm: BuchheimWalkerAlgorithm(_ancestryTree.builder, TreeEdgeRenderer(_ancestryTree.builder)),
        paint: Paint()
          ..color = Colors.black
          ..strokeWidth = 2.5
          ..style = PaintingStyle.stroke,
        builder: (Node node) {
          Person person = node.key?.value as Person;
          return NodeWidget(
            person: person,
            addCallback: () {
              addParentsToTree(node, person);
            },
            removeCallback: () {
              removeAncestorFromTree(node, person);
            },
            updateCallback: () {
              setState(() {});
            },
          );
        },
      ),
    );
  }
}