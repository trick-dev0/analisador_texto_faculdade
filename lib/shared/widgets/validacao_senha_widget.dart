import 'package:flutter/material.dart';
import 'package:analisador_texto/features/auth/viewmodels/cadastro_viewmodel.dart';

class ValidacaoSenhaWidget extends StatelessWidget {
  final CadastroViewModel viewModel;
  
  const ValidacaoSenhaWidget({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'A senha deve conter:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            
            _ItemValidacao(
              valido: viewModel.temMaiuscula,
              texto: 'Pelo menos uma letra maiúscula',
            ),
            _ItemValidacao(
              valido: viewModel.temMinuscula,
              texto: 'Pelo menos uma letra minúscula',
            ),
            _ItemValidacao(
              valido: viewModel.temNumero,
              texto: 'Pelo menos um número',
            ),
            _ItemValidacao(
              valido: viewModel.temEspecial,
              texto: 'Pelo menos um caractere especial (!@#\$%^&*)',
            ),
            _ItemValidacao(
              valido: viewModel.temComprimentoMinimo,
              texto: 'Pelo menos 8 caracteres',
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemValidacao extends StatelessWidget {
  final bool valido;
  final String texto;
  
  const _ItemValidacao({
    required this.valido,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            valido ? Icons.check_circle : Icons.circle,
            color: valido ? Colors.green : Colors.grey,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            texto,
            style: TextStyle(
              color: valido ? Colors.green : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}