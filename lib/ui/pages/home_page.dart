import 'package:bricklayer_app/ui/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Text('Bem-vindo à Home do Gerenciador de Obras!'),
      ),
    );
  }
}
