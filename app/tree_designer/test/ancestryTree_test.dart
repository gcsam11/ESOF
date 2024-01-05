import 'package:flutter_test/flutter_test.dart';
import 'package:graphview/GraphView.dart';
import 'package:tree_designer/data_classes/ancestry_tree.dart';
import 'package:tree_designer/data_classes/person.dart';

void main() {

  test('Test AncestryTree creation method', () {
    final ancestryTree = AncestryTree(treeId: '1234');
    expect(ancestryTree.graph.nodeCount(), equals(1));
  });

  test('Test AncestryTree removeParent method', () {
    final ancestryTree = AncestryTree(treeId: '123456');
    final node = ancestryTree.graph.nodes.first;
    final predecessor = ancestryTree.graph.nodes.first.key!.value as Person;
    final currPerson = Person(treeId: '123456', personId: '111111', name: 'John', age: 56, sex: 'male', birthDate: DateTime(1964,1,3), birthPlace: 'London', deathDate: DateTime(2010,5,14), nationality: 'English');
    ancestryTree.addParent(node, predecessor, currPerson);
    expect(ancestryTree.graph.nodeCount(), equals(2));
    ancestryTree.removeParent(Node.Id(currPerson), currPerson, predecessor);
    expect(ancestryTree.graph.nodeCount(), equals(1));
  });

  test('Test AncestryTree addParents method', () {
    final ancestryTree = AncestryTree(treeId: '12345');
    final node = ancestryTree.graph.nodes.first;
    final currPerson = ancestryTree.graph.nodes.first.key!.value as Person;
    final parent = Person(treeId: '12345', personId: '11111', name: 'John', age: 56, sex: 'male', birthDate: DateTime(1964,1,3), birthPlace: 'London', deathDate: DateTime(2010,5,14), nationality: 'English');
    ancestryTree.addParent(node, currPerson, parent);
    expect(ancestryTree.graph.nodeCount(), equals(2));
  });

  test('Test AncestryTree numOfParents method', () {
    final ancestryTree = AncestryTree(treeId: '1234567');
    final node = ancestryTree.graph.nodes.first;
    expect(ancestryTree.numOfParentNodes(node), equals(0));
  });
  /*
  test('Test AncestryTree removeLeafAncestor method when node is not a leaf', () {
    final ancestryTree = AncestryTree();
    ancestryTree.init();
    final node = ancestryTree.graph.nodes.first;
    ancestryTree.addParents(node);
    expect(() => ancestryTree.removeLeafAncestor(node), throwsException);
  });

  test('Test AncestryTree removeLeafAncestor method when node is not in graph', () {
    final ancestryTree = AncestryTree();
    ancestryTree.init();
    final node = Node.Id(Person());
    expect(() => ancestryTree.removeLeafAncestor(node), throwsException);
  });

  test('Test AncestryTree removeLeafAncestor method when node is source', () {
    final ancestryTree = AncestryTree();
    ancestryTree.init();
    final node = ancestryTree.graph.nodes.first;
    expect(() => ancestryTree.removeLeafAncestor(node), throwsException);
  });

  test('Test AncestryTree addParents method throws exception when node has 2 parents', () {
    final ancestryTree = AncestryTree();
    ancestryTree.init();
    final node = ancestryTree.graph.nodes.first;
    ancestryTree.addParents(node);
    expect(() => ancestryTree.addParents(node), throwsException);
  });

  test('Test AncestryTree addParents method adds 1 parent when node has 1 parent', () {
    final ancestryTree = AncestryTree();
    ancestryTree.init();
    final node = ancestryTree.graph.nodes.first;
    final parent1 = Node.Id(Person(noParents: true));
    ancestryTree.graph.addEdge(node, parent1);
    ancestryTree.addParents(node);
    expect(ancestryTree.graph.successorsOf(node).length, equals(2));
  });

  test('Test AncestryTree addParents method adds 2 parents when node has no parents', () {
    final ancestryTree = AncestryTree();
    ancestryTree.init();
    final node = ancestryTree.graph.nodes.first;
    ancestryTree.addParents(node);
    expect(ancestryTree.graph.successorsOf(node).length, equals(2));
  });

  test('Test AncestryTree addParents method when node is not in graph', () {
    final ancestryTree = AncestryTree();
    ancestryTree.init();
    final node = Node.Id(Person());
    expect(() => ancestryTree.addParents(node), throwsException);
  });

  test('Test AncestryTree numOfParentsLeft method when node is not in graph', () {
    final ancestryTree = AncestryTree();
    ancestryTree.init();
    final node = Node.Id(Person());
    expect(() => ancestryTree.numOfParentNodes(node), throwsException);
  });

  test('Test AncestryTree addParents method updates noParents property', () {
    final ancestryTree = AncestryTree();
    ancestryTree.init();
    final node = ancestryTree.graph.nodes.first;
    final person = node.key?.value;
    expect(person.noParents, isTrue);
    ancestryTree.addParents(node);
    expect(person.noParents, isFalse);
    final parent1 = ancestryTree.graph.successorsOf(node).first;
    final parent2 = ancestryTree.graph.successorsOf(node).last;
    expect(parent1.key?.value.noParents, isTrue);
    expect(parent2.key?.value.noParents, isTrue);
  });

  test('Test AncestryTree init method sets isSource property', () {
    final ancestryTree = AncestryTree();
    ancestryTree.init();
    final node = ancestryTree.graph.nodes.first;
    final person = node.key?.value;
    expect(person.isSource, isTrue);
  });

  test('Test AncestryTree removeLeafAncestor method updates onlyOneParent and noParents properties', () {
    final ancestryTree = AncestryTree();
    ancestryTree.init();
    final node = ancestryTree.graph.nodes.first;
    final person = node.key?.value;
    ancestryTree.addParents(node);
    final parent1 = ancestryTree.graph.successorsOf(node).first;
    ancestryTree.removeLeafAncestor(parent1);
    expect(person.onlyOneParent, isTrue);
    expect(person.noParents, isFalse);
    final parent2 = ancestryTree.graph.successorsOf(node).last;
    ancestryTree.removeLeafAncestor(parent2);
    expect(person.onlyOneParent, isFalse);
    expect(person.noParents, isTrue);
  });
   */
}