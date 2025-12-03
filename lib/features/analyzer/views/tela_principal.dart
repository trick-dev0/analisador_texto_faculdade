import 'package:flutter/material.dart';
import 'package:analisador_texto/features/auth/models/usuario.dart';
import 'package:analisador_texto/features/analyzer/viewmodels/analisador_viewmodel.dart';
import 'tela_resultados.dart';

class TelaPrincipal extends StatefulWidget {
  final Usuario usuario;
  
  const TelaPrincipal({
    super.key,
    required this.usuario,
  });

  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  late AnalisadorViewModel _viewModel;

  @override