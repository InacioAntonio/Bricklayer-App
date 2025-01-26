import 'package:bricklayer_app/services/obra_service.dart';
import 'package:bricklayer_app/ui/pages/cadastroObras_page.dart';
import 'package:bricklayer_app/ui/pages/detalhes_da_obra_page.dart';
import 'package:bricklayer_app/ui/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:bricklayer_app/domain/Obras.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Obras>> _obrasFuture;
  late final obraService = Provider.of<RealtimeService>(context, listen: false);
  @override
  void initState() {
    super.initState();
    _obrasFuture =
        Provider.of<RealtimeService>(context, listen: false).listarObras();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bem-vindo à Home do Gerenciador de Obras!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CadastroObrasScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[800],
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
              child: Text(
                'Cadastrar Obra',
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Obras>>(
                future: _obrasFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Erro: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('Nenhuma obra disponível.');
                  } else {
                    List<Obras> obras = snapshot.data!;
                    return ListView.builder(
                      itemCount: obras
                          .length, // Corrigido para definir o número de itens
                      itemBuilder: (context, index) {
                        Obras obra = obras[index];
                        return Card(
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                            title:
                                Text(obra.nome, style: TextStyle(fontSize: 16)),
                            subtitle: Text(obra.descricao),
                            trailing:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              IconButton(
                                icon: Icon(Icons.arrow_forward_ios),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ObraDetailScreen(obra: obra),
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    obras.removeAt(index);
                                    obraService.deleteObra(obra.nome);
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CadastroObrasScreen(obra: obra),
                                    ),
                                  );
                                },
                              )
                            ]),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
