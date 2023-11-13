import 'dart:convert';

import 'package:csn_inspecao/models/area.dart';
import 'package:csn_inspecao/models/gerencia.dart';
import 'package:csn_inspecao/models/items.dart';
import 'package:flutter/material.dart';
import '../models/cargo.dart';
import '../models/inspections.dart';
import '../data/dummy_data.dart';
import 'package:http/http.dart' as http;

import '../models/usuario.dart';

class InspectionsProvider with ChangeNotifier {
  final List<Inspection> _item = [];
  final List<Inspection> _inspection = DUMMY_INSPECTION;
  List<Inspection> get inspection => [..._item];

  loadInspections(idUsuario) async {

    print('Entrei no loadInspection');
    final item = [
      Item(1, 'TESTES DE PERFORMANCE', 'QA', 'RFID', 'SEX', false, true, false,
          true, true, 75, 'url10', 'ur11')
    ];
    final area = [Area(id: 1, descricao: 'ACADEMIA DE TI')];
    final user = [
      Usuario(
        IDGerencia: 1,
        id: 1,
        senha: '123',
        matricula: '192998',
        nome: 'PEDRO VASCONCELOS',
        cargo: Cargo(Descricao: 'CHEFE DE TI'),
      )
    ];
    // final response2 =
    //     await http.post(Uri.parse('http://192.168.1.107:3001/inspections'),
    //         headers: {'Content-Type': 'application/json'},
    //         body: json.encode({
    //           'DataFimInspecao': DateTime.now().toIso8601String(),
    //           'DataInicioInspecao': DateTime.now().toIso8601String(),
    //           'DataRevisaoInspecao': null,
    //           'PercentualRM': 99.0,
    //           'IDGerencia': 2,
    //           'Status': "FINALIZADA",
    //           'isRevisado': 1,
    //           'ItemInspecao': item.map((e) => {
    //                 'Descricao': e.descricao,
    //                 'LocalInspecao': e.localInspecao,
    //                 'TAG': e.TAG,
    //                 'REF': e.REF,
    //                 'CR': 1,
    //                 'SB': e.SB,
    //                 'MD': e.MD,
    //                 'DE': e.DE,
    //                 'AC': e.AC,
    //                 'NivelRisco': e.nivelRisco,
    //                 'RegistroInicial': e.registroInicial,
    //                 'RegistroFinal': e.registroFinal,
    //               }).toList(),
    //           'UsuarioInspecao': user.map((e) => {'IDUsuario': e.id}).toList(),
    //           'AreaInspecao': area.map((e) => {'IDArea': e.id}).toList()
    //         }));

    final response = await http
        .get(Uri.parse('http://192.168.1.107:3001/inspections/$idUsuario'));

    Map<String, dynamic>? data = json.decode(response.body);
  print(data);
    _item.clear();
    if(data?['sucesso'] == false){
      return;
    }
    if (data != null) {
      print(data);
      (data['inspection']).forEach((inspectionData) {
        print(inspectionData['Status']);
        _item.add(Inspection(
          DataRevisaoInspecao: inspectionData['DataRevisaoInspecao'],
          isRevisado: inspectionData['isRevisado'],
          area: Area(id: inspectionData['IDArea'], descricao: 'TESTE'),
          dataFimInspecao: inspectionData['DataFimInspecao'] != null
              ? DateTime.parse(inspectionData['DataFimInspecao'])
              : DateTime.now(),
          percentualRM: inspectionData['PercentualRM'] != null
              ? inspectionData['PercentualRM'].toDouble()
              : 0.0,
          gerencia: Gerencia(inspectionData['IDGerencia'], 'DESCRICAO'),
          items: [
            Item(
              inspectionData['IDItemInspecao'],
              inspectionData['Descricao'],
              inspectionData['LocalInspecao'],
              inspectionData['TAG'],
              inspectionData['REF'],
              true,
              true,
              true,
              true,
              false,
              20,
              inspectionData['RegistroInicial'],
              inspectionData['RegistroFinal'],
            )
          ],
          Status: inspectionData['Status'],
          id: inspectionData[
              'IDInspecaoo'], // Não sei de onde você deseja obter esse valor
          dataInicioInspecao: inspectionData['DataInicioInspecao'] != null
              ? DateTime.parse(inspectionData['DataInicioInspecao'])
              : DateTime.now(),
          usuario: Usuario(
            IDGerencia: inspectionData['IDGerencia'],
            id: inspectionData['IDUsuario'],
            senha: inspectionData['Senha'],
            matricula: inspectionData['Matricula'],
            nome: inspectionData['NomeUsuario'],
            cargo: Cargo(Descricao: 'ANALISTA DE QUALIDADE'),
          ),
        ));
      });
    }

    notifyListeners();
  }
  loadInspectionsByIdGerencia(idgerencia) async {
    final item = [
      Item(1, 'TESTES DE PERFORMANCE', 'QA', 'RFID', 'SEX', false, true, false,
          true, true, 75, 'url10', 'ur11')
    ];
    final area = [Area(id: 1, descricao: 'ACADEMIA DE TI')];
    final user = [
      Usuario(
        IDGerencia: 1,
        id: 1,
        senha: '123',
        matricula: '192998',
        nome: 'PEDRO VASCONCELOS',
        cargo: Cargo(Descricao: 'CHEFE DE TI'),
      )
    ];

    final response = await http
        .get(Uri.parse('http://192.168.1.107:3001/inspections/byidgerencia/$idgerencia'));

    Map<String, dynamic>? data = json.decode(response.body);
  print('Entrei no by id');
  print(data);
  if(data?['sucesso'] == false){
      return;
    }
      _item.clear();
    if (data != null) {
      print(data);
      (data['inspection']).forEach((inspectionData) {
        print(inspectionData['Status']);
        _item.add(Inspection(
          DataRevisaoInspecao: inspectionData['DataRevisaoInspecao'],
          isRevisado: inspectionData['isRevisado'],
          area: Area(id: inspectionData['IDArea'], descricao: 'TESTE'),
          dataFimInspecao: inspectionData['DataFimInspecao'] != null
              ? DateTime.parse(inspectionData['DataFimInspecao'])
              : DateTime.now(),
          percentualRM: inspectionData['PercentualRM'] != null
              ? inspectionData['PercentualRM'].toDouble()
              : 0.0,
          gerencia: Gerencia(inspectionData['IDGerencia'], 'DESCRICAO'),
          items: [
            Item(
              inspectionData['IDItemInspecao'],
              inspectionData['Descricao'],
              inspectionData['LocalInspecao'],
              inspectionData['TAG'],
              inspectionData['REF'],
              true,
              true,
              true,
              true,
              false,
              20,
              inspectionData['RegistroInicial'],
              inspectionData['RegistroFinal'],
            )
          ],
          Status: inspectionData['Status'],
          id: inspectionData[
              'IDInspecaoo'], // Não sei de onde você deseja obter esse valor
          dataInicioInspecao: inspectionData['DataInicioInspecao'] != null
              ? DateTime.parse(inspectionData['DataInicioInspecao'])
              : DateTime.now(),
          usuario: Usuario(
            IDGerencia: inspectionData['IDGerencia'],
            id: inspectionData['IDUsuario'],
            senha: inspectionData['Senha'],
            matricula: inspectionData['Matricula'],
            nome: inspectionData['NomeUsuario'],
            cargo: Cargo(Descricao: 'ANALISTA DE QUALIDADE'),
          ),
        ));
      });
    }

    notifyListeners();
  }

  Future<void> deleteInspection(int producId) async {
    final index = _item.indexWhere((prod) => prod.id == producId);
    if (index >= 0) {
      final product = _item[index];

      _item.remove(product);
      notifyListeners();
      final response = await http
          .delete(Uri.parse('http://192.168.1.107:3001/inspections/$producId'));
      if (response.statusCode >= 400) {
        print('Erro encontrado');
        _item.insert(index, product);
        notifyListeners();
        throw ('Ocorreu um erro na exclusão do produto');
      }
    }
  }

  Future<void> addInspection(Inspection inspection) async {
    final area = [inspection.area];
    final usuario = [inspection.usuario];
    final response2 =
        await http.post(Uri.parse('http://192.168.1.107:3001/inspections'),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              'DataFimInspecao': inspection.dataFimInspecao != null
                  ? DateTime.now().toIso8601String()
                  : null,
              'DataInicioInspecao': DateTime.now().toIso8601String(),
              'DataRevisaoInspecao': inspection.DataRevisaoInspecao != null
                  ? DateTime.now().toIso8601String()
                  : null,
              'PercentualRM': inspection.percentualRM,
              'IDGerencia': inspection.gerencia.id,
              'Status': inspection.Status,
              'isRevisado': inspection.isRevisado,
              'ItemInspecao': inspection.items
                  .map((e) => {
                        'Descricao': e.descricao,
                        'LocalInspecao': e.localInspecao,
                        'TAG': e.TAG,
                        'REF': e.REF,
                        'CR': 1,
                        'SB': e.SB,
                        'MD': e.MD,
                        'DE': e.DE,
                        'AC': e.AC,
                        'NivelRisco': e.nivelRisco,
                        'RegistroInicial': e.registroInicial,
                        'RegistroFinal': e.registroFinal,
                      })
                  .toList(),
              'UsuarioInspecao':
                  usuario.map((e) => {'IDUsuario': e.id}).toList(),
              'AreaInspecao': area.map((e) => {'IDArea': e.id}).toList()
            }));
    notifyListeners();
  }

  Future<void> updateInspection(Inspection inspection) async {
    // Retorna o indice em caso de encontrar o produto, caso nao encontre retorna -1

    print(inspection.id);
    final index = _item.indexWhere((prod) => prod.id == inspection.id);
    print('Index -> $index');
    final area = [inspection.area];
    final usuario = [inspection.usuario];

    if (index >= 0) {
      print('Entrei no Indx');
      await http.put(
        Uri.parse('http://192.168.1.107:3001/inspections/${inspection.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'DataFimInspecao': inspection.usuario.IDGerencia != null
              ? DateTime.now().toIso8601String()
              : null,
          'DataInicioInspecao': inspection.dataInicioInspecao.toIso8601String(),
          'DataRevisaoInspecao': inspection.DataRevisaoInspecao != null
              ? DateTime.now().toIso8601String()
              : null,
          'PercentualRM': inspection.percentualRM,
          'IDGerencia': inspection.gerencia.id,
          'Status': inspection.Status,
          'isRevisado': inspection.isRevisado,
          'ItemInspecao': inspection.items
              .map((e) => {
                    'Descricao': e.descricao,
                    'LocalInspecao': e.localInspecao,
                    'TAG': e.TAG,
                    'REF': e.REF,
                    'CR': 1,
                    'SB': e.SB,
                    'MD': e.MD,
                    'DE': e.DE,
                    'AC': e.AC,
                    'NivelRisco': e.nivelRisco,
                    'RegistroInicial': e.registroInicial,
                    'RegistroFinal': e.registroFinal,
                  })
              .toList(),
          'UsuarioInspecao': usuario.map((e) => {'IDUsuario': e.id}).toList(),
          'AreaInspecao': area.map((e) => {'IDArea': e.id}).toList()
        }),
      );
    }

    notifyListeners();
  }
}
