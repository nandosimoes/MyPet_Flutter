import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/pet_card.dart';
import '../widgets/bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> pets = [];

  @override
  void initState() {
    super.initState();
    fetchPets();
  }

  void fetchPets() {
    const String apiUrl = "https://pet-adopt-dq32j.ondigitalocean.app/pet/pets";
    http.get(Uri.parse(apiUrl)).then((response) {
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body)['pets'];
        setState(() {
          pets = List<Map<String, dynamic>>.from(responseData);
        });
      }
    }).catchError((error) {
      debugPrint("Erro ao carregar pets: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Text(
              'My',
              style: TextStyle(
                color: Colors.blue[900],
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.asset(
              'lib/assets/pata.png',
              width: 20,
              height: 20,
              fit: BoxFit.contain,
            ),
            Text(
              'Pet',
              style: TextStyle(
                color: Colors.blue[900],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('lib/assets/profile_pic.png'),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: Colors.white,
            child: Row(
              children: [
                Icon(Icons.location_on, color: Colors.grey[600]),
                const SizedBox(width: 5),
                Text(
                  'Embu das Artes',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: pets.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.75,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: pets.length,
                      itemBuilder: (context, index) {
                        return PetCard(
                          name: pets[index]['name'],
                          images: pets[index]['images'],
                          petData: pets[index],
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
