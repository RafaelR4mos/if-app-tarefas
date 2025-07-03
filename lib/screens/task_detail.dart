import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todoappv2/model/task.dart';
import 'package:todoappv2/service/task_service.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late TextEditingController _nomeController;
  late TextEditingController _descricaoController;
  bool _finalizada = false;
  bool _isLoading = false;

  XFile? _imagemSelecionada;

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.task.nomeTarefa);
    _descricaoController = TextEditingController(text: widget.task.descricao);
    _finalizada = widget.task.status == 'F';
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _descricaoController.dispose();
    super.dispose();
  }

  Future<void> _selecionarImagem() async {
    final picker = ImagePicker();
    final imagem = await picker.pickImage(source: ImageSource.gallery);

    if (imagem != null) {
      setState(() {
        _imagemSelecionada = imagem;
      });
    }
  }

  void _salvarAlteracoes() async {
    setState(() {
      _isLoading = true;
    });
    await TaskService.updateTask(
      widget.task.idTarefa!,
      _nomeController.text,
      _descricaoController.text,
    );

    if (_finalizada) {
      await TaskService.finalizarTask(widget.task.idTarefa!);
    } else {
      await TaskService.desfinalizarTask(widget.task.idTarefa!);
    }

    Fluttertoast.showToast(
      msg: "Dados da tarefa atualizados com sucesso!",
      backgroundColor: Colors.green,
      textColor: Colors.white,
      gravity: ToastGravity.BOTTOM,
    );

    setState(() {
      _isLoading = false;
    });
  }

  void _excluirTarefa() async {
    final confirmacao = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirmar exclusão'),
            content: const Text('Tem certeza que deseja excluir esta tarefa?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Excluir',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirmacao == true) {
      final sucesso = await TaskService.deleteTask(widget.task.idTarefa!);

      if (sucesso && mounted) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Erro ao excluir tarefa')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Tarefa'),
        actions: [
          IconButton(icon: const Icon(Icons.delete), onPressed: _excluirTarefa),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          top: 24.0,
          left: 24.0,
          right: 24.0,
          bottom: 30.0,
        ),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome da tarefa'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('Marcar como finalizada'),
              value: _finalizada,
              onChanged: (value) {
                setState(() {
                  _finalizada = value;
                });
              },
            ),
            const SizedBox(height: 12),

            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _selecionarImagem,
                  icon: const Icon(Icons.image),
                  label: const Text("Adicionar imagem"),
                ),
                const SizedBox(width: 10),
                if (_imagemSelecionada != null) Text(_imagemSelecionada!.name),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _salvarAlteracoes();
                },
                child: Text(_isLoading ? 'Carregando...' : 'Salvar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
