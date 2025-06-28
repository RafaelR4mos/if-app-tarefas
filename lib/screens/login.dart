import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todoappv2/screens/home.dart';
import 'package:todoappv2/service/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();

  bool mostrarSenha = false;
  bool carregando = false;

  Future<void> tentarLogin() async {
    setState(() => carregando = true);
    final sucesso = await AuthService.login(
      emailController.text,
      senhaController.text,
    );

    if (sucesso && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      Fluttertoast.showToast(
        msg: "Email ou senha inválidos",
        backgroundColor: Colors.red,
        textColor: Colors.white,
        gravity: ToastGravity.BOTTOM,
      );
    }
    setState(() => carregando = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
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
                      'Login',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 54),
                    const Text("E-mail"),
                    SizedBox(height: 8),

                    TextFormField(
                      controller: emailController,
                      textCapitalization: TextCapitalization.none,
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
                    TextFormField(
                      controller: senhaController,
                      textCapitalization: TextCapitalization.none,
                      obscureText: !mostrarSenha,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe a senha';
                        }
                        if (value.length < 6) {
                          return 'A senha deve ter ao menos 6 caracteres';
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
                          tentarLogin();
                        }
                      },
                      child:
                          carregando
                              ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text('Entrar'),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/cadastro');
                      },
                      child: const Text('Criar conta'),
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
