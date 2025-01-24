import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize = Size.fromHeight(56.0);

  CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.orange[800],
      title: Text(
        'Pedreiro App',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          iconSize: 28,
          onPressed: () {
            Scaffold.of(context).openDrawer(); // Abre o Drawer
          },
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'sair') {
              SystemNavigator.pop(); // Fecha o app
            }
          },
          icon: Icon(Icons.more_vert, color: Colors.white),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'sair',
                child: Text('Sair'),
              ),
            ];
          },
        ),
      ],
    );
  }
}
