import 'package:bricklayer_app/services/auth_service.dart';
import 'package:bricklayer_app/ui/pages/home_page.dart';
import 'package:bricklayer_app/ui/pages/resetpassword_page.dart';
import 'package:bricklayer_app/ui/pages/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String? _errorMessage;

  Future<void> _authenticateAdmin(BuildContext context) async {
    setState(() {
      _loading = true;
      _errorMessage = null;
    });

    // Obter o AuthService com listen: false
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      // Redireciona para a página principal
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } catch (e) {
      setState(() {
        _errorMessage = "Erro ao autenticar. Verifique suas credenciais.";
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login do Pedreiro'),
        backgroundColor: Colors.orange[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.construction, size: 80, color: Colors.orange[800]),
                SizedBox(height: 16),
                Text(
                  'Bem-vindo ao Gerenciador de Obras',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
                if (_errorMessage != null) ...[
                  SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ],
                SizedBox(height: 32),
                _loading
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () => _authenticateAdmin(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[800],
                          padding: EdgeInsets.symmetric(
                            horizontal: 50,
                            vertical: 15,
                          ),
                        ),
                        child: Text('Entrar'),
                      ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => ResetPasswordScreen()),
                    );
                  },
                  child: Text('Esqueci a Senha'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  child: Text('Cadastrar-se'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
