import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todoappv2/model/exception/api_exception.dart';
import 'package:todoappv2/model/user.dart';
import 'package:todoappv2/service/auth_service.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => CadastroScreenState();
}

class CadastroScreenState extends State<CadastroScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController senhaConfirmaController = TextEditingController();

  bool mostrarSenha = false;
  bool mostrarSenhaConfirma = false;
  bool carregando = false;

  Future<void> tentarCadastro() async {
    try {
      setState(() => carregando = true);

      User user = User(
        nomeUsuario: nomeController.text,
        emailUsuario: emailController.text,
        senhaUsuario: senhaController.text,
      );

      await AuthService.cadastro(user);

      Fluttertoast.showToast(
        msg: 'Sucesso ao criar conta',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
      Navigator.pushNamed(context, '/login');
    } catch (e) {
      final err = e is ApiException ? e.message : 'Erro inesperado no cadastro';

      Fluttertoast.showToast(
        msg: err,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      setState(() => carregando = false);
    }
  }

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 24.0,
            left: 24.0,
            right: 24.0,
            bottom: 30.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cadastro',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 54),
                    const Text('Nome completo'),
                    SizedBox(height: 8),
                    TextFormField(
                      controller: nomeController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Informe seu nome';
                        }

                        // Mínimo 3 caracteres
                        if (value.trim().length < 3) {
                          return 'Nome muito curto';
                        }

                        // Exigir ao menos 2 palavras (nome completo)
                        final palavras = value.trim().split(RegExp(r'\s+'));
                        if (palavras.length < 2) {
                          return 'Informe seu nome completo';
                        }

                        // Evitar números e símbolos
                        final regex = RegExp(r"^[a-zA-ZÀ-ÿ\s'-]+$");
                        if (!regex.hasMatch(value)) {
                          return 'Use apenas letras no nome';
                        }

                        return null;
                      },
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
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o e-mail';
                        }
                        final emailValido = RegExp(
                          r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );
                        if (!emailValido.hasMatch(value)) {
                          return 'E-mail inválido';
                        }
                        return null;
                      },
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
                    TextFormField(
                      controller: senhaController,
                      obscureText: !mostrarSenha,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe a senha';
                        }
                        if (value.length < 6) {
                          return 'A senha deve ter ao menos 6 caracteres';
                        }

                        final regex = RegExp(
                          r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~+]).{6,20}$',
                        );

                        if (!regex.hasMatch(value)) {
                          return 'A senha precisa conter:\n'
                              '- Pelo menos um número\n'
                              '- Pelo menos uma letra maiúscula e minúscula\n'
                              '- Pelo menos um caractere especial (!@#\$&*~+)';
                        }

                        return null;
                      },
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Digite sua senha',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            mostrarSenha
                                ? Icons.visibility
                                : Icons.visibility_off,
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
                    TextFormField(
                      controller: senhaConfirmaController,
                      obscureText: !mostrarSenhaConfirma,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe a senha';
                        }
                        if (value.length < 6) {
                          return 'A senha deve ter ao menos 6 caracteres';
                        }

                        final regex = RegExp(
                          r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[!@#\$&*~+]).{6,20}$',
                        );

                        if (!regex.hasMatch(value)) {
                          return 'A senha precisa conter:\n'
                              '- Pelo menos um número\n'
                              '- Pelo menos uma letra maiúscula e minúscula\n'
                              '- Pelo menos um caractere especial (!@#\$&*~+)';
                        }

                        if (value != senhaController.text) {
                          return 'As senhas precisam ser iguais';
                        }
                        return null;
                      },
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
              ),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          tentarCadastro();
                        }
                      },
                      child:
                          carregando
                              ? SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text('Cadastrar'),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      child: const Text('Já possui conta? Faça login'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
