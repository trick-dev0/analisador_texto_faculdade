import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:analisador_texto/core/database/database_service.dart';
import 'package:analisador_texto/features/auth/models/usuario.dart';

class AuthService {
  final DatabaseService _databaseService = DatabaseService();

  String _hashSenha(String senha) {
    final bytes = utf8.encode(senha);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  Future<bool> cadastrarUsuario(Usuario usuario) async {
    try {
      final db = await _databaseService.database;
      
      final usuarioComHash = usuario.copyWith(
        senhaHash: _hashSenha(usuario.senhaHash),
      );
      
      await db.insert(
        'usuarios',
        usuarioComHash.toMap(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
      
      return true;
    } catch (e) {
      print('Erro ao cadastrar usuário: $e');
      return false;
    }
  }

  Future<Usuario?> fazerLogin(String email, String senha) async {
    try {
      final db = await _databaseService.database;
      final senhaHash = _hashSenha(senha);
      
      final resultados = await db.query(
        'usuarios',
        where: 'email = ? AND senha_hash = ?',
        whereArgs: [email, senhaHash],
      );
      
      if (resultados.isNotEmpty) {
        return Usuario.fromMap(resultados.first);
      }
      
      return null;
    } catch (e) {
      print('Erro ao fazer login: $e');
      return null;
    }
  }

  Future<bool> verificarEmailExistente(String email) async {
    try {
      final db = await _databaseService.database;
      
      final resultados = await db.query(
        'usuarios',
        where: 'email = ?',
        whereArgs: [email],
      );
      
      return resultados.isNotEmpty;
    } catch (e) {
      print('Erro ao verificar email: $e');
      return false;
    }
  }

  Future<bool> verificarCpfExistente(String cpf) async {
    try {
      final db = await _databaseService.database;
      
      final resultados = await db.query(
        'usuarios',
        where: 'cpf = ?',
        whereArgs: [cpf],
      );
      
      return resultados.isNotEmpty;
    } catch (e) {
      print('Erro ao verificar CPF: $e');
      return false;
    }
  }
}