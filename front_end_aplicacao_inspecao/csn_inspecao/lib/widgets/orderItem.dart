import 'package:csn_inspecao/models/inspections.dart';
import 'package:csn_inspecao/providers/inspection_provider.dart';
import 'package:csn_inspecao/utils/AppRoutes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderItem extends StatefulWidget {
  const OrderItem({
    super.key,
    required this.order,
    required this.onRemove,
  });

  final Inspection order;
  final Function onRemove;

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    double itemsHeight = (widget.order.items.length * 42) + 10;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: _expanded ? itemsHeight + 90 : 100,
      child: Card(
          margin: const EdgeInsets.all(8),
          child: Column(
            children: [
              ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: Text("${widget.order.percentualRM}"),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 30,
                      child: Text(widget.order.usuario.nome),
                    ),
                    SizedBox(
                      height: 30,
                      child: Text('STATUS: ${widget.order.Status}'),
                    ),
                  ],
                ),
                subtitle: Text(
                  DateFormat('dd/MM/yyyy hh:mm')
                      .format(widget.order.dataInicioInspecao),
                  style: const TextStyle(fontSize: 18),
                ),
                trailing: SizedBox(
                  width: 220,
                  child: Row(
                    children: [
                      IconButton(
                          iconSize: 30,
                          icon: Icon(
                            Icons.visibility,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () => Navigator.of(context).pushNamed(
                                  AppRoutes.INSPECTION_FORM_SCREEN,
                                  arguments: {
                                    'inspection': widget.order,
                                    'isVisualizacao': true,
                                  })),
                      IconButton(
                        iconSize: 30,
                        icon: Icon(
                          Icons.edit,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        onPressed: () => Navigator.of(context).pushNamed(
                            AppRoutes.INSPECTION_FORM_SCREEN,
                            arguments: {
                              'inspection': widget.order,
                              'isVisualizacao': false,
                            }),
                      ),
                      IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Excluir Inspeção'),
                                content: const Text('Tem Certeza?'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: const Text('Não'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    child: const Text('Sim'),
                                  ),
                                ],
                              ),
                            ).then((value) async {
                              if (value) {
                                try {
                                  await Provider.of<InspectionsProvider>(
                                          context,
                                          listen: false)
                                      .deleteInspection(widget.order.id);
                                } catch (e) {
                                  scaffold.showSnackBar(
                                      SnackBar(content: Text(e.toString())));
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
                            color: Theme.of(context).colorScheme.error,
                          )),
                      IconButton(
                        iconSize: 30,
                        icon: _expanded
                            ? const Icon(Icons.expand_more)
                            : const Icon(Icons.expand_less),
                        onPressed: () {
                          setState(() {
                            _expanded = !_expanded;
                            print(_expanded);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: _expanded ? itemsHeight : 0,
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: ListView(
                  children: widget.order.items.map((product) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          product.descricao,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Nivel de Risco - ${product.nivelRisco}%',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          )),
    );
  }
}
