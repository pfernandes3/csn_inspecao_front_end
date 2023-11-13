import 'package:csn_inspecao/providers/inspection_provider.dart';
import 'package:csn_inspecao/utils/AppRoutes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/inspections.dart';
import '../models/usuario.dart';
import '../widgets/orderItem.dart';

class InspectionScreen extends StatefulWidget {
  const InspectionScreen({super.key, this.user});
  final Usuario? user;
  @override
  State<InspectionScreen> createState() => _InspectionScreenState();
}

class _InspectionScreenState extends State<InspectionScreen> {
  final bool _expanded = false;
  _removeInspection(String id) {
    final inspection = Provider.of<InspectionsProvider>(context, listen: false)
        .deleteInspection(int.parse(id));
    // inspection.removeInspection(id);
  }

  _createInspection() {
    final inspections =
        Provider.of<InspectionsProvider>(context, listen: false);
  }

  _createSectionContainer(Widget child) {
    return Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(10)),
        width: 350,
        height: 250,
        child: child);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  print('IDGERENCIA ${widget.user?.IDGerencia}');
    widget.user?.IDGerencia != null
        ? Provider.of<InspectionsProvider>(context, listen: false)
            .loadInspectionsByIdGerencia(widget.user!.IDGerencia)
        : Provider.of<InspectionsProvider>(context, listen: false)
            .loadInspections(widget.user!.id);
  }

  @override
  Widget build(BuildContext context) {
    final List<Inspection> loadedInspections =
        Provider.of<InspectionsProvider>(context).inspection;
    final double itemsHeight = (loadedInspections.length * 25) + 10;
    return Scaffold(
      extendBody: true,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        width: 80,
        height: 80,
        child: FloatingActionButton(
          backgroundColor: const Color.fromRGBO(0, 48, 135, 1),
          onPressed: () => Navigator.of(context)
              .pushNamed(AppRoutes.INSPECTION_FORM_SCREEN, arguments: {
            'inspection': null,
            'isVisualizacao': false,
          }),
          child: const Icon(
            Icons.add,
            size: 50,
            color: Colors.white,
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title:  Text('Minhas Inspeções - ${widget.user?.nome}'),
      ),
      body: loadedInspections.isEmpty
          ? Center(
              child: Image.network(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTl4R6xvAxI9g4dTx1OxTzeLsXsiEu2lJptXQ&usqp=CAU'))
          : ListView.builder(
              itemCount: loadedInspections.length,
              itemBuilder: (context, index) => OrderItem(
                    order: loadedInspections[index],
                    onRemove: _removeInspection,
                  )),
    );
  }
}
