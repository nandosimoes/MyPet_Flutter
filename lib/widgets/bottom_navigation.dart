import 'package:flutter/material.dart';
import 'package:my_pet_app/screens/add_pet_screen.dart';
import 'package:my_pet_app/screens/profile_screen.dart';
import '../screens/home_screen.dart';        

class BottomNavigation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
                BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Perfil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_circle_outline),
          label: 'Adicionar',
        ),

      ],
      onTap: (index) {
        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
            break;
            case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen())
            );
             break;
            case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AddPetScreen())
            );
        }
      },
    );
  }
}
