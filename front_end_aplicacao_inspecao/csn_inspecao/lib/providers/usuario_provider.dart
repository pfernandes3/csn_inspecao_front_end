import 'dart:convert';
import 'dart:async';
import 'package:csn_inspecao/models/cargo.dart';
import 'package:csn_inspecao/models/usuario.dart';
import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import 'package:http/http.dart' as http;

class UsuarioProvider with ChangeNotifier {
  Usuario? _currentUser;

  Usuario? get currentUser => _currentUser;

  FutureOr<Usuario?> returnUser(matricula) async {
    try {
      var user1 = await http.post(
          Uri.parse('http://192.168.1.107:3001/users/mat'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({"Matricula": matricula}));
      var data = json.decode(user1.body);
      print('ENTREI AQUI dados do data $data');
      if (data['sucesso'] == true) {
        Usuario user = Usuario(
          IDGerencia: data['IDGerencia'],
          id: data['usuario']['IDUsuario'],
          senha: data['usuario']['Senha'],
          matricula: data['usuario']['Matricula'],
          nome: data['usuario']['NomeUsuario'],
          cargo: Cargo(Descricao: 'TESTE'),
        );
        _currentUser = user;
        return user;
      } else {
        print('NÃO ENTREI NA CONDIÇÃO');
        print('Chave "success" está presente? ${data.containsKey('success')}');
        print('Valor da chave "success": ${data['success']}');

        _currentUser = null;
        return null;
      }
    } catch (e) {
      print(e);
      _currentUser = null;
      return null;
    }
  }

  FutureOr<Usuario?> findUserByMatriculaAndPassword(matricula, password) async {
    try {
      var response = await http.post(
          Uri.parse('http://192.168.1.107:3001/users/login'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({"Matricula": matricula, "Senha": password}));

      var data = json.decode(response.body);
      print(data);
      if (data['sucess'] == true) {
        Usuario user = Usuario(
          IDGerencia: data['user']?['IDGerencia'] as int?,
          id: data['user']['IDUsuario'],
          senha: data['user']['Senha'],
          matricula: data['user']['Matricula'],
          nome: data['user']['NomeUsuario'],
          cargo: Cargo(Descricao: 'TESTE'),
        );
        _currentUser = user;
        return user;
      } else {
        print('NÃO ENTREI NA CONDIÇÃO');
        print('Chave "success" está presente? ${data.containsKey('success')}');
        print('Valor da chave "success": ${data['success']}');

        _currentUser = null;
        return null;
      }
    } catch (e) {
      print(e);
      _currentUser = null;
      return null;
    }
  }
}
