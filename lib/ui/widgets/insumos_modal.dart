import 'package:bricklayer_app/domain/Insumos.dart';
import 'package:flutter/material.dart';

class AdicionarInsumoModal extends StatefulWidget {
  final Function(String, double, int) onAdicionarInsumo;
  final Insumos? insumo;

  AdicionarInsumoModal({required this.onAdicionarInsumo, this.insumo});

  @override
  _AdicionarInsumoModalState createState() => _AdicionarInsumoModalState();
}

class _AdicionarInsumoModalState extends State<AdicionarInsumoModal> {
  late TextEditingController _nomeController;
  late TextEditingController _valorController;
  late TextEditingController _quantidadeController;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.insumo?.nome ?? '');
    _valorController =
        TextEditingController(text: widget.insumo?.valor.toString() ?? '0.0');
    _quantidadeController = TextEditingController(
        text: widget.insumo?.quantidade.toString() ?? '0');
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _valorController.dispose();
    _quantidadeController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
        bottom: MediaQuery.of(context).viewInsets.bottom +
            16.0, // Adapta o padding inferior ao teclado
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nomeController,
            decoration: InputDecoration(labelText: 'Nome do Insumo'),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _valorController,
            decoration: InputDecoration(labelText: 'Valor do Insumo'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 16),
          TextField(
            controller: _quantidadeController,
            decoration: InputDecoration(labelText: 'Quantidade'),
            keyboardType: TextInputType.number,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              String nome = _nomeController.text;
              double valor = double.tryParse(_valorController.text) ?? 0.0;
              int quantidade = int.tryParse(_quantidadeController.text) ?? 0;

              print('Nome: $nome, Valor: $valor, Quantidade: $quantidade');

              if (nome.isNotEmpty && valor != 0.0 && quantidade != 0) {
                widget.onAdicionarInsumo(nome, valor, quantidade);
                Navigator.pop(context);
              }
            },
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.orange[800]),
            child: Text(
                widget.insumo == null ? 'Adicionar Insumo' : 'Editar Insumo'),
          ),
        ],
      ),
    );
  }
}
