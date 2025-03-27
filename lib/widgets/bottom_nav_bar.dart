import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;

  const CustomBottomNavigationBar({
    Key? key,
    required this.onItemTapped,
    required this.selectedIndex,
  }) : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Início',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline),
          activeIcon: Icon(Icons.people),
          label: 'Clientes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined), // Produtos Ícone
          activeIcon: Icon(Icons.shopping_bag),
          label: 'Produtos', // Produtos texto
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_outlined), // Ícone para Orçamentos
          activeIcon: Icon(Icons.receipt),
          label: 'Orçamentos',
        ),
      ],
      currentIndex: widget.selectedIndex,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey[700],
      onTap: widget.onItemTapped,
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      backgroundColor: Colors.white,
      elevation: 5,
    );
  }
}
