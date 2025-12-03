import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:analisador_texto/features/auth/viewmodels/login_viewmodel.dart';
import 'package:analisador_texto/features/analyzer/views/tela_principal.dart';
import 'tela_cadastro.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  _TelaLoginState createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {
  late LoginViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = LoginViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  void _fazerLogin() async {
    final usuario = await _viewModel.fazerLogin();
    
    if (usuario != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TelaPrincipal(usuario: usuario),
        ),
      );
    } else if (_viewModel.erroMensagem != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_viewModel.erroMensagem!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _viewModel,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _viewModel.formKey,
            child: Consumer<LoginViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 60),
                    
                    // Logo/Ícone
                    const Icon(
                      Icons.analytics,
                      size: 80,
                      color: Colors.blue,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    const Text(
                      'Analisador de Texto',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Email
                    TextFormField(
                      controller: viewModel.emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: viewModel.validarEmail,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Senha
                    TextFormField(
                      controller: viewModel.senhaController,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            viewModel.senhaVisivel
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: viewModel.toggleSenhaVisibilidade,
                        ),
                      ),
                      obscureText: !viewModel.senhaVisivel,
                      validator: viewModel.validarSenha,
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Botão Entrar
                    ElevatedButton(
                      onPressed: viewModel.carregando
                          ? null
                          : _fazerLogin,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: viewModel.carregando
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            )
                          : const Text(
                              'ENTRAR',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Link para Cadastro
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TelaCadastro(),
                          ),
                        );
                      },
                      child: const Text('Ainda não tem conta? Cadastre-se'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}