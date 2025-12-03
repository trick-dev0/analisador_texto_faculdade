import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:analisador_texto/features/auth/services/auth_service.dart';
import 'package:analisador_texto/features/auth/models/usuario.dart';

class CadastroViewModel with ChangeNotifier {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController cpfController = TextEditingController();
  final TextEditingController dataNascimentoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  final TextEditingController confirmarSenhaController = TextEditingController();
  
  // Máscaras
  final cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );
  
  // Estados
  DateTime? _dataNascimento;
  bool _senhaVisivel = false;
  bool _confirmarSenhaVisivel = false;
  bool _carregando = false;
  String? _erroMensagem;
  
  // Validações de senha
  bool _temMaiuscula = false;
  bool _temMinuscula = false;
  bool _temNumero = false;
  bool _temEspecial = false;
  bool _temComprimentoMinimo = false;
  
  // Getters
  GlobalKey<FormState> get formKey => _formKey;
  DateTime? get dataNascimento => _dataNascimento;
  bool get senhaVisivel => _senhaVisivel;
  bool get confirmarSenhaVisivel => _confirmarSenhaVisivel;
  bool get carregando => _carregando;
  String? get erroMensagem => _erroMensagem;
  
  // Validações de senha getters
  bool get temMaiuscula => _temMaiuscula;
  bool get temMinuscula => _temMinuscula;
  bool get temNumero => _temNumero;
  bool get temEspecial => _temEspecial;
  bool get temComprimentoMinimo => _temComprimentoMinimo;
  bool get senhaValida => 
      _temMaiuscula && 
      _temMinuscula && 
      _temNumero && 
      _temEspecial && 
      _temComprimentoMinimo;
  
  // Setters
  void setDataNascimento(DateTime data) {
    _dataNascimento = data;
    dataNascimentoController.text = 
        '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
    notifyListeners();
  }
  
  void toggleSenhaVisibilidade() {
    _senhaVisivel = !_senhaVisivel;
    notifyListeners();
  }
  
  void toggleConfirmarSenhaVisibilidade() {
    _confirmarSenhaVisivel = !_confirmarSenhaVisivel;
    notifyListeners();
  }
  
  void validarSenha(String senha) {
    _temMaiuscula = RegExp(r'[A-Z]').hasMatch(senha);
    _temMinuscula = RegExp(r'[a-z]').hasMatch(senha);
    _temNumero = RegExp(r'[0-9]').hasMatch(senha);
    _temEspecial = RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(senha);
    _temComprimentoMinimo = senha.length >= 8;
    notifyListeners();
  }
  
  // Validações
  String? validarNome(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome é obrigatório';
    }
    
    final partes = value.trim().split(' ');
    if (partes.length < 2) {
      return 'Digite nome e sobrenome';
    }
    
    return null;
  }
  
  String? validarCPF(String? value) {
    if (value == null || value.isEmpty) {
      return 'CPF é obrigatório';
    }
    
    if (value.replaceAll(RegExp(r'[^\d]'), '').length != 11) {
      return 'CPF inválido';
    }
    
    return null;
  }
  
  String? validarDataNascimento(String? value) {
    if (_dataNascimento == null) {
      return 'Data de nascimento é obrigatória';
    }
    
    final idade = DateTime.now().difference(_dataNascimento!).inDays ~/ 365;
    if (idade < 16) {
      return 'Você deve ter pelo menos 16 anos';
    }
    
    return null;
  }
  
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
    
    validarSenha(value);
    
    if (!senhaValida) {
      return 'Senha não atende aos requisitos';
    }
    
    return null;
  }
  
  String? validarConfirmarSenha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirme sua senha';
    }
    
    if (value != senhaController.text) {
      return 'As senhas não coincidem';
    }
    
    return null;
  }
  
  // Cadastro
  Future<bool> cadastrar() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }
    
    try {
      _carregando = true;
      _erroMensagem = null;
      notifyListeners();
      
      // Verificar se email já existe
      final emailExistente = await _authService.verificarEmailExistente(
        emailController.text.trim(),
      );
      
      if (emailExistente) {
        _erroMensagem = 'Email já cadastrado';
        _carregando = false;
        notifyListeners();
        return false;
      }
      
      // Verificar se CPF já existe
      final cpfExistente = await _authService.verificarCpfExistente(
        cpfController.text.replaceAll(RegExp(r'[^\d]'), ''),
      );
      
      if (cpfExistente) {
        _erroMensagem = 'CPF já cadastrado';
        _carregando = false;
        notifyListeners();
        return false;
      }
      
      final usuario = Usuario(
        nome: nomeController.text.trim(),
        cpf: cpfController.text.replaceAll(RegExp(r'[^\d]'), ''),
        dataNascimento: _dataNascimento!,
        email: emailController.text.trim(),
        senhaHash: senhaController.text,
      );
      
      final sucesso = await _authService.cadastrarUsuario(usuario);
      
      _carregando = false;
      notifyListeners();
      
      return sucesso;
    } catch (e) {
      _carregando = false;
      _erroMensagem = 'Erro ao cadastrar: $e';
      notifyListeners();
      return false;
    }
  }
  
  void limpar() {
    nomeController.clear();
    cpfController.clear();
    dataNascimentoController.clear();
    emailController.clear();
    senhaController.clear();
    confirmarSenhaController.clear();
    _dataNascimento = null;
    _erroMensagem = null;
    _carregando = false;
    
    _temMaiuscula = false;
    _temMinuscula = false;
    _temNumero = false;
    _temEspecial = false;
    _temComprimentoMinimo = false;
    
    notifyListeners();
  }
  
  @override
  void dispose() {
    nomeController.dispose();
    cpfController.dispose();
    dataNascimentoController.dispose();
    emailController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
    super.dispose();
  }
}