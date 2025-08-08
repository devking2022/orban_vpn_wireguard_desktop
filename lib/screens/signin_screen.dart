import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ming_cute_icons/ming_cute_icons.dart';
import 'package:orban_vpn_desktop/helpers/config.dart';
import 'package:open_share_plus/open.dart';
import '../Widgets/textController.dart';
import '../controllers/auth_controller.dart';
import '../controllers/laungage_controller.dart';
import '../helpers/constants.dart';
import '../widgets/button_widget.dart';
import '../widgets/divider.dart';
import 'signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final LanguageController languageController = Get.put(LanguageController());
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final provider = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
              child: Center(
                  child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Get.height * 0.02),
                  Text(languageController.translate('welcome_back'),
                      style: const TextStyle(
                          fontSize: 40, fontWeight: FontWeight.w700)),
                  SizedBox(height: Get.height * 0.04),
                  Text(
                    languageController.translate('login_to_continue'),
                    style: const TextStyle(
                        color: textSecondry,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: Get.height * 0.04),
                  textController(
                      context: context,
                      controller: _email,
                      hintText: languageController.translate('email'),
                      maxLines: 1,
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
                      validator:
                          languageController.translate('enter_your_password')),
                  SizedBox(height: Get.height * 0.02),
                  GestureDetector(
                    onTap: () {
                      Open.browser(url: Config.hostUrl + '/profile');
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          languageController.translate('forgot_password?'),
                          style: const TextStyle(color: primery, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Get.height * 0.05),
                  Row(
                    children: [
                      Expanded(
                        child: button(
                          lable: languageController.translate('sign_in'),
                          textColor: Colors.white,
                          borderColor: (_email.text.isNotEmpty &&
                                  _password.text.isNotEmpty)
                              ? primery
                              : secondry,
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              provider.login(
                                email: _email.text,
                                password: _password.text,
                              );
                            }
                          },
                          buttonColor: (_email.text.isNotEmpty &&
                                  _password.text.isNotEmpty)
                              ? primery
                              : secondry,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Get.height * 0.02),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: HorizontalOrLine(
                      label: languageController.translate('or_sign_in_with'),
                      auth: false,
                    ),
                  ),
                  SizedBox(height: Get.height * 0.05),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: languageController
                                .translate('dont_have_an_account?'),
                            style: const TextStyle(
                                fontSize: 16,
                                color: textSecondry,
                                letterSpacing: 1,
                                fontWeight: FontWeight.w400),
                            children: [
                              TextSpan(
                                  text: "Sign Up",
                                  style: const TextStyle(
                                      fontSize: 16,
                                      color: primery,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w400),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.to(SignUpScreen(),
                                          arguments: {'signup': true});
                                    }),
                            ]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ))),
          Positioned(
            top: 40,
            right: 20,
            child: GestureDetector(
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
