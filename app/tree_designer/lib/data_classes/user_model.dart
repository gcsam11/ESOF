class UserModel {
  String profilePicUrl;
  String name;
  String email;
  String bio;

  UserModel({this.profilePicUrl = 'https://firebasestorage.googleapis.com/v0/b/treedesigner-212f0.appspot.com/o/profile_pics%2Fprofile_default.jpg?alt=media&token=e2eadcc3-479d-46e4-8876-629a3d3e6b26',
    this.name = 'undefined', this.email = 'undefined', this.bio = 'undefined'});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      profilePicUrl: json['profile_pic_url'],
      name: json['name'],
      email: json['email'],
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() => {
    "profile_pic_url" : profilePicUrl,
    "name" : name,
    "email" : email,
    "bio" : bio,
  };
}