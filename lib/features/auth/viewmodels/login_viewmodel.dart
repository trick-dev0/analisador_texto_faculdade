import 'package:flutter/material.dart';
import 'package:analisador_texto/features/auth/services/auth_service.dart';
import 'package:analisador_texto/features/auth/models/usuario.dart';

class LoginViewModel with ChangeNotifier {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  
  // Estados
  bool _senhaVisivel = false;
  bool _carregando = false;
  String? _erroMensagem;
  Usuario? _usuarioLogado;
  
  // Getters
  GlobalKey<FormState> get formKey => _formKey;
  bool get senhaVisivel => _senhaVisivel;
  bool get carregando => _carregando;
  String? get erroMensagem => _erroMensagem;
  Usuario? get usuarioLogado => _usuarioLogado;
  
  // Setters
  void toggleSenhaVisibilidade() {
    _senhaVisivel = !_senhaVisivel;
    notifyListeners();
  }
  
  // Validações
  String? validarEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }
    
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
    );
    
    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }
    
    return null;
  }
  
  String? validarSenha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }
    
    return null;
  }
  
  // Login
  Future<Usuario?> fazerLogin() async {
    if (!formKey.currentState!.validate()) {
      return null;
    }
    
    try {
      _carregando = true;
      _erroMensagem = null;
      notifyListeners();
      
      final usuario = await _authService.fazerLogin(
        emailController.text.trim(),
        senhaController.text,
      );
      
      _carregando = false;
      
      if (usuario == null) {
        _erroMensagem = 'Email ou senha incorretos';
        notifyListeners();
        return null;
      }
      
      _usuarioLogado = usuario;
      notifyListeners();
      return usuario;
    } catch (e) {
      _carregando = false;
      _erroMensagem = 'Erro ao fazer login: $e';
      notifyListeners();
      return null;
    }
  }
  
  void limpar() {
    emailController.clear();
    senhaController.clear();
    _erroMensagem = null;
    _carregando = false;
    notifyListeners();
  }
  
  @override
  void dispose() {
    emailController.dispose();
    senhaController.dispose();
    super.dispose();
  }
}