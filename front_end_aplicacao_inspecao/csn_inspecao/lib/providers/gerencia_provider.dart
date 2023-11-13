import 'package:csn_inspecao/models/gerencia.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
class GerenciaProvider with ChangeNotifier {
  final List<Gerencia> _gerencias = [];
  List<Gerencia> get gerencias => [..._gerencias];

    Future<void> loadGerencias() async{
    final response = await http
        .get(Uri.parse('http://192.168.1.107:3001/managements/')); 

        Map<String, dynamic>? data = json.decode(response.body);
       
        _gerencias.clear();
        data!['managements'].forEach((areaData){
          _gerencias.add(Gerencia(areaData['IDGerencia'], areaData['Descricao']));
        });
      
      notifyListeners();

    }
}
