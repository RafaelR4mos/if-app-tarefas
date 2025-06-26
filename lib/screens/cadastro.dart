import 'dart:ffi';

import 'package:flutter/material.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => CadastroScreenState();
}

class CadastroScreenState extends State<CadastroScreen> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController senhaConfirmaController = TextEditingController();

  bool mostrarSenha = false;
  bool mostrarSenhaConfirma = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Cadastro',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 54),
                const Text('Nome completo'),
                SizedBox(height: 8),
                TextField(
                  controller: nomeController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'Nome completo',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text('E-mail'),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Digite seu e-mail',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Senha"),
                const SizedBox(height: 8),
                TextField(
                  controller: senhaController,
                  obscureText: !mostrarSenha,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Digite sua senha',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        mostrarSenha ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          mostrarSenha = !mostrarSenha;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text("Confirme a senha"),
                const SizedBox(height: 8),
                TextField(
                  controller: senhaConfirmaController,
                  obscureText: !mostrarSenhaConfirma,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Confirme sua senha',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        mostrarSenhaConfirma
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          mostrarSenhaConfirma = !mostrarSenhaConfirma;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
            Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      final nomeCompleto = nomeController.text;
                      final email = emailController.text;
                      final senha = senhaController.text;
                      final senhaConfirma = senhaConfirmaController.text;

                      debugPrint(
                        'Nome: $nomeCompleto \nE-mail: $email \nSenha: $senha\nSenhaConfirma: $senhaConfirma',
                      );
                    },
                    child: const Text('Cadastrar'),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text('Já possui conta? Faça Login'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
