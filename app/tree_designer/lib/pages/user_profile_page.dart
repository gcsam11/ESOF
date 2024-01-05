import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tree_designer/firebase/auth_service.dart';
import 'package:tree_designer/firebase/firebase_storage.dart';
import 'package:tree_designer/firebase/firestore.dart';
import 'package:tree_designer/routes/router.gr.dart';

import '../data_classes/user_model.dart';

@RoutePage()
class UserProfilePage extends StatefulWidget {
  final UserModel user;

  const UserProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  late final UserModel _user;
  late ImageProvider _displayedImage;
  late final TextEditingController _nameController;
  late final TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _displayedImage = NetworkImage(_user.profilePicUrl);
    _nameController = TextEditingController(text: _user.name);
    _bioController = TextEditingController(text: _user.bio);
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) { return; }

    if (_user.profilePicUrl != 'https://firebasestorage.googleapis.com/v0/b/treedesigner-212f0.appspot.com/o/profile_pics%2Fprofile_default.jpg?alt=media&token=e2eadcc3-479d-46e4-8876-629a3d3e6b26') {
      FirebaseStorageUtils.deleteFile(_user.profilePicUrl);
    }

    final String imageName = image.name;
    final String imagePath = image.path;

    setState(() {
      _displayedImage = FileImage(File(imagePath));
    });

    bool fileAlreadyExists = await FirebaseStorageUtils.fileExists('profile_pics/$imageName');
    if(!fileAlreadyExists) {
      FirebaseStorageUtils.uploadFile('profile_pics/$imageName', imagePath);
    }

    String url = await FirebaseStorageUtils.getDownloadURL('profile_pics/$imageName');
    FirestoreUtils.updateProfilePicInDatabase(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Column(
              children: [
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundImage: _displayedImage,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child:
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(8),
                          ),
                          onPressed: _pickImage,
                          child: const Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    'Email: ${_user.email}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  cursorColor: Colors.black54,
                  controller: _nameController,
                  decoration: const InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(
                        color: Colors.black54,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black54,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black54,
                          )
                      )
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  keyboardType: TextInputType.text,
                  controller: _bioController,
                  cursorColor: Colors.black54,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      labelText: 'Bio',
                      labelStyle: TextStyle(
                        color: Colors.black54,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black54,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black54,
                          )
                      )
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    backgroundColor: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                  ),
                  onPressed: () {
                    AuthService.logUserOut();
                    context.router.replace(const LoginRoute());
                  },
                  child: const Text(
                    'Log out',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
            Positioned(
              top: 0,
              right: 0,
              child: FloatingActionButton(
                mini: true,
                onPressed: () {
                  setState(() {
                    _user.name = _nameController.text;
                    _user.bio = _bioController.text;
                  });
                  FirestoreUtils.updateUserInfoInDatabase(_user.name, _user.bio);
                },
                backgroundColor: Colors.indigo,
                child: const Icon(
                  Icons.save,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
