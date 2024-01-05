import 'package:graphview/GraphView.dart';
import 'package:tree_designer/data_classes/person.dart';

class AncestryTree {
  final String treeId;
  final Graph graph;
  final BuchheimWalkerConfiguration builder;

  AncestryTree({required this.treeId}) : graph = Graph()..isTree = true,
        builder = BuchheimWalkerConfiguration()
        ..siblingSeparation = 85
        ..levelSeparation = 125
        ..subtreeSeparation = 10
        ..orientation = BuchheimWalkerConfiguration.ORIENTATION_BOTTOM_TOP { initNewTree(); }

  int getSiblingSeparation() {
    return builder.siblingSeparation;
  }

  void setSiblingSeparation(int? siblingSeparation) {
    if (siblingSeparation != null) {
      builder.siblingSeparation = siblingSeparation;
    }
  }

  int getLevelSeparation() {
    return builder.levelSeparation;
  }

  void setLevelSeparation(int? levelSeparation) {
    if (levelSeparation != null) {
      builder.levelSeparation = levelSeparation;
    }
  }

  int getSubtreeSeparation() {
    return builder.subtreeSeparation;
  }

  void setSubtreeSeparation(int? subtreeSeparation) {
    if (subtreeSeparation != null) {
      builder.subtreeSeparation = subtreeSeparation;
    }
  }

  int getOrientation() {
    return builder.orientation;
  }

  void setOrientation(int? orientation) {
    if (orientation != null) {
      builder.orientation = orientation;
    }
  }

  void initNewTree() {
    Person src = Person(treeId: treeId, personId: 'src');
    graph.addNode(Node.Id(src));
  }

  void addParent(Node node, Person currPerson, Person parent) {
    if(numOfParentNodes(node) > 1) throw Exception('Node already has parents');
    if(!graph.contains(node: node)) throw Exception('Node is not part of the graph');

    if (currPerson.parent1Id == 'undefined') {
      currPerson.updateParent1Id(parent.personId);
      graph.addEdge(node, Node.Id(parent));
    }
    else if (currPerson.parent2Id == 'undefined') {
      currPerson.updateParent2Id(parent.personId);
      graph.addEdge(node, Node.Id(parent));
    }
  }

  void removeParent(Node node, Person currPerson, Person predecessor) {
    if(numOfParentNodes(node) > 0) throw Exception('Not a leaf node');
    if(!graph.contains(node: node)) throw Exception('Node is not part of the tree');

    if(currPerson.isSource()) throw Exception('Person is the only one left in the tree');

    if (currPerson.personId == predecessor.parent1Id) {
      predecessor.updateParent1Id('undefined');
    }
    else if (currPerson.personId == predecessor.parent2Id) {
      predecessor.updateParent2Id('undefined');
    }

    graph.removeNode(node);
  }

  int numOfParentNodes(Node node) {
    if(!graph.contains(node: node)) throw Exception('Node is not part of the graph');
    return graph.successorsOf(node).length;
  }
}
