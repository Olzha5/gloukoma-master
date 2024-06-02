import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gloukoma/services/snack_bar.dart';

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
  TextEditingController userBornDateInputController = TextEditingController();
  DateTime userBornDateInput= DateTime.now();
  TextEditingController userAddressInputController = TextEditingController();
  TextEditingController userPhoneNumInputController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailTextInputController.dispose();
    passwordTextInputController.dispose();
    passwordTextRepeatInputController.dispose();
    userFullNameInputController.dispose();
    userBornDateInputController.dispose();
    userAddressInputController.dispose();
    userPhoneNumInputController.dispose();
    super.dispose();
  }

  void togglePasswordView() {
    setState(() {
      isHiddenPassword = !isHiddenPassword;
    });
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: userBornDateInput,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != userBornDateInput) {
      setState(() {
        userBornDateInput = picked;
        userBornDateInputController = TextEditingController(text: userBornDateInput.toString().split(' ')[0]);
      });
    }
  }

  Future<void> signUp() async {
    final navigator = Navigator.of(context);

    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    if (passwordTextInputController.text !=
        passwordTextRepeatInputController.text) {
      SnackBarService.showSnackBar(
        context,
        'Пароли должны совпадать',
        true,
      );
      return;
    }

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextInputController.text.trim(),
        password: passwordTextInputController.text.trim(),
      );
      await FirebaseFirestore.instance.collection('Users').add({
      'fullname': userFullNameInputController.text.trim(),
        'phonenum':userPhoneNumInputController.text.trim(),
        'address':userAddressInputController.text.trim(),
      'birthday': userBornDateInputController.text.trim(),
        'email': emailTextInputController.text.trim(),

      });
    } on FirebaseAuthException catch (e) {
      print(e.code);

      if (e.code == 'email-already-in-use') {
        SnackBarService.showSnackBar(
          context,
          'Такой Email уже используется, повторите попытку с использованием другого Email',
          true,
        );
        return;
      } else {
        SnackBarService.showSnackBar(
          context,
          'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.',
          true,
        );
      }
    }

    navigator.pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
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
          child:SingleChildScrollView(
          child:Column(
            children: [
              TextFormField(
                autocorrect: false,
                controller: userFullNameInputController,
                validator: (name) =>
                name == null
                    ? 'Введите ФИО'
                    : null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'ФИО',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                autocorrect: false,
                controller: userPhoneNumInputController,
                validator: (name) =>
                name == null
                    ? 'Введите номер'
                    : null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Номер телефона',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                autocorrect: false,
                controller: userAddressInputController,
                validator: (name) =>
                name == null
                    ? 'Введите адресс'
                    : null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Адрес проживания',
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'День рождения',
                ),
                onTap: () {
                  _selectDate(context);
                },
                controller: userBornDateInputController,
              ),
              const SizedBox(height: 20),
              TextFormField(
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
              ),
              const SizedBox(height: 20),
              TextFormField(
                autocorrect: false,
                controller: passwordTextInputController,
                obscureText: isHiddenPassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? 'Минимум 6 символов'
                    : null,
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
              ),
              const SizedBox(height: 20),
              TextFormField(
                autocorrect: false,
                controller: passwordTextRepeatInputController,
                obscureText: isHiddenPassword,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? 'Минимум 6 символов'
                    : null,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  hintText: 'Введите пароль еще раз',
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
