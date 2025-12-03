import 'package:flutter/material.dart';
import 'package:myapp/CustomWidgets/custom_button.dart';
import 'package:myapp/Screens/bottom_nav_screen.dart';
import 'package:myapp/Services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  //route
  static const String routeName = "/";

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //var
  var email = "";
  var password = "";
  bool isLoading = false;
  bool obscurePassword = true;
  GlobalKey<FormState> formKey = GlobalKey();
  final AuthService _authService = AuthService();

  Future<void> _handleLogin() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      setState(() {
        isLoading = true;
      });

      final result = await _authService.login(email, password);

      setState(() {
        isLoading = false;
      });

      if (result['success']) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, BottomNavScreen.routeName);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result['message']),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "S'authentifier",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            spacing: 15,
            children: [
              //1
              Image.asset("assets/minecraft.jpg"),
              //2
              TextFormField(
                decoration: const InputDecoration(hintText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Email should not be empty';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) {
                  email = value!;
                },
              ),
              //3
              TextFormField(
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  hintText: "Password",
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Password should not be empty';
                  }
                  return null;
                },
                onSaved: (value) {
                  password = value!;
                },
              ),
              //4 : button
              InkWell(
                onTap: isLoading ? null : _handleLogin,
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.deepPurpleAccent,
                      )
                    : CustomButton("S'authentifier", Colors.deepPurpleAccent),
              ),
              CustomButton("Créer un compte", Colors.red),
              //5
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 15,
                children: [
                  //1
                  Text("Mot de passe oublié?"),
                  //2
                  Text(
                    "Cliquer Ici",
                    style: TextStyle(color: Colors.deepPurpleAccent),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
