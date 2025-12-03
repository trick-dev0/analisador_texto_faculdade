import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:analisador_texto/features/auth/viewmodels/cadastro_viewmodel.dart';
import 'package:analisador_texto/shared/widgets/validacao_senha_widget.dart';
import 'tela_login.dart';

class TelaCadastro extends StatefulWidget {
  const TelaCadastro({super.key});

  @override
  _TelaCadastroState createState() => _TelaCadastroState();
}

class _TelaCadastroState extends State<TelaCadastro> {
  late CadastroViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = CadastroViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final dataSelecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 16)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 16)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (dataSelecionada != null) {
      _viewModel.setDataNascimento(dataSelecionada);
    }
  }

  void _cadastrar() async {
    final sucesso = await _viewModel.cadastrar();
    
    if (sucesso) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastro realizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const TelaLogin()),
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
          title: const Text('Cadastro'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _viewModel.formKey,
            child: Consumer<CadastroViewModel>(
              builder: (context, viewModel, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    
                    // Nome
                    TextFormField(
                      controller: viewModel.nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome Completo',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: viewModel.validarNome,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // CPF
                    TextFormField(
                      controller: viewModel.cpfController,
                      decoration: const InputDecoration(
                        labelText: 'CPF',
                        prefixIcon: Icon(Icons.badge),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [viewModel.cpfMask],
                      validator: viewModel.validarCPF,
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Data de Nascimento
                    TextFormField(
                      controller: viewModel.dataNascimentoController,
                      decoration: InputDecoration(
                        labelText: 'Data de Nascimento',
                        prefixIcon: const Icon(Icons.calendar_today),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.calendar_month),
                          onPressed: _selecionarData,
                        ),
                      ),
                      readOnly: true,
                      onTap: _selecionarData,
                      validator: (value) => viewModel.validarDataNascimento(value),
                    ),
                    
                    const SizedBox(height: 20),
                    
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
                      onChanged: viewModel.validarSenha,
                      validator: viewModel.validarSenha,
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // Validação da Senha
                    ValidacaoSenhaWidget(viewModel: viewModel),
                    
                    const SizedBox(height: 20),
                    
                    // Confirmar Senha
                    TextFormField(
                      controller: viewModel.confirmarSenhaController,
                      decoration: InputDecoration(
                        labelText: 'Confirmar Senha',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            viewModel.confirmarSenhaVisivel
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: viewModel.toggleConfirmarSenhaVisibilidade,
                        ),
                      ),
                      obscureText: !viewModel.confirmarSenhaVisivel,
                      validator: viewModel.validarConfirmarSenha,
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Botão Cadastrar
                    ElevatedButton(
                      onPressed: viewModel.carregando
                          ? null
                          : () {
                            if (viewModel.formKey.currentState!.validate() &&
                                viewModel.senhaValida) {
                              _cadastrar();
                            }
                          },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: viewModel.carregando
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            )
                          : const Text(
                              'CADASTRAR',
                              style: TextStyle(fontSize: 16),
                            ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Link para Login
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TelaLogin(),
                          ),
                        );
                      },
                      child: const Text('Já tem conta? Faça login'),
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