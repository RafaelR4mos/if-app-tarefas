import 'package:flutter/material.dart';
import 'package:todoappv2/model/task.dart';
import 'package:todoappv2/service/auth_service.dart';
import 'package:todoappv2/service/task_service.dart';
import 'package:todoappv2/widgets/task_form.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final String nomeUsuario = 'Rafael Santos';
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    carregarTarefas();
  }

  void carregarTarefas() async {
    try {
      final List<Task> tarefasCarregadas = await TaskService.fetchTasks();

      if (!mounted) return;

      setState(() {
        tasks = tarefasCarregadas;
      });
    } catch (e) {
      print('Erro ao carregar tarefas: $e');
    }
  }

  Future<void> realizarLogout() async {
    try {
      await AuthService.logout();
      Navigator.pushNamed(context, '/login');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEmpty = tasks.isEmpty;

    void abrirBottomSheetNovaTask() {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.grey[900],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (context) {
          return TaskForm(
            onSave: (novaTask) async {
              final sucesso = await TaskService.createTask(novaTask);

              //Resolve problemas relacionado a destruição de widget.
              if (!mounted) return;

              if (sucesso) {
                carregarTarefas();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Erro ao salvar tarefa')),
                );
              }

              Navigator.of(context).pop();
            },
          );
        },
      );
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          child: SafeArea(
            child:
            // Foto do usuário
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'logout') {
                      realizarLogout();
                      print('Logout');
                    }
                  },
                  itemBuilder:
                      (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'logout',
                          child: Text('Logout'),
                        ),
                      ],
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.deepPurple,
                    child: Text(
                      getIniciais('Rafael Santos'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Text(
                  'Home',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.filter_alt_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // Ação do filtro
                    showDialog(
                      context: context,
                      builder:
                          (context) => AlertDialog(
                            title: const Text("Filtro"),
                            content: const Text("Aqui viria seu filtro!"),
                          ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body:
          isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Substitua com sua imagem real
                    Image.asset('assets/placeholder-tasks.png', width: 200),
                    const SizedBox(height: 20),
                    const Text(
                      'O que você quer fazer hoje?',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Toque em "+" para adicionar tarefas',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    color: Colors.grey[900],
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      title: Text(
                        task.nomeTarefa,
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        task.descricao,
                        style: const TextStyle(color: Colors.white70),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          task.status == "F"
                              ? Icons.check_box
                              : Icons.check_box_outline_blank,
                          color: Colors.white70,
                        ),
                        onPressed:
                            task.status == "F"
                                ? () async {
                                  final sucesso =
                                      await TaskService.desfinalizarTask(
                                        task.idTarefa!,
                                      );
                                  if (sucesso) {
                                    carregarTarefas();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Erro ao desfinalizar tarefa',
                                        ),
                                      ),
                                    );
                                  }
                                }
                                : () async {
                                  final sucesso =
                                      await TaskService.finalizarTask(
                                        task.idTarefa!,
                                      );
                                  if (sucesso) {
                                    carregarTarefas();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Erro ao finalizar tarefa',
                                        ),
                                      ),
                                    );
                                  }
                                },
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          abrirBottomSheetNovaTask();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

String getIniciais(String nomeCompleto) {
  final partes = nomeCompleto.trim().split(' ');
  if (partes.length == 1) {
    return partes.first[0].toUpperCase();
  }

  final primeiraLetra = partes.first[0];
  final ultimaLetra = partes.last[0];

  return '${primeiraLetra.toUpperCase()}${ultimaLetra.toUpperCase()}';
}
