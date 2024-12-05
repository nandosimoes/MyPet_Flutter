import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:localstorage/localstorage.dart';
import 'package:my_pet_app/widgets/pet_card.dart';
import 'package:my_pet_app/widgets/bottom_navigation.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late LocalStorage localStorage;
  List<Map<String, dynamic>> userPets = [];
  String msgError = "";

  @override
  void initState() {
    super.initState();
    localStorage = LocalStorage('my_pet');
    fetchUserPets();
  }

  void fetchUserPets() async {
    await localStorage.ready; 
    var token = localStorage.getItem("token");

    const String apiUrl = "https://pet-adopt-dq32j.ondigitalocean.app/pet/user_pets"; 
    try {
      var response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body)['pets'];
        setState(() {
          userPets = List<Map<String, dynamic>>.from(responseData);
        });
      } else {
        setState(() {
          msgError = "Erro ao carregar pets: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        msgError = "Erro ao carregar pets: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('lib/assets/profile_pic.png'),
            ),
            SizedBox(height: 20),
            Text(
              'Usuário',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            SizedBox(height: 20),
            if (msgError.isNotEmpty) ...[
              Text(msgError, style: TextStyle(color: Colors.red)),
              SizedBox(height: 10),
            ],
            Expanded(
              child: userPets.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: userPets.length,
                      itemBuilder: (context, index) {
                        return PetCard(
                          name: userPets[index]['name'],
                          images: userPets[index]['images'],
                          petData: userPets[index],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}