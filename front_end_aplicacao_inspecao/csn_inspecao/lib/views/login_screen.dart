import 'package:csn_inspecao/exceptions/exceptions.dart';
import 'package:csn_inspecao/providers/usuario_provider.dart';
import 'package:csn_inspecao/views/inspection_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _formData = {};
  void _showException(message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ocorreu um erro'),
        content: Text(message),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'))
        ],
      ),
    );
  }

  var obscureText = true;
  bool _isLoading = false;
  _validateForms() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
    });

    _formKey.currentState!.save();
    try {
      var user = await Provider.of<UsuarioProvider>(context, listen: false)
          .findUserByMatriculaAndPassword(
              _formData['matricula'], _formData['senha']);
    print('Print IDGERENCIA ${user?.IDGerencia}');
      if (user != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => InspectionScreen(
                  user: user,
                )));
      } else {
        _showException('Usuário não encontrado');
      }
    } on AppExceptions catch (e) {
      _showException(e.toString());
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Image.asset(
              "assets/images/logo_csn.png",
            ),
            Form(
                key: _formKey,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Column(
                    children: [
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => ((value == null || value.isEmpty)
                            ? "This field can't be empty"
                            : null),
                        decoration: const InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            size: 35,
                            color: Color.fromRGBO(0, 48, 135, 1),
                          ),
                          border: OutlineInputBorder(),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(0, 48, 135, 1),
                                  width: 2)),
                          filled: false,
                          labelText: 'Mátricula',
                          labelStyle:
                              TextStyle(color: Color.fromRGBO(0, 48, 135, 1)),
                          hintText: 'Digite sua mátricula',
                        ),
                        onSaved: (value) => _formData['matricula'] = value,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        obscureText: obscureText,
                        validator: (value) =>
                            ((value == null || value.isEmpty || value == "")
                                ? "This field can't be empty"
                                : null),
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                            icon: Icon(obscureText
                                ? Icons.visibility_off
                                : Icons.visibility),
                            iconSize: 35,
                            color: const Color.fromRGBO(0, 48, 135, 1),
                          ),
                          prefixIcon: const Icon(
                            Icons.vpn_key,
                            size: 35,
                            color: Color.fromRGBO(0, 48, 135, 1),
                          ),
                          border: const OutlineInputBorder(),
                          enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(0, 48, 135, 1),
                                  width: 2)),
                          filled: false,
                          labelText: 'Senha',
                          labelStyle: const TextStyle(
                              color: Color.fromRGBO(0, 48, 135, 1)),
                          hintText: 'Digite sua senha',
                        ),
                        onSaved: (value) => _formData['senha'] = value,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : Directionality(
                              textDirection: TextDirection.rtl,
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * .70,
                                height: 65,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromRGBO(0, 48, 135, 1)),
                                  onPressed: () => _validateForms(),
                                  label: const Text(
                                    'Entrar',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    size: 30,
                                  ),
                                ),
                              ),
                            )
                    ],
                  ),
                ))
          ],
        ),
      ),
    ));
  }
}
