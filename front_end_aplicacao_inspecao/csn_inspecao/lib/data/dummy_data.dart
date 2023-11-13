import 'package:csn_inspecao/models/area.dart';
import 'package:csn_inspecao/models/cargo.dart';
import 'package:csn_inspecao/models/usuario.dart';

import '../models/gerencia.dart';
import '../models/inspections.dart';
import '../models/items.dart';

List<Inspection> DUMMY_INSPECTION = [
  Inspection(
    
    isRevisado: true,
    area: DUMMY_AREA[0],
    dataFimInspecao: DateTime.now().add(const Duration(days: 8)),
    percentualRM: 75,
    gerencia: DUMMY_GERENCIA[0], // Gerencia 1
    items: [
      Item(3, 'CODIGO-FONTE', 'DEV TEAM', 'RFID', 'QUA', true, false, true,
          true,true, 95, 'url5', 'ur6'),
      Item(3, 'BANCO DE DADOS', 'DEV TEAM', 'RFID', 'QUA', true, false, true,
          true,true, 85, 'url6', 'ur7'),
      Item(3, 'TESTES AUTOMATIZADOS', 'DEV TEAM', 'RFID', 'QUA', true, false,
          true, true, true,70, 'url7', 'ur8'),
    ],
    Status: 'AGUARDANDO_REVISAO',
    id: 3,
    dataInicioInspecao: DateTime.now().subtract(const Duration(days: 5)),
    usuario: DUMMY_USERS[0],
    DataRevisaoInspecao: null,
  )];

List<Gerencia> DUMMY_GERENCIA = [
  Gerencia(1, 'Recursos Humanos'),
  Gerencia(2, 'Desenvolvimento de Produto'),
  Gerencia(3, 'Operações Logísticas'),
  Gerencia(4, 'Marketing e Vendas'),
  Gerencia(5, 'Suporte Técnico'),
];

List<Area> DUMMY_AREA = [
  Area(id: 1, descricao: 'ACADEMIA DE TI'),
  Area(id: 2, descricao: 'SUPORTE TÉCNICO'),
  Area(id: 3, descricao: 'DESENVOLVIMENTO'),
  Area(id: 4, descricao: 'TESTES'),
  Area(id: 5, descricao: 'INFRAESTRUTURA'),
];

List<Usuario> DUMMY_USERS = [
  Usuario(
    IDGerencia: 6,
    id: 1,
    senha: '123',
    matricula: '192998',
    nome: 'PEDRO VASCONCELOS',
    cargo: Cargo(Descricao: 'CHEFE DE TI'),
  ),
  Usuario(
    IDGerencia: 4,
    id: 2,
    senha: '456',
    matricula: '192997',
    nome: 'ANA SILVA',
    cargo: Cargo(Descricao: 'ANALISTA DE SUPORTE'),
  ),
  Usuario(
    IDGerencia: 3,
    id: 3,
    senha: '789',
    matricula: '192996',
    nome: 'MARCOS OLIVEIRA',
    cargo: Cargo(Descricao: 'DESENVOLVEDOR SENIOR'),
  ),
  Usuario(
    IDGerencia: 1,
    id: 4,
    senha: 'abc',
    matricula: '192995',
    nome: 'MARIA SILVEIRA',
    cargo: Cargo(Descricao: 'ANALISTA DE QUALIDADE'),
  ),
  Usuario(
    IDGerencia: 2,
    id: 5,
    senha: 'xyz',
    matricula: '192994',
    nome: 'LUCIA FERNANDES',
    cargo: Cargo(Descricao: 'ANALISTA DE RECURSOS HUMANOS'),
  ),
];
