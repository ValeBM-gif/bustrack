import 'package:bustrackk/constants.dart';
import 'package:bustrackk/screens/bus_screen.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_visibility_pro/keyboard_visibility_pro.dart';

import '../curve_painter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginBusScreen extends StatefulWidget {
  const LoginBusScreen({super.key});

  @override
  State<LoginBusScreen> createState() => _LoginBusScreenState();
}

class _LoginBusScreenState extends State<LoginBusScreen> {
  TextEditingController usuarioController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode focusUser = FocusNode();
  FocusNode focusPassword = FocusNode();

  bool userTextFieldSelected = false;
  bool passwordTextFieldSelected = false;

  bool textInUser = false;
  bool textInPassword = false;

  bool keyboardVisible =false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeyboardVisibility(
        onChanged: (visible) {
          print('visible? $visible');
          if(visible){
            keyboardVisible=true;
          }else{
            keyboardVisible=false;
          }
          if (!visible) {
            userTextFieldSelected = false;
            passwordTextFieldSelected = false;
            if(usuarioController.text!=''){
              textInUser=true;
            }
            if(passwordController.text!=''){
              textInPassword=true;
            }
          }
          setState(() {});
        },
        child: Center(
          child: CustomPaint(
            painter: CurvePainter2(),
            child: CustomPaint(
              painter: CurvePainter(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 25.0, top: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'Bus Login',
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextField(
                    cursorColor: kPrimaryColor,
                    controller: usuarioController,
                    focusNode: focusUser,
                    style: TextStyle(
                        fontSize: 16,
                        color:
                            !userTextFieldSelected ? Colors.white: kPrimaryColor),
                    onTap: () {
                      userTextFieldSelected = true;
                      passwordTextFieldSelected = false;
                      if(passwordController.text!=''){
                        print('q verga hay en pc ${passwordController.text}');
                        textInPassword=true;
                      }
                      setState(() {});
                    },
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(focusPassword);
                      userTextFieldSelected = false;
                      passwordTextFieldSelected = true;
                      if(usuarioController.text!=''){
                        textInUser=true;
                      }
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      focusColor: kPrimaryColor,
                      hintText: 'Nombre de usuario',
                      icon: const Padding(
                        padding: EdgeInsets.only(left: 18.0),
                        child: Icon(Icons.person),
                      ),
                      iconColor:
                          !userTextFieldSelected ? Colors.white : kPrimaryColor,
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    cursorColor: kPrimaryColor,
                    obscureText: true,
                    controller: passwordController,
                    focusNode: focusPassword,
                    style: TextStyle(
                        fontSize: 16,
                        color: !passwordTextFieldSelected
                            ? Colors.white : kPrimaryColor),
                    onTap: () {
                      userTextFieldSelected = false;
                      passwordTextFieldSelected = true;
                      if(usuarioController.text!=''){
                        textInUser=true;
                      }
                      setState(() {});
                    },
                    onEditingComplete: () {
                      FocusScope.of(context).requestFocus(focusPassword);
                      userTextFieldSelected = false;
                      passwordTextFieldSelected = false;
                      FocusManager.instance.primaryFocus?.unfocus();
                      setState(() {});
                    },
                    decoration: InputDecoration(
                      focusColor: kPrimaryColor,
                      hintText: 'Contraseña',
                      icon: const Padding(
                        padding: EdgeInsets.only(left: 18.0),
                        child: Icon(Icons.lock),
                      ),
                      iconColor:
                          !passwordTextFieldSelected ?Colors.white : kPrimaryColor,
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.only( bottom: 30),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kPrimaryColor),
                      ),
                      onPressed: () {
                        if (usuarioController.text == 'admin' &&
                            passwordController.text == '123') {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return BusScreen();
                          }));
                        } else {
                          Fluttertoast.showToast(
                              msg: "NO",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: 16.0
                          );
                        }
                      },
                      child:const Text('                                 Iniciar Sesión                                 ', style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  SizedBox(height: keyboardVisible?0:50,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
