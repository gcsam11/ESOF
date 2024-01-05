import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:tree_designer/data_classes/ancestry_tree.dart';
import 'package:tree_designer/data_classes/person.dart';
import 'package:graphview/GraphView.dart';
import 'package:tree_designer/data_classes/user_model.dart';

class FirestoreUtils {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static String? currUserId;
  
  static getLatestUserId() {
    currUserId = FirebaseAuth.instance.currentUser?.uid;
  }

  static Future<void> addNewUserToDatabase(UserCredential userCredentials) async {
    final UserModel newUser;
    final uid = userCredentials.user?.uid;
    final email = userCredentials.user?.email;

    if (uid != null && email != null) {
      newUser = UserModel(email: email);

      DocumentReference userDocRef = _firestore.collection('users').doc(uid);
      await userDocRef.set(newUser.toJson());
    } else {
      debugPrint('User id or Email are null');
    }
  }

  static Future<UserModel> loadCurrentUserFromDatabase() async {
    getLatestUserId();
    final DocumentSnapshot userDocSnapshot = await _firestore.collection('users').doc(currUserId).get();

    final Map<String, dynamic> userData = (userDocSnapshot.data() as Map<String, dynamic>);

    return UserModel.fromJson(userData);
  }

  static Future<void> updateProfilePicInDatabase(String url) async {
    final DocumentReference userDoc = _firestore.collection('users').doc(currUserId);
    await userDoc.update({'profile_pic_url': url});
  }

  static Future<void> updateUserInfoInDatabase(String name, String bio) async {
    final DocumentReference userDoc = _firestore.collection('users').doc(currUserId);
    await userDoc.update({'name': name, 'bio': bio});
  }

  static Future<void> initTreeInDatabase(String treeId) async {
    final Person src = Person(treeId: treeId, personId: 'src');

    final DocumentReference treeRef = _firestore.collection('users').doc(currUserId).collection('trees').doc(treeId);

    await treeRef.set({'tree_exists': true});

    final DocumentReference srcRef = treeRef.collection('members').doc('src');
    
    await srcRef.set(src.toJson());
  }

  static Future<void> loadTreeIdsFromDatabase(List<String> treeIds) async {
    final CollectionReference collectRef = _firestore.collection('users').doc(currUserId).collection('trees');
    final QuerySnapshot snapshot = await collectRef.get();

    treeIds.addAll(snapshot.docs.map((doc) => doc.id).toList());
  }

  static Future<bool> treeWithSameIdAlreadyExists(String treeId) async {
    final DocumentSnapshot treeDocSnapshot = await _firestore.collection('users').doc(currUserId).collection('trees').doc(treeId).get();

    return treeDocSnapshot.exists;
  }

  static Future<void> removeTreeFromDatabase(String treeId) async {
    final DocumentReference treeDocRef = _firestore.collection('users').doc(currUserId).collection('trees').doc(treeId);
    final CollectionReference membersCollection = treeDocRef.collection('members');

    final QuerySnapshot membersQuerySnapshot = await membersCollection.get();
    for (final memberDoc in membersQuerySnapshot.docs) {
      await memberDoc.reference.delete();
    }
    await treeDocRef.delete();
  }

  static Future<void> loadTreeData(AncestryTree tree) async {
    String treeId = tree.treeId;
    Graph graph = tree.graph;

    final DocumentReference treeDocRef = _firestore.collection('users').doc(currUserId).collection('trees').doc(treeId);
    final DocumentSnapshot treeSnapshot = await treeDocRef.get();
    final Map<String, dynamic> treeData = (treeSnapshot.data() as Map<String, dynamic>);

    tree.setSiblingSeparation(treeData['sibling_separation']);
    tree.setLevelSeparation(treeData['level_separation']);
    tree.setSubtreeSeparation(treeData['subtree_separation']);
    tree.setOrientation(treeData['orientation']);

    final Map<String, Person> membersById = {};
    final QuerySnapshot membersQuery = await treeDocRef.collection('members').get();

    for (final memberDoc in membersQuery.docs) {
      final Map<String, dynamic> memberData = (memberDoc.data() as Map<String, dynamic>);

      final Person member = Person.fromJson(memberData);

      membersById[memberDoc.id] = member;
    }

    void addAncestorsRecursively(Person person) {
      final String parent1Id = person.parent1Id;
      final String parent2Id = person.parent2Id;

      if(parent1Id != 'undefined') {
        final Person? parent1 = membersById[parent1Id];
        graph.addEdge(Node.Id(person), Node.Id(parent1));
        addAncestorsRecursively(parent1!);
      }
      if(parent2Id != 'undefined') {
        final Person? parent2 = membersById[parent2Id];
        graph.addEdge(Node.Id(person), Node.Id(parent2));
        addAncestorsRecursively(parent2!);
      }
    }

    graph.removeNode(graph.getNodeAtPosition(0));
    Person? src = membersById['src'];
    graph.addNode(Node.Id(src));

    addAncestorsRecursively(src!);
  }

  static Future<void> updateTreeCustomizationInDatabase(String treeId, int siblingSeparation, int levelSeparation, int subtreeSeparation, int orientation) async {
    DocumentReference treeRef = _firestore.collection('users').doc(currUserId).collection('trees').doc(treeId);
    await treeRef.update({'sibling_separation': siblingSeparation});
    await treeRef.update({'level_separation': levelSeparation});
    await treeRef.update({'subtree_separation': subtreeSeparation});
    await treeRef.update({'orientation': orientation});
  }

  static Future<void> addParentToDatabase(String treeId, String currPersonId, Person parent) async {
    final DocumentReference currPersonRef = _firestore.collection('users').doc(currUserId).collection('trees').doc(treeId).collection('members').doc(currPersonId);
    final DocumentReference parentRef = _firestore.collection('users').doc(currUserId).collection('trees').doc(treeId).collection('members').doc(parent.personId);

    final DocumentSnapshot currPersonSnapshot = await currPersonRef.get();
    final Map<String, dynamic> currPersonData = (currPersonSnapshot.data() as Map<String, dynamic>);

    if (currPersonData['parent1_id'] == 'undefined') {
      updateParent1IdInDatabase(currPersonId, treeId, parent.personId);
    } else if (currPersonData['parent2_id'] == 'undefined') {
      updateParent2IdInDatabase(currPersonId, treeId, parent.personId);
    }

    await parentRef.set(parent.toJson());
  }

  static Future<void> removeParentFromDatabase(String treeId, String currPersonId, String predecessorId) async {
    final DocumentReference currPersonRef = _firestore.collection('users').doc(currUserId).collection('trees').doc(treeId).collection('members').doc(currPersonId);
    final DocumentReference predecessorRef = _firestore.collection('users').doc(currUserId).collection('trees').doc(treeId).collection('members').doc(predecessorId);

    final DocumentSnapshot predecessorSnapshot = await predecessorRef.get();
    final Map<String, dynamic> predecessorData = (predecessorSnapshot.data() as Map<String, dynamic>);

    if (currPersonId == predecessorData['parent1_id']) {
      updateParent1IdInDatabase(predecessorId, treeId, 'undefined');
    }
    else if (currPersonId == predecessorData['parent2_id']) {
      updateParent2IdInDatabase(predecessorId, treeId, 'undefined');
    }

    await currPersonRef.delete();
  }

  static Future<void> updateImageURLInDatabase(String personId, String treeId, String url) async {
    DocumentReference personRef = _firestore.collection('users').doc(currUserId).collection('trees').doc(treeId).collection('members').doc(personId);
    await personRef.update({'image_url': url});
  }

  static Future<void> updateNameInDatabase(String personId, String treeId, String name) async {
    DocumentReference personRef = _firestore.collection('users').doc(currUserId).collection('trees').doc(treeId).collection('members').doc(personId);
    await personRef.update({'name': name});
  }

  static Future<void> updateAgeInDatabase(String personId, String treeId, int age) async {
    DocumentReference personRef = _firestore.collection('users').doc(currUserId).collection('trees').doc(treeId).collection('members').doc(personId);
    await personRef.update({'age': age});
  }

  static Future<void> updateSexInDatabase(String personId, String treeId, String sex) async {
    DocumentReference personRef = _firestore.collection('users').doc(currUserId).collection('trees').doc(treeId).collection('members').doc(personId);
    await personRef.update({'sex': sex});
  }

  static Future<void> updateBirthDateInDatabase(String personId, String treeId, DateTime birthDate) async {
    DocumentReference personRef = _firestore.collection('users').doc(currUserId).collection('trees').doc(treeId).collection('members').doc(personId);
    await personRef.update({'birth_date': Timestamp.fromDate(birthDate)});
  }

  static Future<void> updateBirthPlaceInDatabase(String personId, String treeId, String birthPlace) async {
    DocumentReference personRef = _firestore.collection('users').doc(currUserId).collection('trees').doc(treeId).collection('members').doc(personId);
    await personRef.update({'birth_place': birthPlace});
  }

  static Future<void> updateDeathDateInDatabase(String personId, String treeId, DateTime deathDate) async {
    DocumentReference personRef = _firestore.collection('users').doc(currUserId).collection('trees').doc(treeId).collection('members').doc(personId);
    await personRef.update({'death_date': Timestamp.fromDate(deathDate)});
  }

  static Future<void> updateNationalityInDatabase(String personId, String treeId, String nationality) async {
    DocumentReference personRef = _firestore.collection('users').doc(currUserId).collection('trees').doc(treeId).collection('members').doc(personId);
    await personRef.update({'nationality': nationality});
  }

  static Future<void> updateParent1IdInDatabase(String personId, String treeId, String parent1Id) async {
    DocumentReference personRef = _firestore.collection('users').doc(currUserId).collection('trees').doc(treeId).collection('members').doc(personId);
    await personRef.update({'parent1_id': parent1Id});
  }

  static Future<void> updateParent2IdInDatabase(String personId, String treeId, String parent2Id) async {
    DocumentReference personRef = _firestore.collection('users').doc(currUserId).collection('trees').doc(treeId).collection('members').doc(personId);
    await personRef.update({'parent2_id': parent2Id});
  }
}
