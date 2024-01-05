import 'package:auto_route/auto_route.dart';
import 'package:tree_designer/firebase/auth_service.dart';
import 'package:tree_designer/components/custom_textfield.dart';
import 'package:flutter/material.dart';


@RoutePage()
class RegisterAccountPage extends StatefulWidget {
  const RegisterAccountPage({Key? key}) : super(key: key);

  @override
  State<RegisterAccountPage> createState() => _RegisterAccountPageState();
}

class _RegisterAccountPageState extends State<RegisterAccountPage>{
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isCreatingUser = false;

  void setIsCreatingUser(bool value) {
    setState(() {
      _isCreatingUser = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: _isCreatingUser ? const Center(child: CircularProgressIndicator()) :
          Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                          setIsCreatingUser(true);

                          final String? message = await AuthService.registration(email: emailController.text, password: passwordController.text);
                          final bool registrationAccepted = message == 'success';

                          if (mounted) {
                            if(registrationAccepted) {
                              context.router.pop();
                            } else {
                              setIsCreatingUser(false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar (
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
                          ),
                        ),
                        child: const Center(
                          child: Text(
                            "Register",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(flex: 2),
                  ],
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                child: InkWell(
                  onTap: () {
                    context.router.pop();
                  },
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    size: 50,
                    color: Colors.lightBlue,
                  ),
                ),
              ),
            ],
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
