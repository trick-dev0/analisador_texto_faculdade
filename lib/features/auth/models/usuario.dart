class Usuario {
  int? id;
  final String nome;
  final String cpf;
  final DateTime dataNascimento;
  final String email;
  final String senhaHash;
  final DateTime dataCriacao;

  Usuario({
    this.id,
    required this.nome,
    required this.cpf,
    required this.dataNascimento,
    required this.email,
    required this.senhaHash,
    DateTime? dataCriacao,
  }) : dataCriacao = dataCriacao ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nome': nome,
      'cpf': cpf,
      'data_nascimento': dataNascimento.toIso8601String(),
      'email': email,
      'senha_hash': senhaHash,
      'data_criacao': dataCriacao.toIso8601String(),
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      cpf: map['cpf'],
      dataNascimento: DateTime.parse(map['data_nascimento']),
      email: map['email'],
      senhaHash: map['senha_hash'],
      dataCriacao: DateTime.parse(map['data_criacao']),
    );
  }

  Usuario copyWith({
    int? id,
    String? nome,
    String? cpf,
    DateTime? dataNascimento,
    String? email,
    String? senhaHash,
    DateTime? dataCriacao,
  }) {
    return Usuario(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      cpf: cpf ?? this.cpf,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      email: email ?? this.email,
      senhaHash: senhaHash ?? this.senhaHash,
      dataCriacao: dataCriacao ?? this.dataCriacao,
    );
  }
}