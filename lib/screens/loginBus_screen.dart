import 'package:bustrackk/screens/bus_screen.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';

class LoginBusScreen extends StatefulWidget {
  const LoginBusScreen({super.key});

  @override
  State<LoginBusScreen> createState() => _LoginBusScreenState();
}

class _LoginBusScreenState extends State<LoginBusScreen> {
  TextEditingController usuarioController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('login'),
        Text('Nombre de usaurio'),
        TextField(controller: usuarioController,),
        Text('Contraseña'),
        TextField(controller: passwordController,),
        ElevatedButton(onPressed: (){
          if(usuarioController.text=='admin'&&passwordController.text=='123'){
            Navigator.push(context, MaterialPageRoute(builder: (context){return BusScreen();}));
          }else{
            // Fluttertoast.showToast(
            //     msg: "NO",
            //     toastLength: Toast.LENGTH_LONG,
            //     gravity: ToastGravity.CENTER,
            //     timeInSecForIosWeb: 1,
            //     backgroundColor: Colors.red,
            //     textColor: Colors.white,
            //     fontSize: 16.0
            // );
          }
        }, child: Text('Iniciar Sesión'))
      ],
    ),),);
  }
}
