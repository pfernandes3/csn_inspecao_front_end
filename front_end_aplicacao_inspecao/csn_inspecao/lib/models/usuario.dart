import 'package:csn_inspecao/models/cargo.dart';

class Usuario {
  final int id;
  final String matricula;
  final String senha;
  final String nome;
  final Cargo cargo;
  final int? IDGerencia;

  Usuario(
     
      {
      required this.IDGerencia,  
      required this.id,
      required this.senha,
      required this.matricula,
      required this.nome,
      required this.cargo});
}
