import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  final String nomeUsuario = 'Rafael Santos';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(90), // altura personalizada
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
                CircleAvatar(
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
      body: const Center(child: Text("Conteúdo da tela")),
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
