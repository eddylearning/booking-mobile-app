import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/my_validators.dart';
import 'package:flutter_application_1/screens/forgot_password_screen.dart';
import 'package:flutter_application_1/screens/signup_screen.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// CORRECTED IMPORTS FOR flutter_application_1
// import 'package:flutter_application_1/constants/validator.dart';
import 'package:flutter_application_1/providers/user_provider.dart';
import 'package:flutter_application_1/root_screen.dart';
// import 'package:flutter_application_1/screens/auth/register_screen.dart';
// import 'package:flutter_application_1/widgets/loading_manager.dart';
// import 'package:flutter_application_1/widgets/subtitle_text.dart';
// import 'package:flutter_application_1/widgets/title_text.dart';

class LoadngManager extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  const LoadngManager({required this.isLoading, required this.child, super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(children: [child, if (isLoading) Container(color: Colors.black.withOpacity(0.5), child: Center(child: CircularProgressIndicator()))]);
  }
}
class TitlesTextWidget extends StatelessWidget {
  final String label;
  const TitlesTextWidget({required this.label, super.key});
  @override
  Widget build(BuildContext context) => Text(label, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold));
}
class SubtitleTextWidget extends StatelessWidget {
  final String label;
  final FontStyle? fontStyle;
  final TextDecoration? textDecoration;
  const SubtitleTextWidget({required this.label, this.fontStyle, this.textDecoration, super.key});
  @override
  Widget build(BuildContext context) => Text(label, style: TextStyle(fontStyle: fontStyle, decoration: textDecoration));
}
// -------------------------------------------------

class LoginScreen extends StatefulWidget {
  static const routName = "/LoginScreen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool obscureText = true;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  final _formkey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();

    //focus Nodes
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    if (mounted) {
      _emailController.dispose();
      _passwordController.dispose();
      //Focus Nodes
      _emailFocusNode.dispose();
      _passwordFocusNode.dispose();
    }
    super.dispose();
  }

  Future<void> _loginFct(BuildContext context) async {
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (!isValid) return;

    setState(() => _isLoading = true);
    
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final errorMessage = await userProvider.login(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (errorMessage != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
        return;
      }

      if (mounted) {
        // UserProvider now holds the role via fetchUserData
        final user = userProvider.getUser;
        // Both admin and customer go to RootScreen, the Drawer will adapt
        Navigator.pushReplacementNamed(context, RootScreen.routeName);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _googleSignInFct(BuildContext context) async {
     setState(() => _isLoading = true);
     final userProvider = Provider.of<UserProvider>(context, listen: false);
     
     final error = await userProvider.signInWithGoogle();
     
     if (mounted) {
        if (error != null) {
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error)));
        } else {
           Navigator.pushReplacementNamed(context, RootScreen.routeName);
        }
     }
     if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: LoadngManager(
          isLoading: _isLoading,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const Text("AgriConnect", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  const Align(alignment: Alignment.centerLeft, child: TitlesTextWidget(label: "Welcome back!")),
                  const SizedBox(height: 16),
                  Form(
                    key: _formkey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(hintText: "Email address", prefixIcon: Icon(IconlyLight.message), border: OutlineInputBorder()),
                          onFieldSubmitted: (value) => FocusScope.of(context).requestFocus(_passwordFocusNode),
                          validator: (value) => MyValidators.emailValidator(value),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          obscureText: obscureText,
                          decoration: InputDecoration(
                            hintText: "***********",
                            prefixIcon: const Icon(IconlyLight.lock),
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => obscureText = !obscureText),
                              icon: Icon(obscureText ? Icons.visibility : Icons.visibility_off),
                            ),
                            border: const OutlineInputBorder()
                          ),
                          validator: (value) => MyValidators.passwordValidator(value),
                        ),
                        const SizedBox(height: 16.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // TODO: Implement Forgot Password
                              Navigator.pushNamed(
                                context,
                                ForgotPasswordScreen.routeName,
                              );
                            },
                            child: const SubtitleTextWidget(label: "Forgot password?",
                             fontStyle: FontStyle.italic, 
                             textDecoration: TextDecoration.underline),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(12.0), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))),
                            icon: const Icon(Icons.login),
                            label: const Text("Login"),
                            onPressed: () async => await _loginFct(context),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        SubtitleTextWidget(label: "Or connect using".toUpperCase()),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Expanded(
                              child: SizedBox(
                                height: kBottomNavigationBarHeight,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0), side: BorderSide(color: Colors.grey.shade300))
                                  ),
                                  // icon: const Image(image: AssetImage('assets/images/google.png'), width: 24), // Ensure you have this asset
                                  label: const Text("Google"),
                                  onPressed: () async => await _googleSignInFct(context),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: SizedBox(
                                height: kBottomNavigationBarHeight,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))),
                                  child: const Text("Guest?"),
                                  onPressed: () async => Navigator.pushNamed(context, RootScreen.routeName),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16.0),
                        FittedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SubtitleTextWidget(label: "Don't have an account?"),
                              TextButton(
                                onPressed: () => Navigator.pushNamed(context, RegisterScreen.routeName),
                                child: const SubtitleTextWidget(label: "Create One?", fontStyle: FontStyle.italic, textDecoration: TextDecoration.underline),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
