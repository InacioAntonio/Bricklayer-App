import 'package:bricklayer_app/services/auth_service.dart';
import 'package:bricklayer_app/ui/pages/home_page.dart';
import 'package:bricklayer_app/ui/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  final Size preferredSize = Size.fromHeight(56.0);

  CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
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
              authService.signOut();
              // Navega de volta para a tela de login
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => LoginPage()));
            } else if (value == 'sair_do_app') {
              SystemNavigator.pop();
            }
          },
          icon: Icon(Icons.more_vert, color: Colors.white),
          itemBuilder: (BuildContext context) {
            return [
              PopupMenuItem<String>(
                value: 'sair',
                child: Text('Sair'),
              ),
              PopupMenuItem<String>(
                value: 'sair_do_app',
                child: Text('Sair do App'),
              ),
            ];
          },
        ),
      ],
    );
  }
}
