import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gloukoma/services/snack_bar.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isHiddenPassword = true;
  bool isLoading = false;
  TextEditingController emailTextInputController = TextEditingController();
  TextEditingController passwordTextInputController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailTextInputController.dispose();
    passwordTextInputController.dispose();
    super.dispose();
  }

  void togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  Future<void> login() async {
    final navigator = Navigator.of(context);
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextInputController.text.trim(),
        password: passwordTextInputController.text.trim(),
      );
      navigator.pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
        case 'wrong-password':
          errorMessage = 'Неправильный email или пароль. Повторите попытку';
          break;
        case 'user-disabled':
          errorMessage = 'Учетная запись заблокирована.';
          break;
        case 'too-many-requests':
          errorMessage = 'Слишком много попыток входа. Попробуйте позже.';
          break;
        default:
          errorMessage = 'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.';
      }
      SnackBarService.showSnackBar(context, errorMessage, true);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Войти'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              _buildEmailField(),
              const SizedBox(height: 30),
              _buildPasswordField(),
              const SizedBox(height: 30),
              _buildLoginButton(),
              const SizedBox(height: 30),
              _buildSignupButton(),
              _buildResetPasswordButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      autocorrect: false,
      controller: emailTextInputController,
      validator: (email) =>
      email != null && !EmailValidator.validate(email)
          ? 'Введите правильный Email'
          : null,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: 'Введите Email',
      ),
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      autocorrect: false,
      controller: passwordTextInputController,
      obscureText: isHiddenPassword,
      validator: (value) => value != null && value.length < 6
          ? 'Минимум 6 символов'
          : null,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: 'Введите пароль',
        suffix: InkWell(
          onTap: togglePasswordView,
          child: Icon(
            isHiddenPassword
                ? Icons.visibility_off
                : Icons.visibility,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: isLoading ? null : login,
      child: isLoading
          ? CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      )
          : const Center(child: Text('Войти')),
    );
  }

  Widget _buildSignupButton() {
    return TextButton(
      onPressed: () => Navigator.of(context).pushNamed('/signup'),
      child: const Text(
        'Регистрация',
        style: TextStyle(
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }

  Widget _buildResetPasswordButton() {
    return TextButton(
      onPressed: () => Navigator.of(context).pushNamed('/reset_password'),
      child: const Text('Сбросить пароль'),
    );
  }
}
