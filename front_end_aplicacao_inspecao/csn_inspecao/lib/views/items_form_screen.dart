import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui';
import 'package:csn_inspecao/models/items.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ItemFormScreen extends StatefulWidget {
  ItemFormScreen({super.key});

  XFile? comprovante;
  XFile? comprovante2;
  @override
  State<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends State<ItemFormScreen> {
  final _form = GlobalKey<FormState>();
  final _formData = {};
  bool isVisualizacao2 = false;
  String selectedValue = ''; // Valor selecionado pelo usuário
  selecionarFoto() async {
    final ImagePicker picker = ImagePicker();
    try {
      XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        setState(() {
          widget.comprovante = file;
        });
      }
    } catch (e) {
      print(e);
    }
  }


  selecionarFoto2() async {
    final ImagePicker picker = ImagePicker();
    try {
      XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        setState(() {
          widget.comprovante2 = file;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  saveForm() {
    if (_form.currentState!.validate()) {
      _form.currentState!.save();
    }
    Item item = Item(
        1,
        _formData['Descricao'],
        _formData['LocalInspecao'],
        _formData['TAG'],
        _formData['REF'],
        true,
        false,
        true,
        false,
        false,
        20,
        widget.comprovante!.path,
        widget.comprovante2?.path);

    print(item.registroInicial);

    Navigator.of(context).pop(item);
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final Map<String, dynamic>? args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
      final Item? item = args?['item'];
      final bool isVisualizacao = args?['isVisualizacao'];
      isVisualizacao2 = isVisualizacao;

      if (item != null) {
        _formData['LocalInspecao'] = item.localInspecao;
        _formData['Descricao'] = item.descricao;
        _formData['TAG'] = item.TAG;
        _formData['REF'] = item.REF;
        selectedValue = "CR";
        print('URL ->${item.registroInicial}');
        widget.comprovante = XFile(item.registroInicial);
       widget.comprovante2 = item.registroFinal != null ? XFile(item.registroFinal!) : null;
      } else {
        _formData['LocalInspecao'] = "";
        _formData['Descricao'] = "";
        _formData['TAG'] = "";
        _formData['REF'] = "";
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  initialValue: _formData['LocalInspecao'],
                  enabled: isVisualizacao2 ? false : true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSaved: (value) =>
                      _formData['LocalInspecao'] = value as String,
                  validator: (value) =>
                      ((value == null || value.isEmpty || value == "")
                          ? "This field can't be empty"
                          : null),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.location_on,
                      size: 35,
                      color: Color.fromRGBO(0, 48, 135, 1),
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(0, 48, 135, 1), width: 2)),
                    filled: false,
                    labelText: 'Local Inspeção',
                    labelStyle: TextStyle(
                        color: Color.fromRGBO(0, 48, 135, 1), fontSize: 25),
                    hintText: 'Digite o Local',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  initialValue: _formData['Descricao'],
                   enabled: isVisualizacao2 ? false : true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSaved: (value) => _formData['Descricao'] = value as String,
                  validator: (value) =>
                      ((value == null || value.isEmpty || value == "")
                          ? "This field can't be empty"
                          : null),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.description,
                      size: 35,
                      color: Color.fromRGBO(0, 48, 135, 1),
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(0, 48, 135, 1), width: 2)),
                    filled: false,
                    labelText: 'Descrição',
                    labelStyle: TextStyle(
                        color: Color.fromRGBO(0, 48, 135, 1), fontSize: 25),
                    hintText: 'Descrição...',
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  initialValue: _formData['TAG'],
                   enabled: isVisualizacao2 ? false : true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSaved: (value) => _formData['TAG'] = value as String,
                  validator: (value) =>
                      ((value == null || value.isEmpty || value == "")
                          ? "This field can't be empty"
                          : null),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.tag,
                      size: 35,
                      color: Color.fromRGBO(0, 48, 135, 1),
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(0, 48, 135, 1), width: 2)),
                    filled: false,
                    labelText: 'TAG',
                    labelStyle: TextStyle(
                        color: Color.fromRGBO(0, 48, 135, 1), fontSize: 25),
                    hintText: 'TAG',
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                TextFormField(
                  initialValue: _formData['REF'],
                   enabled: isVisualizacao2 ? false : true,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  onSaved: (value) => _formData['REF'] = value as String,
                  validator: (value) =>
                      ((value == null || value.isEmpty || value == "")
                          ? "This field can't be empty"
                          : null),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(
                      Icons.security,
                      size: 35,
                      color: Color.fromRGBO(0, 48, 135, 1),
                    ),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromRGBO(0, 48, 135, 1), width: 2)),
                    filled: false,
                    labelText: 'REF',
                    labelStyle: TextStyle(
                        color: Color.fromRGBO(0, 48, 135, 1), fontSize: 25),
                    hintText: 'REF',
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    radioButton('CR'),
                    radioButton('SB'),
                    radioButton('MD'),
                    radioButton('AC'),
                    radioButton('DE'),
                  ],
                ),
                const SizedBox(
                  height: 50,
                ),
                ListTile(
                  leading: const Icon(Icons.attach_file),
                  title: const Text(
                    'Registro Inicial',
                    style: TextStyle(fontSize: 30),
                  ),
                  onTap: selecionarFoto,
                  trailing: widget.comprovante != null
                      ? Image.file(File(widget.comprovante!.path))
                      : null,
                ),
                const SizedBox(
                  height: 50,
                ),
                ListTile(
                  leading: const Icon(Icons.attach_file),
                  title: const Text(
                    'Registro Final',
                    style: TextStyle(fontSize: 30),
                  ),
                  onTap: selecionarFoto2,
                  trailing: widget.comprovante2 != null
                      ? Image.file(File(widget.comprovante2!.path))
                      : null,
                ),
                const SizedBox(
                  height: 80,
                ),
                isVisualizacao2 ? SizedBox.shrink()
                :
                SizedBox(
                  width: MediaQuery.of(context).size.width * .70,
                  height: 65,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(0, 48, 135, 1)),
                    onPressed: () => saveForm(),
                    label: const Text(
                      'SALVAR ITEM',
                      style: TextStyle(fontSize: 20),
                    ),
                    icon: const Icon(
                      Icons.save,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget radioButton(String value) {
    return Row(
      children: [
        Radio(
          fillColor: MaterialStateColor.resolveWith(
              (states) => Theme.of(context).colorScheme.primary),
          value: value,
          groupValue: selectedValue,
          onChanged: (newValue) {
            setState(() {
              selectedValue = newValue.toString();
              print(selectedValue);
            });
          },
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 30),
        ),
      ],
    );
  }
}
