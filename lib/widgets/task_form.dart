import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:todoappv2/model/task.dart';

class TaskForm extends StatefulWidget {
  final Function(Task) onSave;

  const TaskForm({super.key, required this.onSave});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();

  String titulo = "";
  String descricao = "";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 40,
        top: 20,
        left: 20,
        right: 20,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Adicionar Tarefa",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Título
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Título'),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Informe o título'
                            : null,
                onSaved: (value) => titulo = value!,
              ),
              const SizedBox(height: 12),

              // Descrição
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Descrição'),
                maxLines: 3,
                onSaved: (value) => descricao = value!,
              ),
              const SizedBox(height: 12),

              // Botão Criar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text(
                    'Criar',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      final novaTask = Task(
                        nomeTarefa: titulo,
                        descricao: descricao,
                      );

                      widget.onSave(novaTask);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white),
      filled: true,
      fillColor: Colors.grey[850],
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }
}
