import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Person {
  final String treeId;
  final String personId;

  ImageProvider image;
  String name;
  int age;
  String sex;
  DateTime birthDate;
  String birthPlace;
  DateTime deathDate;
  String nationality;

  String parent1Id;
  String parent2Id;

  Person({required this.treeId, String? personId, String? imageUrl, this.name = 'undefined', this.age = 0, this.sex = 'undefined', DateTime? birthDate, this.birthPlace = 'undefined', DateTime? deathDate, this.nationality = 'undefined', this.parent1Id = 'undefined', this.parent2Id = 'undefined'})
      : personId = personId ?? const Uuid().v4(), image = (imageUrl == null) ? const NetworkImage('https://firebasestorage.googleapis.com/v0/b/treedesigner-212f0.appspot.com/o/tree_members_images%2Fperson_default.jpeg?alt=media&token=b251d32f-96aa-4f4a-9fb5-2c9a9de714f1') : NetworkImage(imageUrl), birthDate = birthDate ?? DateTime.now(), deathDate = deathDate ?? DateTime.now();

  @override
  bool operator == (Object other) =>
      identical(this, other) ||
          other is Person &&
              runtimeType == other.runtimeType &&
              personId == other.personId;

  @override
  int get hashCode => personId.hashCode;

  bool noParents() {
    return (parent1Id == 'undefined') && (parent2Id == 'undefined');
  }

  bool onlyOneParent() {
    return ((parent1Id == 'undefined') && (parent2Id != 'undefined')) || ((parent1Id != 'undefined') && (parent2Id == 'undefined'));
  }

  bool isSource() {
    return personId == 'src';
  }

  void updateImage(ImageProvider image) {
    this.image = image;
  }

  void updateName(String name) {
    this.name = name;
  }

  void updateAge(int age) {
    if (age < 0 || age > 120) {
      throw Exception('Invalid age');
    }
    this.age = age;
  }

  void updateSex(String sex) {
    this.sex = sex;
  }

  void updateBirthDate(DateTime birthDate) {
    if (birthDate.isAfter(DateTime.now()) || birthDate.isBefore(DateTime(1000))) {
      throw Exception('Invalid birth date');
    }
    this.birthDate = birthDate;
  }

  void updateBirthPlace(String birthPlace) {
    this.birthPlace = birthPlace;
  }

  void updateDeathDate(DateTime deathDate) {
    if (deathDate.isAfter(DateTime.now()) || deathDate.isBefore(DateTime(1000))) {
      throw Exception('Invalid death date');
    }
    this.deathDate = deathDate;
  }

  void updateNationality(String nationality) {
    this.nationality = nationality;
  }

  void updateParent1Id(String parent1Id) {
    this.parent1Id = parent1Id;
  }

  void updateParent2Id(String parent2Id) {
    this.parent2Id = parent2Id;
  }

  Map<String, dynamic> toJson() => {
    'tree_id': treeId,
    'person_id': personId,
    'name': name,
    'age': age,
    'sex': sex,
    'birth_date': Timestamp.fromDate(birthDate),
    'birth_place': birthPlace,
    'death_date': Timestamp.fromDate(deathDate),
    'nationality': nationality,
    'parent1_id': parent1Id,
    'parent2_id': parent2Id,
  };

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      treeId: json['tree_id'],
      personId: json['person_id'],
      imageUrl: json['image_url'],
      name: json['name'],
      age: json['age'],
      sex: json['sex'],
      birthDate: json['birth_date'].toDate(),
      birthPlace: json['birth_place'],
      deathDate: json['death_date'].toDate(),
      nationality: json['nationality'],
      parent1Id: json['parent1_id'],
      parent2Id: json['parent2_id'],
    );
  }
}
