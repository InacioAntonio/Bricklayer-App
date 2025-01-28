import 'package:bricklayer_app/domain/Insumos.dart';
import 'package:bricklayer_app/domain/Obras.dart';
import 'package:bricklayer_app/domain/Tarefas.dart';
import 'package:bricklayer_app/services/obra_service.dart';
import 'package:bricklayer_app/ui/pages/home_page.dart';
import 'package:bricklayer_app/ui/widgets/insumos_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CadastroObrasScreen extends StatefulWidget {
  Obras? obra;
  CadastroObrasScreen({super.key, this.obra});
  @override
  _CadastroObrasScreenState createState() => _CadastroObrasScreenState();
}

class _CadastroObrasScreenState extends State<CadastroObrasScreen> {
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  late RealtimeService realtimeService;
  final List<Insumos> _insumos = [];
  double _valorTotal = 0.0;
  String _novoInsumoNome = '';
  double _novoInsumoValor = 0.0;
  int _novoInsumoQuantidade = 0;
  DateTime? _dataInicio;
  DateTime? _dataFim;
  final _ValorMaoDeObra = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.obra != null) {
      // Configurar valores iniciais para os campos
      _nomeController.text = widget.obra!.nome;
      _descricaoController.text = widget.obra!.descricao;
      _dataInicio = widget.obra!.dataInicio;
      _dataFim = widget.obra!.dataFim;
      _insumos.addAll(widget.obra!.insumos);
      _valorTotal = widget.obra!.valorTotal;
      _ValorMaoDeObra.text = (widget.obra!.valorMaoDeObra ?? 0.0).toString();
    }
    // Adiciona listener ao campo de mão de obra
    _ValorMaoDeObra.addListener(_calcularValorTotal);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    realtimeService = Provider.of<RealtimeService>(context);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    _ValorMaoDeObra.clear();
    // Remove listener para evitar memory leaks
    _ValorMaoDeObra.removeListener(_calcularValorTotal);
    _ValorMaoDeObra.dispose();
    super.dispose();
  }

  void _calcularValorTotal() {
    if (!mounted) return;
    setState(() {
      _valorTotal = 0.0;
      for (var insumo in _insumos) {
        _valorTotal += insumo.valor * insumo.quantidade;
      }
      _valorTotal += double.tryParse(_ValorMaoDeObra.text) ?? 0.0;
    });
  }

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
      _calcularValorTotal();
      // Limpa os campos após adicionar o insumo
      _novoInsumoNome = '';
      _novoInsumoValor = 0.0;
      _novoInsumoQuantidade = 0;
      // Fecha o modal
    });
    // Limpa os campos após adicionar o insumo
    _novoInsumoNome = '';
    _novoInsumoValor = 0.0;
    _novoInsumoQuantidade = 0;
    // Fecha o modal
  }

  void _editarInsumo(Insumos insumo) {
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
    });
    _calcularValorTotal();
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
              _editarInsumo(insumo);
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

  Future<void> _atualizarObra() async {
    try {
      if (_nomeController.text.isEmpty ||
          _descricaoController.text.isEmpty ||
          _dataInicio == null ||
          _dataFim == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Preencha todos os campos!')),
        );
        return;
      }
      widget.obra!.nome = _nomeController.text;
      widget.obra!.descricao = _descricaoController.text;
      widget.obra!.dataInicio = _dataInicio!;
      widget.obra!.dataFim = _dataFim!;
      widget.obra!.insumos = _insumos;
      widget.obra!.valorTotal = _valorTotal;
      widget.obra!.valorMaoDeObra =
          double.tryParse(_ValorMaoDeObra.text) ?? 0.0;
      realtimeService = Provider.of<RealtimeService>(context, listen: false);
      await realtimeService.updateObra(widget.obra!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Obra "${widget.obra!.nome}" atualizada com sucesso!')),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao atualizar a obra: $e')),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }
  }

  Future<void> _cadastrarObra() async {
    if (_nomeController.text.isEmpty ||
        _descricaoController.text.isEmpty ||
        _dataInicio == null ||
        _dataFim == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos!')),
      );
      return;
    }
    if (_insumos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Adicione pelo menos um insumo!')),
      );
      return;
    }
    if (_dataInicio!.isAfter(_dataFim!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Data de início deve ser antes da data de fim!')),
      );
      return;
    }
    Obras novaObra = Obras(
      nome: _nomeController.text,
      dataInicio: _dataInicio!,
      dataFim: _dataFim!,
      descricao: _descricaoController.text,
      insumos: _insumos,
      valorTotal: _valorTotal,
      valorMaoDeObra: double.tryParse(_ValorMaoDeObra.text) ?? 0.0,
      tarefas: List<Tarefa>.empty(growable: true),
    );
    realtimeService = Provider.of<RealtimeService>(context, listen: false);
    try {
      await realtimeService.cadastrarObra(novaObra);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Obra "${novaObra.nome}" cadastrada com sucesso!')),
      );

      // Limpar os campos após o cadastro
      if (mounted) {
        setState(() {
          _nomeController.clear();
          _descricaoController.clear();
          _dataInicio = null;
          _dataFim = null;
          _insumos.clear();
        });
      }
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
        title: Text(widget.obra == null ? 'Cadastrar Obra' : 'Editar Obra'),
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
              TextField(
                controller: _ValorMaoDeObra,
                decoration: InputDecoration(
                  labelText: 'Valor da Mão de Obra',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(
                      r'^\d*\.?\d{0,2}$')), // Permite até duas casas decimais // Aceita apenas números e ponto decimal
                ],
                onChanged: (value) => {_calcularValorTotal()},
              ),
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
                          _calcularValorTotal();
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        _editarInsumo(insumo);
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
                  onPressed:
                      widget.obra == null ? _cadastrarObra : _atualizarObra,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800]),
                  child: Text(
                      widget.obra == null ? 'Cadastrar Obra' : 'Editar Obra',
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
