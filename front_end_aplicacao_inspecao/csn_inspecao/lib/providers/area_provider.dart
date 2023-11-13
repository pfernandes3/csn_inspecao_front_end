import 'package:csn_inspecao/models/area.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AreaProvider with ChangeNotifier {
  final List<Area> _areas = [];
  List<Area> get areas => [..._areas];

  Future<void> loadAreas() async{
    final response = await http
        .get(Uri.parse('http://192.168.1.107:3001/areas/')); 

        Map<String, dynamic>? data = json.decode(response.body);
        _areas.clear();
        data!['areas'].forEach((areaData){
         
          _areas.add(Area(id: areaData['IDArea'], descricao: areaData['Descricao']));
        });



  
      notifyListeners();
      return Future.value();
    }
  }

// (data['inspection']).forEach((inspectionData) {
//         _areas.add()
//       });
