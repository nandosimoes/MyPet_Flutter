import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'home_screen.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String msgErro = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  void cadastro() async {
    if (nameController.text.isEmpty || phoneController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty || confirmPassController.text.isEmpty) {
      return setState(() {msgErro = "Por favor, preencha todos os campos.";});
    }

    if (passwordController.text != confirmPassController.text) {
      return setState(() {msgErro = "As senhas não coincidem.";});
    }

    var client = http.Client();
    var url = "https://pet-adopt-dq32j.ondigitalocean.app/user/register";
    var data = {
      "name": nameController.text,
      "phone": phoneController.text,
      "email": emailController.text,
      "password": passwordController.text,
      "confirmpassword": confirmPassController.text
    };

    try {
      var response = await client.post(Uri.parse(url),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(data));
      var responseData = jsonDecode(response.body);

      if (responseData['token'] != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        setState(() {
          msgErro = responseData['message'];
        });
      }
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
                controller: nameController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Nome',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Telefone',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                ),
              ),
              SizedBox(height: 10),
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
              TextField(
                controller: confirmPassController,
                obscureText: true,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Confirme a senha',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
                ),
              ),
              SizedBox(height: 10),
              Text(msgErro, style: TextStyle(color: Colors.red)),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Cadastrar'),
                onPressed: () {
                  cadastro();
                },
              ),
              SizedBox(height: 10),
              TextButton(
                child: Text('Já tem conta? Logar'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute (builder: (context) => LoginScreen()),
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