import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'login_screen.dart';
import '../widgets/bottom_navigation.dart';

class AddPetScreen extends StatefulWidget {
  @override
  _AddPetScreenState createState() => _AddPetScreenState();
}

class _AddPetScreenState extends State<AddPetScreen> {
  late LocalStorage localStorage;
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController weightController = TextEditingController();
  TextEditingController colorController = TextEditingController();
  TextEditingController imageController = TextEditingController();
  String msgError = "";

  @override
  void initState() {
    super.initState();
    localStorage = LocalStorage('my_pet');
  }

  void addPet() async {
    await localStorage.ready; 
    var token = localStorage.getItem("token");

    if (token == null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen()));
      return;
    }

    var client = http.Client();
    var url = "https://pet-adopt-dq32j.ondigitalocean.app/pet/create";
    var data = {
      "name": nameController.text,
      "color": colorController.text,
      "weight": weightController.text,
      "age": ageController.text,
      "images": [imageController.text]
    };

    try {
      var response = await client.post(
        Uri.parse(url),
        body: json.encode(data),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      var responseData = json.decode(response.body);
      setState(() {
        msgError = responseData['message'];
      });
    } catch (e) {
      setState(() {
        msgError = "Erro ao adicionar pet: $e";
      });
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Text(
              'My',
              style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold),
            ),
            Image.asset(
              'lib/assets/pata.png',
              width: 20,
              height: 20,
              fit: BoxFit.contain,
            ),
            Text(
              'Pet',
              style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nome do Pet',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: ageController,
                decoration: InputDecoration(
                  labelText: 'Idade',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: weightController,
                decoration: InputDecoration(
                  labelText: 'Peso',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: colorController,
                decoration: InputDecoration(
                  labelText: 'Cor',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: imageController,
                decoration: InputDecoration(
                  labelText: 'Imagem URL',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular (8),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: addPet,
                child: Text('Adicionar Pet'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 10),
              Text(
                msgError,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}