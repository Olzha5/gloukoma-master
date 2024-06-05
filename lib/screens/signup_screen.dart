import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gloukoma/services/snack_bar.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> {
  bool isHiddenPassword = true;
  TextEditingController emailTextInputController = TextEditingController();
  TextEditingController passwordTextInputController = TextEditingController();
  TextEditingController passwordTextRepeatInputController = TextEditingController();
  TextEditingController userFullNameInputController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailTextInputController.dispose();
    passwordTextInputController.dispose();
    passwordTextRepeatInputController.dispose();
    userFullNameInputController.dispose();
    super.dispose();
  }

  void togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }

  Future<void> signUp() async {
    final navigator = Navigator.of(context);

    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    if (passwordTextInputController.text != passwordTextRepeatInputController.text) {
      SnackBarService.showSnackBar(context, 'Пароли должны совпадать', true);
      return;
    }

    try {
      // Register with Django
      final response = await http.post(
        Uri.parse('http://olzhasna.beget.tech/users/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'username': userFullNameInputController.text.trim(),
          'email': emailTextInputController.text.trim(),
          'password': passwordTextInputController.text.trim(),
          'courses': [1],
          'int_courses': 0,
          'status': 'active',
        }),
      );

      if (response.statusCode != 201) {
        String errorMessage = 'Ошибка при регистрации в Django';
        try {
          final responseData = jsonDecode(utf8.decode(response.bodyBytes));
          if (responseData is Map<String, dynamic>) {
            if (responseData.containsKey('message')) {
              errorMessage = responseData['message'];
            } else if (responseData.containsKey('password')) {
              errorMessage = responseData['password'][0]; // Assuming the error is a list
            } else {
              errorMessage = responseData.toString();
            }
          } else {
            errorMessage = response.body.toString();
          }
        } catch (e) {
          errorMessage = 'Ошибка при регистрации в Django: Неизвестный формат ответа';
        }
        SnackBarService.showSnackBar(
          context,
          '$errorMessage (${response.statusCode})',
          true,
        );
        return; // Stop execution if Django registration fails
      }

      // Register with Firebase
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextInputController.text.trim(),
        password: passwordTextInputController.text.trim(),
      );

      // Add user to Firestore
      await FirebaseFirestore.instance.collection('Users').add({
        'fullname': userFullNameInputController.text.trim(),
        'email': emailTextInputController.text.trim(),
      });

      // Send email verification
      await userCredential.user?.sendEmailVerification();

      navigator.pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);

    } on FirebaseAuthException catch (e) {
      print(e.code);

      String errorMessage = 'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'Такой Email уже используется, повторите попытку с использованием другого Email';
      }
      SnackBarService.showSnackBar(context, errorMessage, true);
    } catch (e) {
      SnackBarService.showSnackBar(context, 'Ошибка при регистрации: $e', true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Зарегистрироваться'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  autocorrect: false,
                  controller: userFullNameInputController,
                  validator: (name) => name == null || name.isEmpty ? 'Введите ФИО' : null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Username',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  controller: emailTextInputController,
                  validator: (email) => email != null && !EmailValidator.validate(email) ? 'Введите правильный Email' : null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Введите Email',
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  autocorrect: false,
                  controller: passwordTextInputController,
                  obscureText: isHiddenPassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.length < 6 ? 'Минимум 6 символов' : null,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Введите пароль',
                    suffix: InkWell(
                      onTap: togglePasswordView,
                      child: Icon(
                        isHiddenPassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  autocorrect: false,
                  controller: passwordTextRepeatInputController,
                  obscureText: isHiddenPassword,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value != null && value.length < 6 ? 'Минимум 6 символов' : null,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Введите пароль еще раз',
                    suffix: InkWell(
                      onTap: togglePasswordView,
                      child: Icon(
                        isHiddenPassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: signUp,
                  child: const Center(child: Text('Регистрация')),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Войти',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}