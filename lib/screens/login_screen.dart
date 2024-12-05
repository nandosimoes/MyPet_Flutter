import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:my_pet_app/screens/register_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String msgErro = "";
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late LocalStorage localStorage;

  @override
  void initState() {
    super.initState();
    localStorage = LocalStorage('my_pet'); 
  }

  void fazerLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      return setState(() {
        msgErro = "Valide seus dados";
      });
    }

    var client = http.Client();
    var url = 'https://pet-adopt-dq32j.ondigitalocean.app/user/login';
    var data = {
      "email": emailController.text,
      "password": passwordController.text
    };

    try {
      var response = await client.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(data),
      );
      var responseData = jsonDecode(response.body);

      if (responseData['token'] != null) {
        var token = responseData['token'];
        var idUser  = responseData['userId'];

        await localStorage.ready; 
        localStorage.setItem("token", token);
        localStorage.setItem("_idUser ", idUser );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        setState(() {
          msgErro = responseData['message'];
        });
      }
    } catch (e) {
      setState(() {
        msgErro = "Erro ao fazer login: $e";
      });
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.blue[100]!],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'My',
                    style: TextStyle(
                      color: Colors.blue[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                    ),
                  ),
                  SizedBox(width: 8),
                  Image.asset(
                    'lib/assets/pata.png',
                    width: 32,
                    height: 32,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Pet',
                    style: TextStyle(
                      color: Colors.blue[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Email',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Senha',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)), 
                ),
              ),
              SizedBox(height: 10),
              Text(msgErro, style: TextStyle(color: Colors.red)),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Logar'),
                onPressed: fazerLogin,
              ),
              SizedBox(height: 10),
              TextButton(
                child: Text('Não tem cadastro?'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute (builder: (context) => RegisterScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}