import 'package:flutter_test/flutter_test.dart';
import 'package:tree_designer/data_classes/user_model.dart';

void main() {
  group('User', ()
  {
    test('given values', () {
      final user = UserModel.fromJson({"profilePic": "https://i.pinimg.com/474x/29/f5/c3/29f5c3a04113dd6a3c7580329165ed6f.jpg", "name": "TestBot", "email": "test_bot123@gmail.com", "bio": "Just testing"});
      expect(user.profilePicUrl, "https://i.pinimg.com/474x/29/f5/c3/29f5c3a04113dd6a3c7580329165ed6f.jpg");
      expect(user.name, "TestBot");
      expect(user.email, "test_bot123@gmail.com");
      expect(user.bio, "Just testing");
    });
  });
}