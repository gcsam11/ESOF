import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:tree_designer/data_classes/user_model.dart';
import 'package:tree_designer/firebase/auth_service.dart';
import 'package:tree_designer/components/custom_textfield.dart';
import 'package:tree_designer/firebase/firestore.dart';
import 'package:tree_designer/routes/router.gr.dart';

@RoutePage()
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoadingUser = false;

  void setIsLoadingUser(bool value) {
    setState(() {
      _isLoadingUser = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: _isLoadingUser ? const Center(child: CircularProgressIndicator()) :
          Center(
            child: Column(
              children: [
                const Spacer(),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "TreeDesigner",
                      style: TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.w800,
                        color: Colors.indigo,
                      ),
                    ),
                    Icon(
                      Icons.nature,
                      size: 50,
                      color: Colors.orange,
                    ),
                  ],
                ),
                const Spacer(),
                const Text(
                  'Welcome back!',
                  style: TextStyle(
                      color: Colors.lightBlue,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 25),
                // username textfield
                CustomTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: passwordController,
                  hintText: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      setIsLoadingUser(true);

                      final String? message = await AuthService.login(email: emailController.text, password: passwordController.text);
                      final bool loginAccepted = message == 'success';

                      if(loginAccepted) {
                        UserModel user = await FirestoreUtils.loadCurrentUserFromDatabase();
                        if (mounted) {
                          context.router.replace(HomeRoute(user: user));
                        }
                      } else {
                        setIsLoadingUser(false);
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              behavior: SnackBarBehavior.floating,
                              content: message != null ? Text(message) : const Text('No Message received'),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(25.0),
                        backgroundColor: Colors.indigo,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                      )
                    ),
                    child: const Center(
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:  [
                    const Text(
                      'Not a member?',
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(width: 4),
                    TextButton(
                      onPressed: () {
                        context.router.pushNamed('/register');
                      },
                      child: const Text(
                        'Register now',
                        style: TextStyle(
                          color: Colors.yellow,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}