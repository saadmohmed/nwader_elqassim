
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nwader/home_screen/home_screen.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../Services/ApiManager.dart';
import '../app_theme.dart';
import 'Login.dart';

class SignUp extends StatefulWidget {
  SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final storage = new FlutterSecureStorage();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            //to give space from top
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => Login()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        'تسجبل دخول',
                        style: GoogleFonts.getFont(
                          AppTheme.fontName,
                          textStyle: TextStyle(
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w700,
                            fontSize: 23,
                            letterSpacing: 0.5,
                            color: AppTheme.orange,
                          ),
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 100,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: GestureDetector(
                      onTap: () async {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()),
                        );
                      },
                      child: Text(
                        'تخطي',
                        style: GoogleFonts.getFont(
                          AppTheme.fontName,
                          textStyle: TextStyle(
                            fontFamily: AppTheme.fontName,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            letterSpacing: 0.5,
                            color: AppTheme.grey,
                          ),
                        ),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 50,
            ),

            //page content here
            Expanded(
              flex: 9,
              child: buildCard(context, size),
            ),
          ],
        ),
      ),
    );
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();

  TextEditingController phone = TextEditingController();
  String phoneErrorMessage = '';
  String nameErrorMessage = '';
  String passwordErrorMessage = '';
  double opacityError = 0;

  Widget buildCard(BuildContext context, Size size) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40), topRight: Radius.circular(40)),
          color: AppTheme.green,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //header text
            Text(
              'انشاء حساب جديد',
              style: GoogleFonts.getFont(
                AppTheme.fontName,
                textStyle: TextStyle(
                  fontFamily: AppTheme.fontName,
                  fontWeight: FontWeight.w700,
                  fontSize: 23,
                  letterSpacing: 0.5,
                  color: AppTheme.white,
                ),
              ),
            ),

            SizedBox(
              height: size.height * 0.03,
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Opacity(
                        opacity: opacityError,
                        child: Text(nameErrorMessage,
                            style: GoogleFonts.getFont(
                              AppTheme.fontName,
                              textStyle: TextStyle(
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                letterSpacing: 0.5,
                                color: AppTheme.orange,
                              ),
                            )),
                      ),
                      nameTextField(size),

                      //email & password section
                      SizedBox(
                        height: 30,
                      ),
                      Opacity(
                        opacity: opacityError,
                        child: Text(phoneErrorMessage,
                            style: GoogleFonts.getFont(
                              AppTheme.fontName,
                              textStyle: TextStyle(
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                letterSpacing: 0.5,
                                color: AppTheme.orange,
                              ),
                            )),
                      ),
                      phoneFeild(size),
                      SizedBox(
                        height: 30,
                      ),
                      Opacity(
                        opacity: opacityError,
                        child: Text(passwordErrorMessage,
                            style: GoogleFonts.getFont(
                              AppTheme.fontName,
                              textStyle: TextStyle(
                                fontFamily: AppTheme.fontName,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                letterSpacing: 0.5,
                                color: AppTheme.orange,
                              ),
                            )),
                      ),

                      passwordFeild(size)
                    ]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                  alignment: Alignment.center,
                  height: size.height / 11,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(
                      width: 2,
                      color: const Color(0xFFEFEFEF),
                    ),
                  ),
                  child: InkWell(
                    onTap: () async {
                      if (_formKey.currentState!.validate()) {
                        ApiProvider _api = new ApiProvider();
                        dynamic _loginData = await _api.register(
                            phone.text, password.text, name.text);
                        print(_loginData);

                        final storage = new FlutterSecureStorage();
                        if (_loginData['status'] == true) {
                          Alert(
                            context: context,
                            type: AlertType.success,
                            title: _loginData['response_message'],
                            desc: "",
                            buttons: [],
                          ).show();
                          dynamic data = _loginData['user_data'];
                          await storage.write(key: 'name', value: data['name']);
                          await storage.write(
                              key: 'id', value: data['id'].toString());
                          await storage.write(
                              key: 'email', value: data['email']);
                          await storage.write(
                              key: 'token', value: data['token']);
                          await storage.write(
                              key: 'mobile', value: data['mobile']);
                          await storage.write(
                              key: 'activation_code',
                              value: data['activation_code']);
                          await storage.write(
                              key: 'see_notifications',
                              value: data['see_notifications'].toString());
                          await storage.write(
                              key: 'balance',
                              value: data['balance'].toString());
                          await storage.write(
                              key: 'expiration_at',
                              value: data['expiration_at']);
                          await storage.write(
                              key: 'notification_count',
                              value: data['notification_count'].toString());
                          await storage.write(
                              key: 'image', value: data['image']);
                          await storage.write(
                              key: 'activation_code_e',
                              value: data['activation_code_e'].toString());
                          await storage.write(
                              key: 'image_thumbnail',
                              value: data['image_thumbnail']);

                          await storage.write(
                              key: 'addresses', value: jsonEncode(data['addresses']));

                          await storage.write(
                              key: 'device_key',
                              value: data['device_key'].toString());
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeScreen()),
                          );
                        } else {
                          _loginData["errors"].forEach((elemnt) {
                            if (elemnt["field"] == "mobile") {
                              setState(() {
                                opacityError = 1;
                                phoneErrorMessage = elemnt["error"];
                              });
                            }

                            if (elemnt["field"] == "name") {
                              setState(() {
                                opacityError = 1;
                                nameErrorMessage = elemnt["error"];
                              });
                            }
                            if (elemnt["field"] == "password") {
                              setState(() {
                                opacityError = 1;
                                passwordErrorMessage = elemnt["error"];
                              });
                            }
                          });
                          Alert(
                            context: context,
                            type: AlertType.error,
                            title: _loginData['response_message'],
                            desc: "",
                            buttons: [
                              DialogButton(
                                child: Text(
                                  "متابعة",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                onPressed: () => Navigator.pop(context),
                                width: 120,
                              )
                            ],
                          ).show();
                        }
                      }
                    },
                    child: Text(
                      'انشاء حساب جديد',
                      style: GoogleFonts.getFont(
                        AppTheme.fontName,
                        textStyle: TextStyle(
                          fontFamily: AppTheme.fontName,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: AppTheme.green,
                        ),
                      ),
                    ),
                  )),
            ),

            SizedBox(
              height: size.height * 0.04,
            ),

            //footer section. sign up text here
          ],
        ),
      ),
    );
  }

  Widget nameTextField(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 11,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 2,
          color: AppTheme.white,
        ),
      ),
      child: TextFormField(
        controller: name,
        validator: (value) {
          if (value!.isEmpty) {
            return 'اكتب اسم  صحيح';
          }
          return null;
        },
        style: GoogleFonts.getFont(
          AppTheme.fontName,
          textStyle: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.5,
            color: AppTheme.white,
          ),
        ),
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
            labelText: ' الاسم',
            labelStyle: GoogleFonts.getFont(
              AppTheme.fontName,
              textStyle: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                letterSpacing: 0.5,
                color: AppTheme.grey,
              ),
            ),
            border: InputBorder.none),
      ),
    );
  }

  Widget phoneFeild(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 11,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 2,
          color: AppTheme.white,
        ),
      ),
      child: TextFormField(
        controller: phone,
        validator: (value) {
          if (value!.isEmpty) {
            return 'اكتب رقم جوال  صحيح';
          }
          return null;
        },
        style: GoogleFonts.getFont(
          AppTheme.fontName,
          textStyle: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.5,
            color: AppTheme.white,
          ),
        ),
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
            labelText: 'رقم الجوال',
            labelStyle: GoogleFonts.getFont(
              AppTheme.fontName,
              textStyle: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                letterSpacing: 0.5,
                color: AppTheme.grey,
              ),
            ),
            border: InputBorder.none),
      ),
    );
  }

  Widget passwordFeild(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 11,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 2,
          color: AppTheme.white,
        ),
      ),
      child: TextFormField(
        controller: password,
        obscureText: true,
        validator: (value) {
          if (value!.isEmpty) {
            return 'اكتب كلمة مرور صحيحة';
          }
          return null;
        },
        style: GoogleFonts.getFont(
          AppTheme.fontName,
          textStyle: TextStyle(
            fontFamily: AppTheme.fontName,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            letterSpacing: 0.5,
            color: AppTheme.white,
          ),
        ),
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
            labelText: 'كلمة المرور',
            labelStyle: GoogleFonts.getFont(
              AppTheme.fontName,
              textStyle: TextStyle(
                fontFamily: AppTheme.fontName,
                fontWeight: FontWeight.w700,
                fontSize: 20,
                letterSpacing: 0.5,
                color: AppTheme.grey,
              ),
            ),
            border: InputBorder.none),
      ),
    );
  }
}
