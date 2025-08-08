import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';

import '../Widgets/button_widget.dart';
import '../Widgets/textController.dart';
import '../controllers/auth_controller.dart';
import '../controllers/laungage_controller.dart';
import '../helpers/constants.dart';
import '../helpers/pref.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final provider = Get.put(AuthController());
  final LanguageController languageController = Get.put(LanguageController());
  final _formKey = GlobalKey<FormState>();
  bool signup = true;
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void initState() {
    signup = Get.arguments['signup'] as bool;
    if (signup == false) {
      _name.text = Pref.userModel.name.toString();
      _email.text = Pref.userModel.email.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Center(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: Get.height * 0.02),
                    Text(
                      languageController.translate('register'),
                      style: const TextStyle(
                          fontSize: 40, fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: Get.height * 0.04),
                    Text(
                      languageController.translate('register_to_continue'),
                      style: const TextStyle(
                          color: textSecondry,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: Get.height * 0.04),
                    textController(
                        context: context,
                        controller: _name,
                        hintText: languageController.translate('name'),
                        keyboardType: TextInputType.name,
                        onChange: (value) {
                          setState(() {});
                        },
                        validator:
                            languageController.translate('enter_your_name')),
                    SizedBox(height: Get.height * 0.02),
                    textController(
                        context: context,
                        controller: _email,
                        hintText: languageController.translate('email'),
                        onChange: (value) {
                          setState(() {});
                        },
                        keyboardType: TextInputType.emailAddress,
                        validator: languageController
                            .translate('enter_your_valid_email')),
                    SizedBox(height: Get.height * 0.02),
                    textController(
                        context: context,
                        controller: _password,
                        maxLines: 1,
                        obscureText: true,
                        onChange: (value) {
                          setState(() {});
                        },
                        keyboardType: TextInputType.visiblePassword,
                        hintText: languageController.translate('password'),
                        validator: languageController
                            .translate('enter_your_password')),
                    SizedBox(height: Get.height * 0.06),
                    Row(
                      children: [
                        Expanded(
                          child: button(
                            lable: signup == true ? 'Sign Up' : 'Save',
                            onTap: () {
                              if (signup == true &&
                                  _formKey.currentState!.validate()) {
                                provider.register(
                                    email: _email.text.trim(),
                                    password: _password.text.trim(),
                                    confirmPassword: _password.text.trim(),
                                    name: _name.text.trim());
                              }
                            },
                            textColor: Colors.white,
                            borderColor: (_email.text.isNotEmpty &&
                                    _name.text.isNotEmpty &&
                                    _password.text.isNotEmpty)
                                ? primery
                                : secondry,
                            buttonColor: (_email.text.isNotEmpty &&
                                    _name.text.isNotEmpty &&
                                    _password.text.isNotEmpty)
                                ? primery
                                : secondry,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Get.height * 0.05),
                    if (signup == true)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: languageController
                                    .translate('already_have_an_account? '),
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: textSecondry,
                                    letterSpacing: 1,
                                    fontWeight: FontWeight.w400),
                                children: [
                                  TextSpan(
                                      text:
                                          languageController.translate('login'),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: primery,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.w400),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          Get.back();
                                        }),
                                ]),
                          ),
                        ],
                      ),
                  ],
                ),
              )),
            ),
          ),
          Positioned(
            top: 40,
            right: 20,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  padding: const EdgeInsets.all(5),
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: secondry, borderRadius: BorderRadius.circular(12)),
                  child: const Icon(MingCuteIcons.mgc_close_fill)),
            ),
          )
        ],
      ),
    );
  }
}
