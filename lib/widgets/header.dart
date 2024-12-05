import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  final String location;
  final Function(String) onAnimalTypeSelected;

  Header({required this.location, required this.onAnimalTypeSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.location_on, size: 16),
              Text(location, style: TextStyle(fontWeight: FontWeight.bold)),
              Icon(Icons.arrow_drop_down),
            ],
          ),
          SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              hintText: 'Procurar',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildAnimalIcon(Icons.pets, 'Todos', 'Todos'),
              _buildAnimalIcon(Icons.pets, 'Gatos', 'Gato'),
              _buildAnimalIcon(Icons.pets, 'Cães', 'Cão'),
              _buildAnimalIcon(Icons.pets, 'Aves', 'Ave'),
              _buildAnimalIcon(Icons.pets, 'Coelhos', 'Coelho'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnimalIcon(IconData icon, String label, String animalType) {
    return GestureDetector(
      onTap: () {
        onAnimalTypeSelected(animalType); 
      },
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: Colors.orange,
            child: Icon(icon, color: Colors.white),
          ),
          SizedBox(height: 5),
          Text(label, style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
