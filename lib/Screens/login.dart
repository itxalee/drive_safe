// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:drive_safe/Components/LoginScreen/login_button.dart';
import 'package:drive_safe/Components/LoginScreen/rounded_input.dart';
import 'package:drive_safe/Components/LoginScreen/rounded_password.dart';
import 'package:drive_safe/Components/LoginScreen/signup_button.dart';
import 'package:drive_safe/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

bool isLogin = true;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> containerSize;
  late AnimationController animationController;
  Duration animationDuration = Duration(milliseconds: 270);

  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _passwordR;
  late final TextEditingController _conPassword;
  late final TextEditingController _age;
//  late final TextEditingController _gender;
  String? gender;

  // List of items in our dropdown menu
  var items = [
    'Male',
    'Female',
    'Other',
  ];

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _passwordR = TextEditingController();
    _conPassword = TextEditingController();
    _name = TextEditingController();
    _age = TextEditingController();
    //_gender = TextEditingController();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    animationController =
        AnimationController(vsync: this, duration: animationDuration);
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
    _conPassword.dispose();
    _age.dispose();
    // _gender.dispose();

    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double viewInsets = MediaQuery.of(context).viewInsets.bottom;
    double defualtLoginSize = size.height - (size.height * 0.2);
    double defualtRegisterSize = size.height - (size.height * 0.1);
    bool keyboard = false;
    setState(() {
      if (viewInsets == 0) {
        keyboard = false;
      } else {
        keyboard = true;
      }
    });

    containerSize = Tween<double>(
            begin: size.height * 0.1, end: defualtRegisterSize)
        .animate(
            CurvedAnimation(parent: animationController, curve: Curves.linear));
    return Scaffold(
      body: Stack(
        children: [
          //Decoration
          Visibility(
            visible: !keyboard,
            child: Positioned(
              top: 80,
              right: -50,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: kPrimaryColor,
                ),
              ),
            ),
          ),
          Visibility(
            visible: !keyboard,
            child: Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(90),
                  color: kPrimaryColor,
                ),
              ),
            ),
          ),
          //close button
          AnimatedOpacity(
            opacity: isLogin ? 0.0 : 1.0,
            duration: animationDuration,
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: size.width,
                height: size.height * 0.1,
                alignment: Alignment.bottomCenter,
                child: IconButton(
                  icon: Icon(Icons.close),
                  onPressed: isLogin
                      ? null
                      : () {
                          animationController.reverse();
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                ),
              ),
            ),
          ),
          //Login Form
          AnimatedOpacity(
            opacity: isLogin ? 1.0 : 0.0,
            duration: animationDuration * 3,
            child: Align(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 70),
                  height: defualtLoginSize,
                  width: size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Welcome Back To Drive Safe",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(height: 20),
                      Expanded(
                        child: Image.asset(
                          'asset/images/welcome_image.png',
                          // height: 250,
                          //   width: 250,
                        ),
                      ),
                      SizedBox(height: 20),
                      RoundedInput(
                        icon: Icons.email,
                        hint: "Email",
                        controller: _email,
                        inputType: TextInputType.emailAddress,
                        maxLen: 50,
                      ),
                      RoundedPassword(text: "Password", controller: _password),
                      SizedBox(height: 20),
                      LoginButton(
                        text: "LOGIN",
                        email: _email,
                        password: _password,
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          ),
          //Register Container
          AnimatedBuilder(
              animation: animationController,
              builder: (context, child) {
                if (viewInsets == 0 && isLogin) {
                  return buildRegisterContainer();
                } else if (!isLogin) {
                  return buildRegisterContainer();
                } else {
                  return Container();
                }
              }),
          //Register Form
          AnimatedOpacity(
            opacity: isLogin ? 0.0 : 1.0,
            duration: animationDuration * 4,
            child: Visibility(
              visible: !isLogin,
              child: Align(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    height: defualtLoginSize,
                    width: size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 20),
                        Text(
                          "Welcome To Drive Safe",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                          ),
                        ),
                        SizedBox(height: 20),
                        Expanded(
                          child: Image.asset(
                            'asset/images/welcome_image.png',
                            // height: 250,
                            // width: 250,
                          ),
                        ),
                        SizedBox(height: 20),
                        RoundedInput(
                          icon: Icons.face,
                          hint: "Name",
                          controller: _name,
                          inputType: TextInputType.name,
                          maxLen: 30,
                        ),
                        RoundedInput(
                          icon: Icons.date_range,
                          hint: "Age",
                          controller: _age,
                          inputType: TextInputType.number,
                          maxLen: 2,
                        ),
                        //
                        Container(
                            margin: EdgeInsets.symmetric(vertical: 5),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 2),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: kPrimaryColor.withAlpha(50),
                            ),
                            child: DropdownButtonFormField(
                              hint: Text('Select Gender'),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.groups,
                                    color: kPrimaryColor,
                                  )),
                              icon: const Icon(Icons.keyboard_arrow_down),
                              items: items.map((String items) {
                                return DropdownMenuItem(
                                  value: items,
                                  child: Text(items),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  gender = value as String?;
                                });
                              },
                              value: gender,
                            )),
                        RoundedInput(
                          icon: Icons.email,
                          hint: "Email",
                          controller: _email,
                          inputType: TextInputType.emailAddress,
                          maxLen: 50,
                        ),
                        RoundedPassword(
                            text: "Password", controller: _passwordR),
                        RoundedPassword(
                            text: "Confirm Password", controller: _conPassword),
                        SizedBox(height: 20),
                        SignUpButton(
                          hint: "SIGN UP",
                          email: _email,
                          password: _passwordR,
                          name: _name,
                          conPassword: _conPassword,
                          age: _age,
                          gender: gender,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Register Form Container
  Widget buildRegisterContainer() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: containerSize.value,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(100),
            topRight: Radius.circular(100),
          ),
          color: kBackgroundColor,
        ),
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: !isLogin
              ? null
              : () {
                  animationController.forward();
                  setState(() {
                    isLogin = !isLogin;
                  });
                },
          child: isLogin
              ? Text(
                  "Don't have any account? Sign Up",
                  style: TextStyle(color: kPrimaryColor, fontSize: 18),
                )
              : null,
        ),
      ),
    );
  }
}
