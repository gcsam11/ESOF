import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:intl/intl.dart';
import 'package:tree_designer/firebase/firestore.dart';

import '../data_classes/person.dart';
import '../firebase/firebase_storage.dart';

String capitalize(String s) {
  if (s.isEmpty) {
    return s;
  }
  return s[0].toUpperCase() + s.substring(1);
}

class PersonWindow extends StatefulWidget {
  final Person person;
  final VoidCallback onDialogClose;

  const PersonWindow({super.key, required this.person, required this.onDialogClose});

  @override
  State<PersonWindow> createState() => _PersonWindowState();
}

class _PersonWindowState extends State<PersonWindow> {
  late Person _person;

  @override
  void initState() {
    super.initState();
    _person = widget.person;
  }

  Future<void> pickProfileImage() async {
    final results = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['png', 'jpg', 'jpeg'],
    );

    if (results != null) {
      final path = results.files.single.path!;
      final fileName = results.files.single.name;

      setState(() {
        _person.image = FileImage(File(path));
      });

      bool fileAlreadyExists = await FirebaseStorageUtils.fileExists('tree_members_images/$fileName');
      if(!fileAlreadyExists) {
        FirebaseStorageUtils.uploadFile('tree_members_images/$fileName', path);
      }

      String url = await FirebaseStorageUtils.getDownloadURL('tree_members_images/$fileName');
      FirestoreUtils.updateImageURLInDatabase(_person.personId, _person.treeId, url);
    }
  }

  Future<void> showNameDialog() async {
    final value = await showDialog(
        context: context,
        builder: (context) {
          TextEditingController controller = TextEditingController(text: _person.name);
          return AlertDialog(
            title: const Text('Name'),
            content: TextField(
              controller: controller,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, controller.text);
                },
                child: const Text('OK'),
              ),
            ],
          );
        }
    );

    if(value != null) {
      setState(() {
        _person.updateName(value);
      });
      FirestoreUtils.updateNameInDatabase(_person.personId, _person.treeId, value);
    }
  }

  Future<void> showAgeDialog() async {
    final value = await showDialog(
        context: context,
        builder: (context) {
          int chosenAge = _person.age;
          return AlertDialog(
            title: const Text('Age'),
            content: StatefulBuilder(
                builder: (context, setState) {
                  return NumberPicker(
                    minValue: 0,
                    maxValue: 120,
                    value: chosenAge,
                    onChanged: (value) => setState(() => chosenAge = value),
                  );
                }
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, chosenAge),
                child: const Text('OK'),
              ),
            ],
          );
        }
    );

    if(value != null) {
      setState(() {
        _person.updateAge(value);
      });
      FirestoreUtils.updateAgeInDatabase(_person.personId, _person.treeId, value);
    }
  }

  Future<void> showSexDialog() async {
    final value = await showDialog(
        context: context,
        builder: (context) {
          String? chosenSex = _person.sex;
          return AlertDialog(
            title: const Text('Sex'),
            content: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text('Male'),
                        leading: Radio<String>(
                          value: 'male',
                          groupValue: chosenSex,
                          onChanged: (value) {
                            setState(() {
                              chosenSex = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Female'),
                        leading: Radio<String>(
                          value: 'female',
                          groupValue: chosenSex,
                          onChanged: (value) {
                            setState(() {
                              chosenSex = value;
                            });
                          },
                        ),
                      ),
                    ],
                  );
                }
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, chosenSex),
                child: const Text('OK'),
              ),
            ],
          );
        }
    );

    if(value != null) {
      setState(() {
        _person.updateSex(value);
      });
      FirestoreUtils.updateSexInDatabase(_person.personId, _person.treeId, value);
    }
  }

  Future<void> showBirthDateDialog() async {
    final value = await showDialog(
        context: context,
        builder: (context) {
          return DatePickerDialog(
            initialDate: _person.birthDate,
            firstDate: DateTime(1000),
            lastDate: DateTime.now(),
          );
        }
    );

    if(value != null) {
      setState(() {
        _person.updateBirthDate(value);
      });
      FirestoreUtils.updateBirthDateInDatabase(_person.personId, _person.treeId, value);
    }
  }

  Future<void> showBirthPlaceDialog() async {
    final value = await showDialog(
        context: context,
        builder: (context) {
          TextEditingController controller = TextEditingController(text: _person.birthPlace);
          return AlertDialog(
            title: const Text('Birth Place'),
            content: TextField(
              controller: controller,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, controller.text);
                },
                child: const Text('OK'),
              ),
            ],
          );
        }
    );

    if(value != null) {
      setState(() {
        _person.updateBirthPlace(value);
      });
      FirestoreUtils.updateBirthPlaceInDatabase(_person.personId, _person.treeId, value);
    }
  }

  Future<void> showDeathDateDialog() async {
    final value = await showDialog(
        context: context,
        builder: (context) {
          return DatePickerDialog(
              initialDate: _person.deathDate,
              firstDate: DateTime(1000),
              lastDate: DateTime.now(),
          );
        }
    );

    if(value != null) {
      setState(() {
        _person.updateDeathDate(value);
      });
      FirestoreUtils.updateDeathDateInDatabase(_person.personId, _person.treeId, value);
    }
  }

  Future<void> showNationalityDialog() async {
    final value = await showDialog(
        context: context,
        builder: (context) {
          TextEditingController controller = TextEditingController(text: _person.nationality);
          return AlertDialog(
            title: const Text('Nationality'),
            content: TextField(
              controller: controller,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, controller.text);
                },
                child: const Text('OK'),
              ),
            ],
          );
        }
    );

    if(value != null) {
      setState(() {
        _person.updateNationality(value);
      });
      FirestoreUtils.updateNationalityInDatabase(_person.personId, _person.treeId, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(10),
      backgroundColor: const Color(0xFF424952),
      content: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ProfileImagePicker(profileImage: _person.image, pickProfileImageFunction: pickProfileImage),
                    const SizedBox(height: 25),
                    PersonFieldWidget(fieldTitle: 'Name', fieldContent: _person.name, showDialogFunction: showNameDialog),
                    const SizedBox(height: 25),
                    PersonFieldWidget(fieldTitle: 'Age', fieldContent: _person.age.toString(), showDialogFunction: showAgeDialog),
                    const SizedBox(height: 25),
                    PersonFieldWidget(fieldTitle: 'Sex', fieldContent: _person.sex, showDialogFunction: showSexDialog),
                    const SizedBox(height: 25),
                    PersonFieldWidget(fieldTitle: 'Birth Date', fieldContent: DateFormat.yMMMMd().format(_person.birthDate), showDialogFunction: showBirthDateDialog),
                    const SizedBox(height: 25),
                    PersonFieldWidget(fieldTitle: 'Birth Place', fieldContent: _person.birthPlace, showDialogFunction: showBirthPlaceDialog),
                    const SizedBox(height: 25),
                    PersonFieldWidget(fieldTitle: 'Death Date', fieldContent: DateFormat.yMMMMd().format(_person.deathDate), showDialogFunction: showDeathDateDialog),
                    const SizedBox(height: 25),
                    PersonFieldWidget(fieldTitle: 'Nationality', fieldContent: _person.nationality, showDialogFunction: showNationalityDialog),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                  widget.onDialogClose();
                },
                borderRadius: BorderRadius.circular(30),
                child: Icon(
                  Icons.close_rounded,
                  color: Colors.red,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.75),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                  size: 25,
                ),
              ),
            ),
          ],
        ),
    );
  }
}

class ProfileImagePicker extends StatelessWidget {
  final ImageProvider profileImage;
  final Future<void> Function() pickProfileImageFunction;

  const ProfileImagePicker({super.key, required this.profileImage, required this.pickProfileImageFunction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: pickProfileImageFunction,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: const Color(0xFF78909C),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.75),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: 50,
          backgroundImage: profileImage,
        ),
      ),
    );
  }
}

class PersonFieldWidget extends StatelessWidget {
  final String fieldTitle;
  final String fieldContent;
  final Future<void> Function() showDialogFunction;

  const PersonFieldWidget({super.key, required this.fieldTitle, required this.fieldContent, required this.showDialogFunction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: showDialogFunction,
      child: Container(
        height: 50,
        width: 275,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.75),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$fieldTitle:',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Container(
              height: 30,
              width: 170,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Text(
                    fieldContent,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
