import 'package:csn_inspecao/models/cargo.dart';
import 'package:csn_inspecao/models/usuario.dart';
import 'package:csn_inspecao/providers/area_provider.dart';
import 'package:csn_inspecao/providers/gerencia_provider.dart';
import 'package:csn_inspecao/providers/inspection_provider.dart';
import 'package:csn_inspecao/providers/usuario_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/area.dart';
import '../models/gerencia.dart';
import '../models/inspections.dart';
import '../models/items.dart';
import '../utils/AppRoutes.dart';

class InspectionFormScreen extends StatefulWidget {
  InspectionFormScreen({super.key});

  bool isVisualizcao = false;
  @override
  State<InspectionFormScreen> createState() => _InspectionFormScreenState();
}

class _InspectionFormScreenState extends State<InspectionFormScreen> {
  final _form = GlobalKey<FormState>();
  final _formData = {};
  List<Item> currentList = [];
  Gerencia? selectedGerencia;
  Area? selectedArea;
  var gerencias = [];
  var areas = [];
  var idgerencia;
  bool isLoading = false;
  DateTime? dataInicio;
  bool isVisualizacao2 = false;
  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final Map<String, dynamic>? args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      final Inspection? inspection = args?['inspection'];
      final bool isVisualizacao = args?['isVisualizacao'];
      isVisualizacao2 = isVisualizacao;
      print(isVisualizacao);
      if (inspection != null) {
        _formData['IDInspecao'] = inspection.id;
        _formData['Matricula'] = inspection.usuario.matricula;
        _formData['Status'] = inspection.Status;
        _formData['Data'] = inspection.dataInicioInspecao;
        _formData['PercentualRM'] = inspection.percentualRM;
        dataInicio = inspection.dataInicioInspecao;
        currentList = inspection.items;
        idgerencia = inspection.usuario.IDGerencia;
        print('ID DA GERENCIA $idgerencia');
        await Provider.of<GerenciaProvider>(context, listen: false)
            .loadGerencias();
        gerencias =
            Provider.of<GerenciaProvider>(context, listen: false).gerencias;
        selectedGerencia = gerencias
            .firstWhere((element) => element.id == inspection.gerencia.id);
        await Provider.of<AreaProvider>(context, listen: false).loadAreas();
        areas = Provider.of<AreaProvider>(context, listen: false).areas;
        selectedArea =
            areas.firstWhere((element) => element.id == inspection.area.id);
      } else {
        _formData['Matricula'] = "";
        _formData['Status'] = "PENDENTE";
        _formData['Data'] = DateTime.now();
        _formData['PercentualRM'] = 0;
        selectedGerencia = null;
        selectedArea = null;
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<AreaProvider>(context, listen: false).loadAreas();
    Provider.of<GerenciaProvider>(context, listen: false).loadGerencias();
  }

  void _deleteItem(id) {
    setState(() {
      currentList.removeWhere((element) => element.id == id);
    });
  }

  void _saveForm() async {
    if (_form.currentState!.validate()) {
      _form.currentState!.save();
    }
    setState(() {
      isLoading = true;
    });
    var user = await Provider.of<UsuarioProvider>(context, listen: false)
        .returnUser(_formData['Matricula']);
    final newInspection = Inspection(
        DataRevisaoInspecao: idgerencia != null ? DateTime.now() : null,
        isRevisado: false,
        area: Area(id: selectedArea!.id, descricao: selectedArea!.descricao),
        dataFimInspecao: idgerencia != null ? DateTime.now() : null,
        percentualRM: 100,
        gerencia: Gerencia(selectedGerencia!.id, selectedGerencia!.Descricao),
        items: currentList,
        Status: idgerencia != null ? "FINALIZADA" : _formData['Status'],
        id: 83,
        dataInicioInspecao: DateTime.now(),
        usuario: Usuario(
            IDGerencia: 1,
            id: user!.id,
            senha: user.senha,
            matricula: user.matricula,
            nome: user.nome,
            cargo: Cargo(Descricao: 'CHEFIA')));

    final inspections =
        Provider.of<InspectionsProvider>(context, listen: false);

    try {
      if (_formData['IDInspecao'] == null) {
        print('Entrei no update');
        await inspections.addInspection(newInspection);
        idgerencia != null
            ? await inspections.loadInspectionsByIdGerencia(idgerencia)
            : await inspections.loadInspections(newInspection.usuario.id);
      } else {
        final newInspection2 = Inspection(
            DataRevisaoInspecao: null,
            isRevisado: false,
            area:
                Area(id: selectedArea!.id, descricao: selectedArea!.descricao),
            dataFimInspecao: idgerencia != null ? DateTime.now() : null,
            percentualRM: 100,
            gerencia:
                Gerencia(selectedGerencia!.id, selectedGerencia!.Descricao),
            items: currentList,
            Status: idgerencia != null ? "FINALIZADA" : _formData['Status'],
            id: _formData['IDInspecao'],
            dataInicioInspecao: dataInicio!,
            usuario: Usuario(
                IDGerencia: 1,
                id: user.id,
                senha: user.senha,
                matricula: user.matricula,
                nome: user.nome,
                cargo: Cargo(Descricao: 'CHEFIA')));
        await inspections.updateInspection(newInspection2);
       idgerencia != null
            ? await inspections.loadInspectionsByIdGerencia(idgerencia)
            : await inspections.loadInspections(newInspection2.usuario.id);
      }
      Navigator.of(context).pop();
    } catch (err) {
      await showDialog<void>(
          context: context,
          builder: (ctx) => AlertDialog(
                title: const Text('Ocorreu um erro!'),
                content: const Text(
                    'Ocorreu um erro inesperado ao salvar o produto!'),
                actions: [
                  TextButton(
                    child: const Text('Ok'),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  _addItem(Item item) {
    print(item.descricao);
    currentList.clear();
    setState(() {
      currentList.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    areas = Provider.of<AreaProvider>(context).areas;
    gerencias = Provider.of<GerenciaProvider>(context).gerencias;
    final scaffold = ScaffoldMessenger.of(context);

    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        width: 80,
        height: 80,
        child: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(0, 48, 135, 1),
          onPressed: () async {
            final newItem = await Navigator.of(context)
                .pushNamed(AppRoutes.ITEM_FORM_SCREEN, arguments: {
              'item': null,
              'isVisualizacao': false,
            });
            _addItem(newItem as Item);
          },
          child: const Icon(
            Icons.add,
            size: 50,
            color: Colors.white,
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Cadastro de Inspeção'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                enabled: isVisualizacao2 ? false : true,
                initialValue: _formData['Matricula'],
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onSaved: (value) => _formData['Matricula'] = value as String,
                validator: (value) =>
                    ((value == null || value.isEmpty || value == "")
                        ? "This field can't be empty"
                        : null),
                decoration: const InputDecoration(
                  prefixIcon: Icon(
                    Icons.person,
                    size: 35,
                    color: Color.fromRGBO(0, 48, 135, 1),
                  ),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(0, 48, 135, 1), width: 2)),
                  filled: false,
                  labelText: 'Matricula',
                  labelStyle: TextStyle(
                      color: Color.fromRGBO(0, 48, 135, 1), fontSize: 25),
                  hintText: 'Digite sua Matricula',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<Gerencia>(
                value: selectedGerencia,
                onChanged: isVisualizacao2
                    ? null
                    : (value) => setState(() => selectedGerencia = value),
                items: [
                  // Item padrão "SELECIONE"
                  const DropdownMenuItem<Gerencia>(
                    value: null,
                    child: Text(
                      'SELECIONE',
                      style: TextStyle(color: Color.fromRGBO(0, 48, 135, 1)),
                    ),
                  ),
                  // Restante das gerências
                  ...gerencias.map((gerencia) {
                    return DropdownMenuItem<Gerencia>(
                      value: gerencia,
                      child: Text(
                        gerencia.Descricao,
                        style: const TextStyle(
                            color: Color.fromRGBO(0, 48, 135, 1)),
                      ),
                    );
                  }).toList(),
                ],
                decoration: const InputDecoration(
                  labelText: 'GERÊNCIA',
                  labelStyle: TextStyle(
                      color: Color.fromRGBO(0, 48, 135, 1), fontSize: 25),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(0, 48, 135, 1),
                      width: 2,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.leaderboard,
                    size: 35,
                    color: Color.fromRGBO(0, 48, 135, 1),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              DropdownButtonFormField<Area>(
                value: selectedArea,
                onChanged: isVisualizacao2
                    ? null
                    : (value) => setState(() => selectedArea = value),
                items: [
                  // Item padrão "SELECIONE"
                  const DropdownMenuItem<Area>(
                    value: null,
                    child: Text('SELECIONE',
                        style: TextStyle(color: Color.fromRGBO(0, 48, 135, 1))),
                  ),
                  // Restante das gerências
                  ...areas.map((area) {
                    return DropdownMenuItem<Area>(
                      value: area,
                      child: Text(
                        area.descricao,
                        style: const TextStyle(
                            color: Color.fromRGBO(0, 48, 135, 1)),
                      ),
                    );
                  }).toList(),
                ],
                decoration: const InputDecoration(
                  labelText: 'ÁREA',
                  labelStyle: TextStyle(
                      color: Color.fromRGBO(0, 48, 135, 1), fontSize: 25),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromRGBO(0, 48, 135, 1),
                      width: 2,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.apartment,
                    size: 35,
                    color: Color.fromRGBO(0, 48, 135, 1),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 0,
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Data Da Inspeção:',
                          style: TextStyle(fontSize: 25),
                        ),
                        Chip(
                          backgroundColor: const Color.fromRGBO(0, 48, 135, 2),

                          label: Text(DateFormat('dd/MM/yyyy hh:mm')
                              .format(_formData['Data'])),
                          labelStyle: const TextStyle(
                              color: Colors.white,
                              fontSize:
                                  20), // Ajuste o tamanho do texto conforme necessário
                          padding: const EdgeInsets.symmetric(
                              horizontal: 45, vertical: 8),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 0,
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Status:',
                          style: TextStyle(fontSize: 25),
                        ),
                        Chip(
                          backgroundColor: const Color.fromRGBO(0, 48, 135, 2),

                          label: Text('${_formData['Status']}'),
                          labelStyle: const TextStyle(
                              color: Colors.white,
                              fontSize:
                                  20), // Ajuste o tamanho do texto conforme necessário
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  (_formData['Status'] == 'AGUARDANDO_REVISAO')
                                      ? 14
                                      : 70,
                              vertical: 8),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 0,
                  child: ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Percentual RCM:',
                          style: TextStyle(fontSize: 25),
                        ),
                        Chip(
                          backgroundColor: const Color.fromRGBO(0, 48, 135, 2),
                          label: Text('${_formData['PercentualRM']} %'),
                          labelStyle: const TextStyle(
                              color: Colors.white,
                              fontSize:
                                  20), // Ajuste o tamanho do texto conforme necessário
                          padding: const EdgeInsets.symmetric(
                              horizontal: 92, vertical: 8),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              currentList.isEmpty
                  ? const Center(
                      child: Text('Não possui itens'),
                    )
                  : Flexible(
                      child: ListView.builder(
                        itemCount: currentList.length,
                        itemBuilder: (context, index) {
                          return Card(
                              elevation: 10,
                              margin: const EdgeInsets.all(8),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: ListTile(
                                    leading: CircleAvatar(
                                      radius: 30,
                                      child: Text(currentList[index]
                                          .nivelRisco
                                          .toString()),
                                    ),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          height: 30,
                                          child: Text(
                                              currentList[index].descricao),
                                        ),
                                      ],
                                    ),
                                    trailing: SizedBox(
                                      width: 170,
                                      child: Row(children: [
                                        IconButton(
                                            iconSize: 35,
                                            icon: Icon(
                                              Icons.visibility,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                            onPressed: () =>
                                                Navigator.of(context).pushNamed(
                                                    AppRoutes.ITEM_FORM_SCREEN,
                                                    arguments: {
                                                      'item':
                                                          currentList[index],
                                                      'isVisualizacao': true,
                                                    })),
                                        IconButton(
                                            iconSize: 35,
                                            icon: Icon(
                                              Icons.edit,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                            ),
                                            onPressed: () async {
                                              final newItem =
                                                  await Navigator.of(context)
                                                      .pushNamed(
                                                          AppRoutes
                                                              .ITEM_FORM_SCREEN,
                                                          arguments: {
                                                    'item': currentList[index],
                                                    'isVisualizacao': false
                                                  });
                                              _addItem(newItem as Item);
                                            }),
                                        IconButton(
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    AlertDialog(
                                                  title: const Text(
                                                      'Excluir Item'),
                                                  content: const Text(
                                                      'Tem Certeza?'),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(false);
                                                      },
                                                      child: const Text('Não'),
                                                    ),
                                                    TextButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(true);
                                                      },
                                                      child: const Text('Sim'),
                                                    ),
                                                  ],
                                                ),
                                              ).then((value) async {
                                                if (value) {
                                                  try {
                                                    _deleteItem(
                                                        currentList[index].id);
                                                  } catch (e) {
                                                    scaffold.showSnackBar(
                                                        SnackBar(
                                                            content: Text(
                                                                e.toString())));
                                                    // await showDialog<void>(
                                                    //     context: context,
                                                    //     builder: (ctx) => AlertDialog(
                                                    //           title: const Text('Ocorreu um erro!'),
                                                    //           content: Text(e.toString()),
                                                    //           actions: [
                                                    //             TextButton(
                                                    //               child: const Text('Ok'),
                                                    //               onPressed: () =>
                                                    //                   Navigator.of(context).pop(),
                                                    //             )
                                                    //           ],
                                                    //         ));
                                                  }
                                                }
                                              });
                                            },
                                            icon: Icon(
                                              Icons.delete,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                            )),
                                      ]

                                          // Adicione mais atributos conforme necessário
                                          ),
                                    )),
                              ));
                        },
                      ),
                    ),
              (currentList.isEmpty)
                  ? const SizedBox(
                      height: 250,
                    )
                  : const SizedBox.shrink(),
              currentList.isEmpty
                  ? const SizedBox.shrink()
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * .70,
                      height: 65,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromRGBO(0, 48, 135, 1)),
                        onPressed: () => _saveForm(),
                        label: Text(
                          idgerencia != null
                              ? 'Revisar Inspeção'
                              : 'Salvar Inspeção',
                          style: const TextStyle(fontSize: 20),
                        ),
                        icon: const Icon(
                          Icons.save,
                          size: 30,
                        ),
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
