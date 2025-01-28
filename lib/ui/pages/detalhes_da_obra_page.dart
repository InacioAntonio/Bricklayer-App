import 'package:bricklayer_app/domain/Insumos.dart';
import 'package:bricklayer_app/domain/Obras.dart';
import 'package:bricklayer_app/domain/Tarefas.dart';
import 'package:bricklayer_app/services/obra_service.dart';
import 'package:bricklayer_app/ui/pages/cadastroTarefas_page.dart';
import 'package:bricklayer_app/ui/pages/notifications_page.dart';
import 'package:bricklayer_app/ui/pages/relatorio_page.dart';
import 'package:bricklayer_app/ui/widgets/insumos_modal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ObraDetailScreen extends StatefulWidget {
  final Obras obra;

  ObraDetailScreen({required this.obra});

  @override
  _ObraDetailScreenState createState() => _ObraDetailScreenState();
}

class _ObraDetailScreenState extends State<ObraDetailScreen> {
  void _editarTarefa(Tarefa tarefa) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CadastrarTarefaScreen(
          obra: widget.obra,
          tarefa: tarefa,
        ),
      ),
    ).then((_) => setState(() {})); // Atualiza após salvar alterações
  }

  void _deletarTarefa(Tarefa tarefa) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Excluir Tarefa'),
        content: Text('Tem certeza que deseja excluir esta tarefa?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                widget.obra.tarefas?.remove(tarefa);
              });
              Navigator.of(context).pop();
            },
            child: Text('Excluir'),
          ),
        ],
      ),
    );
  }

  void _editarInsumo(Insumos insumo) {
    int index = widget.obra.insumos.indexOf(insumo);
    showModalBottomSheet(
      context: context,
      builder: (context) => AdicionarInsumoModal(
        onAdicionarInsumo: (nome, valor, quantidade) {
          setState(() {
            insumo.nome = nome;
            insumo.valor = valor;
            insumo.quantidade = quantidade;
          });
        },
        insumo: insumo,
      ),
    ).then((_) {
      setState(() {
        widget.obra.insumos[index] = insumo;
        Provider.of<RealtimeService>(context, listen: false)
            .updateObra(widget.obra);
      });
    }); // Atualiza após salvar alterações // Atualiza após salvar alterações
  }

  void _adicionarInsumo() {
    showModalBottomSheet(
      context: context,
      builder: (context) => AdicionarInsumoModal(
        onAdicionarInsumo: (nome, valor, quantidade) {
          setState(() {
            widget.obra.insumos
                .add(Insumos(nome: nome, valor: valor, quantidade: quantidade));
          });
        },
      ),
    ).then((_) {
      setState(() {
        Provider.of<RealtimeService>(context, listen: false)
            .updateObra(widget.obra);
      });
    });
  }

  void _deletarInsumo(Insumos insumo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Excluir Insumo'),
        content: Text('Tem certeza que deseja excluir este insumo?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                widget.obra.insumos.remove(insumo);
                Provider.of<RealtimeService>(context, listen: false)
                    .updateObra(widget.obra);
              });
              Navigator.of(context).pop();
            },
            child: Text('Excluir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.obra.nome,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Informações gerais
              Text('Detalhes da Obra: ',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text('Data de Início: ${widget.obra.dataInicioFormatada}'),
              Text('Data de Fim: ${widget.obra.dataFimFormatada}'),
              Text('Descrição: ${widget.obra.descricao}'),
              Text('Preço Total: R\$ ${widget.obra.valorTotal}'),
              Text('Valor da Mão de Obra: R\$ ${widget.obra.valorMaoDeObra}'),
              Text(
                  'Quantidade Total de Insumos: ${widget.obra.insumos.length}'),
              SizedBox(height: 16),

              // Lista de Insumos
              Text('Insumos:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.obra.insumos.length,
                itemBuilder: (context, index) {
                  final insumo = widget.obra.insumos[index];
                  return ListTile(
                    title: Text(insumo.nome),
                    subtitle: Text('Quantidade: ${insumo.quantidade}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _editarInsumo(insumo),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deletarInsumo(insumo),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 16),

              // Lista de Tarefas
              Text('Tarefas:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              widget.obra.tarefas != null && widget.obra.tarefas!.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: widget.obra.tarefas?.length,
                      itemBuilder: (context, index) {
                        final tarefa = widget.obra.tarefas?[index];
                        return ListTile(
                          title: Text(tarefa!.nome),
                          subtitle: Text(
                              'Data de Início: ${tarefa.dataInicioFormatada}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editarTarefa(tarefa),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deletarTarefa(tarefa),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Text('Nenhuma tarefa cadastrada'),
              SizedBox(height: 16),

              // Botão Adicionar Tarefa
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CadastrarTarefaScreen(obra: widget.obra),
                      ),
                    ).then((_) => setState(() {}));
                  },
                  child: Text('Adicionar Tarefa'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800]),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                    onPressed: () {
                      _adicionarInsumo();
                    },
                    child: Text('Adicionar Insumo'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[800])),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RelatorioGastosObra(
                                  obra: widget.obra,
                                )));
                  },
                  child: Text('Ver Relatório da Obra'),
                ),
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => NotificationsPage()));
                  },
                  child: Text('Ver notificações'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange[800]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
