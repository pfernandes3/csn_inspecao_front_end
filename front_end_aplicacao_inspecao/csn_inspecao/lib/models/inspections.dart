import 'package:csn_inspecao/models/area.dart';
import 'package:csn_inspecao/models/gerencia.dart';
import 'package:csn_inspecao/models/items.dart';
import 'package:csn_inspecao/models/usuario.dart';

class Inspection {
  final int id;
  final DateTime dataInicioInspecao;
  final DateTime? dataFimInspecao;
  final DateTime? DataRevisaoInspecao;
  final double percentualRM;
  final Gerencia gerencia;
  final Usuario usuario;
  final Area area;
  final bool isRevisado;
  final String? Status;
  final List<Item> items;

  Inspection(
    
      {required this.isRevisado,
      required this.area,
      required this.dataFimInspecao,
      required this.DataRevisaoInspecao,
      required this.percentualRM,
      required this.gerencia,
      required this.items,
      required this.Status,
      required this.id,
      required this.dataInicioInspecao,
      required this.usuario}
     );
}
