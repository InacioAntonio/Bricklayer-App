import 'package:bricklayer_app/services/auth_service.dart';
import 'package:bricklayer_app/ui/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Tela de Reset de Senha
class ResetPasswordScreen extends StatelessWidget {
  final _emailController = TextEditingController();

  Future<void> _resetPassword(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.resetPassword(_emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('E-mail de recuperação enviado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      print("Erro ao enviar e-mail de recuperação: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Esqueci a Senha'),
        backgroundColor: Colors.orange[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => _resetPassword(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange[800],
                  ),
                  child: Text('Enviar e-mail de recuperação'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
