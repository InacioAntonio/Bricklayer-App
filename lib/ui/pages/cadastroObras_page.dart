import 'package:bricklayer_app/domain/Insumos.dart';
import 'package:bricklayer_app/domain/Obras.dart';
import 'package:bricklayer_app/services/obra_service.dart';
import 'package:bricklayer_app/ui/pages/home_page.dart';
import 'package:bricklayer_app/ui/widgets/insumos_modal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CadastroObrasScreen extends StatefulWidget {
  @override
  _CadastroObrasScreenState createState() => _CadastroObrasScreenState();
}

class _CadastroObrasScreenState extends State<CadastroObrasScreen> {
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final List<Insumos> _insumos = [];
  double _valorTotal = 0.0;
  String _novoInsumoNome = '';
  double _novoInsumoValor = 0.0;
  int _novoInsumoQuantidade = 0;
  DateTime? _dataInicio;
  DateTime? _dataFim;

  void _adicionarInsumo() {
    print('Adicionando insumo: $_novoInsumoNome');
    if (_novoInsumoNome.isEmpty ||
        _novoInsumoValor == 0.0 ||
        _novoInsumoQuantidade == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos do insumo!')),
      );
      return;
    }
    setState(() {
      _insumos.add(
        Insumos(
          nome: _novoInsumoNome,
          valor: _novoInsumoValor,
          quantidade: _novoInsumoQuantidade,
        ),
      );
      for (var insumo in _insumos) {
        _valorTotal += insumo.valor * insumo.quantidade;
      }
    });
    // Limpa os campos após adicionar o insumo
    _novoInsumoNome = '';
    _novoInsumoValor = 0.0;
    _novoInsumoQuantidade = 0;
    // Fecha o modal
  }

  void _EditarInsumo(Insumos insumo) {
    print('Editando insumo: $_novoInsumoNome');
    if (_novoInsumoNome.isEmpty ||
        _novoInsumoValor == 0.0 ||
        _novoInsumoQuantidade == 0) {
      _abrirModalAdicionarInsumo(insumo);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos do insumo!')),
      );
      return;
    }
    setState(() {
      _insumos.remove(insumo);
      _insumos.add(
        Insumos(
          nome: _novoInsumoNome,
          valor: _novoInsumoValor,
          quantidade: _novoInsumoQuantidade,
        ),
      );
      for (var insumo in _insumos) {
        _valorTotal += insumo.valor * insumo.quantidade;
      }
    });
    // Limpa os campos após adicionar o insumo
    _novoInsumoNome = '';
    _novoInsumoValor = 0.0;
    _novoInsumoQuantidade = 0;
    // Fecha o modal
  }

  void _abrirModalAdicionarInsumo(Insumos? insumo) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return AdicionarInsumoModal(
          onAdicionarInsumo: (String nome, double valor, int quantidade) {
            setState(() {
              _novoInsumoNome = nome;
              _novoInsumoValor = valor;
              _novoInsumoQuantidade = quantidade;
            });
            if (insumo != null) {
              _EditarInsumo(insumo);
            } else {
              _adicionarInsumo();
            }
          },
          insumo: insumo,
        );
      },
    );
  }

  void _selecionarDataInicio(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _dataInicio) {
      setState(() {
        _dataInicio = picked;
      });
    }
  }

  void _selecionarDataFim(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _dataFim) {
      setState(() {
        _dataFim = picked;
      });
    }
  }

  void _cadastrarObra() {
    if (_nomeController.text.isEmpty ||
        _descricaoController.text.isEmpty ||
        _dataInicio == null ||
        _dataFim == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }
    if (_insumos == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Adicione pelo menos um insumo!')),
      );
      return;
    }
    print(_valorTotal);
    Obras novaObra = Obras(
      nome: _nomeController.text,
      dataInicio: _dataInicio!,
      dataFim: _dataFim!,
      descricao: _descricaoController.text,
      insumos: _insumos,
      valorTotal: _valorTotal,
    );

    // Recupera o serviço do Provider
    final realtimeService =
        Provider.of<RealtimeService>(context, listen: false);

    // Envia os dados para o serviço
    try {
      realtimeService.cadastrarObra(novaObra);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Obra "${novaObra.nome}" cadastrada com sucesso!')),
      );

      // Limpar os campos após o cadastro
      setState(() {
        _nomeController.clear();
        _descricaoController.clear();
        _dataInicio = null;
        _dataFim = null;
        _insumos.clear();
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao cadastrar a obra: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastro de Obras'),
        backgroundColor: Colors.orange[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _nomeController,
                decoration: InputDecoration(
                  labelText: 'Nome da Obra',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                        onTap: () => _selecionarDataInicio(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            _dataInicio == null
                                ? 'Selecione a data'
                                : DateFormat('dd/MM/yyyy').format(_dataInicio!),
                            style: TextStyle(color: Colors.black),
                          ),
                        )),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                        onTap: () => _selecionarDataFim(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            _dataFim == null
                                ? 'Selecione a data'
                                : DateFormat('dd/MM/yyyy').format(_dataFim!),
                            style: TextStyle(color: Colors.black),
                          ),
                        )),
                  ),
                ],
              ),
              Text(
                'Insumos Adicionados:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              ..._insumos.map((insumo) {
                return ListTile(
                  title: Text(insumo.nome),
                  subtitle: Text(
                    'Valor: R\$ ${insumo.valor.toStringAsFixed(2)} | Quantidade: ${insumo.quantidade}',
                  ),
                  trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _insumos.remove(insumo);
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        _EditarInsumo(insumo);
                      },
                    )
                  ]),
                );
              }).toList(),
              SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () => _abrirModalAdicionarInsumo(null),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreen),
                    child: Text('Adicionar Insumo',
                        style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 16),
                ],
              ),
              SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: _cadastrarObra,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800]),
                  child: Text('Cadastrar Obra',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
              SizedBox(height: 32),
              Center(
                child: Text(
                  'Valor Total: R\$ ${_valorTotal.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
