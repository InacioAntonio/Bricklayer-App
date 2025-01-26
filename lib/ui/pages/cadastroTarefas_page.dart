import 'dart:math';

import 'package:bricklayer_app/services/obra_service.dart';
import 'package:flutter/material.dart';
import 'package:bricklayer_app/domain/Tarefas.dart';
import 'package:bricklayer_app/domain/Obras.dart';
import 'package:bricklayer_app/domain/Insumos.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CadastrarTarefaScreen extends StatefulWidget {
  final Obras obra;
  final Tarefa? tarefa;

  CadastrarTarefaScreen({required this.obra, this.tarefa});

  @override
  _CadastrarTarefaScreenState createState() => _CadastrarTarefaScreenState();
}

class _CadastrarTarefaScreenState extends State<CadastrarTarefaScreen> {
  late TextEditingController _nomeController;
  late TextEditingController _descricaoController;
  DateTime? _dataInicioController;
  DateTime? _dataFimController;
  late bool _concluido;
  late List<Insumos> _insumosAdicionados;
  Insumos? _insumoSelecionado;
  int _quantidadeSelecionada = 1;

  get realtimeService => Provider.of<RealtimeService>(context, listen: false);

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.tarefa?.nome ?? '');
    _descricaoController =
        TextEditingController(text: widget.tarefa?.descricao ?? '');
    _dataInicioController = widget.tarefa?.dataInicio ?? widget.obra.dataInicio;
    _dataFimController = widget.tarefa?.dataFim ?? widget.obra.dataFim;
    _concluido = widget.tarefa?.concluido ?? false;
    _insumosAdicionados = widget.tarefa?.insumos ?? [];
    _insumoSelecionado = null;
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  void _adicionarInsumo() {
    if (_insumoSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Selecione um insumo antes de adicionar.')),
      );
      return;
    }

    setState(() {
      _insumosAdicionados.add(_insumoSelecionado!);
      _insumoSelecionado = null;
      _quantidadeSelecionada = 1;
    });
  }

  void _salvarTarefa() {
    if (_nomeController.text.isEmpty || _descricaoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preencha todos os campos obrigatórios!')),
      );
      return;
    }

    if (_dataInicioController == null ||
        _dataFimController == null ||
        _dataInicioController!.isAfter(_dataFimController!) ||
        _dataInicioController!.isBefore(widget.obra.dataInicio)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verifique as datas selecionadas!')),
      );
      return;
    }
    if (widget.tarefa == null) {
      final novaTarefa = Tarefa(
        nome: _nomeController.text,
        descricao: _descricaoController.text,
        dataInicio: _dataInicioController!,
        dataFim: _dataFimController!,
        insumos: _insumosAdicionados,
        obra: widget.obra.nome,
        concluido: _concluido,
      );

      final tarefas = widget.obra.tarefas ?? [];
      tarefas.add(novaTarefa);
      widget.obra.tarefas = tarefas;
      realtimeService.updateObra(widget.obra);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tarefa cadastrada com sucesso!')));
      Navigator.of(context).pop(novaTarefa);
    } else {
      int index = widget.obra.tarefas!.indexOf(widget.tarefa!) == -1
          ? 0
          : widget.obra.tarefas!.indexOf(widget.tarefa!);
      final novaTarefa = Tarefa(
        nome: _nomeController.text,
        descricao: _descricaoController.text,
        dataInicio: _dataInicioController!,
        dataFim: _dataFimController!,
        insumos: _insumosAdicionados,
        obra: widget.obra.nome,
        concluido: _concluido,
      );
      widget.obra.tarefas![index] = novaTarefa;
      realtimeService.updateObra(widget.obra);
      Navigator.of(context).pop(novaTarefa);
    }
  }

  void _selecionarDataInicio(BuildContext context) async {
    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: _dataInicioController ?? DateTime.now(),
      firstDate: widget.obra.dataInicio,
      lastDate: widget.obra.dataFim,
    );

    if (dataSelecionada == null) return;

    setState(() {
      _dataInicioController = dataSelecionada;
    });
  }

  void _selecionarDataFim(BuildContext context) async {
    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: _dataFimController ?? DateTime.now(),
      firstDate: _dataInicioController ?? widget.obra.dataInicio,
      lastDate: widget.obra.dataFim,
    );

    if (dataSelecionada == null) return;

    setState(() {
      _dataFimController = dataSelecionada;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.tarefa == null ? 'Cadastrar Tarefa' : 'Editar Tarefa'),
        backgroundColor: Colors.orange[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: InputDecoration(labelText: 'Nome da Tarefa'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _descricaoController,
              decoration: InputDecoration(labelText: 'Descrição'),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selecionarDataInicio(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        _dataInicioController == null
                            ? 'Data Início'
                            : DateFormat('dd/MM/yyyy')
                                .format(_dataInicioController!),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => _selecionarDataFim(context),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        _dataFimController == null
                            ? 'Data Fim'
                            : DateFormat('dd/MM/yyyy')
                                .format(_dataFimController!),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text('Concluído'),
              value: _concluido,
              onChanged: (value) {
                setState(() {
                  _concluido = value;
                });
              },
            ),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DropdownButton<Insumos>(
                    hint: Text('Selecione um Insumo'),
                    value: _insumoSelecionado,
                    items: widget.obra.insumos.map((insumo) {
                      return DropdownMenuItem(
                        value: insumo,
                        child: Text(insumo.nome),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _insumoSelecionado = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: DropdownButton<int>(
                    hint: Text('Quantidade'),
                    value: _quantidadeSelecionada,
                    items: List.generate(
                        _insumoSelecionado?.quantidade ?? 0,
                        (index) => DropdownMenuItem(
                            value: index + 1, child: Text('${index + 1}'))),
                    onChanged: (value) {
                      setState(() {
                        _quantidadeSelecionada = value!;
                        _insumoSelecionado!.quantidade = _quantidadeSelecionada;
                      });
                    },
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _adicionarInsumo,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: Text('Adicionar Insumo'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _insumosAdicionados.length,
                itemBuilder: (context, index) {
                  final insumo = _insumosAdicionados[index];
                  final quantidade = insumo.quantidade;
                  return ListTile(
                    title: Text(insumo.nome),
                    subtitle: Text('Quantidade: $quantidade'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _insumosAdicionados.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: _salvarTarefa,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text('Salvar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
