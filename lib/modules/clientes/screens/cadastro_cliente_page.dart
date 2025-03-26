// lib/modules/clientes/screens/cadastro_cliente_page.dart
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class CadastroClientePage extends StatefulWidget {
  final Function(Map<String, String>) onClienteCadastrado;

  CadastroClientePage({required this.onClienteCadastrado});

  @override
  _CadastroClientePageState createState() => _CadastroClientePageState();
}

class _CadastroClientePageState extends State<CadastroClientePage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _aniversarioController = TextEditingController();
  final _cepController = TextEditingController();
  final _ruaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  final _complementoController = TextEditingController();
  String _comoConheceu = 'Indicação';

  final _telefoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  bool _cepValido = true;
  bool _telefoneValido = true;
  bool _aniversarioValido = true;

  Future<void> _buscarCep() async {
    setState(() => _cepValido = true); // Resetar a validação
    final cep = _cepController.text.replaceAll(RegExp(r'[^0-9]'), '');
    if (cep.length != 8) {
      _mostrarSnackBar('CEP inválido');
      setState(() => _cepValido = false);
      return;
    }

    final response = await http.get(
      Uri.parse('https://viacep.com.br/ws/$cep/json/'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['erro'] == true) {
        _mostrarSnackBar('CEP não encontrado');
        setState(() => _cepValido = false);
        return;
      }
      _preencherEndereco(data);
    } else {
      _mostrarSnackBar('Erro ao buscar CEP');
      setState(() => _cepValido = false);
    }
  }

  void _mostrarSnackBar(String mensagem) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(mensagem)));
  }

  void _preencherEndereco(Map<String, dynamic> data) {
    setState(() {
      _ruaController.text = data['logradouro'];
      _bairroController.text = data['bairro'];
      _cidadeController.text = data['localidade'];
      _estadoController.text = data['uf'];
    });
  }

  void _cadastrarCliente() {
    setState(() {
      _telefoneValido = _telefoneController.text.length == 15;
      _aniversarioValido = _validarData(_aniversarioController.text);
    });

    if (_formKey.currentState!.validate() &&
        _telefoneValido &&
        _aniversarioValido) {
      final novoCliente = {
        'nome': _nomeController.text,
        'telefone': _telefoneController.text,
        'cep': _cepController.text,
        'rua': _ruaController.text,
        'numero': _numeroController.text,
        'bairro': _bairroController.text,
        'cidade': _cidadeController.text,
        'estado': _estadoController.text,
        'complemento': _complementoController.text,
        'comoConheceu': _comoConheceu,
        'aniversario': _aniversarioController.text,
      };

      widget.onClienteCadastrado(novoCliente);

      Navigator.of(context).pop();
      _mostrarSnackBar('Cliente cadastrado com sucesso');
    } else {
      _mostrarSnackBar('Por favor, preencha todos os campos corretamente.');
    }
  }

  bool _validarData(String data) {
    if (data.isEmpty) return false;
    try {
      DateFormat('dd/MM/yyyy').parseStrict(data);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Novo Cliente'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _construirCampoTexto('Nome', _nomeController),
              _construirCampoTexto(
                'Telefone',
                _telefoneController,
                inputFormatters: [_telefoneMask],
                keyboardType: TextInputType.phone,
                errorText: _telefoneValido ? null : 'Telefone inválido',
              ),
              _construirCampoCep(),
              _construirCampoTexto('Rua', _ruaController),
              _construirCampoTexto(
                'Número',
                _numeroController,
                keyboardType: TextInputType.number,
              ),
              _construirCampoTexto('Bairro', _bairroController),
              _construirCampoTexto('Cidade', _cidadeController),
              _construirCampoTexto('Estado', _estadoController),
              _construirCampoTexto('Complemento', _complementoController),
              _construirCampoData(
                'Data de Aniversário (dd/MM/yyyy)',
                _aniversarioController,
                errorText:
                    _aniversarioValido ? null : 'Data inválida (dd/MM/yyyy)',
              ),
              _construirDropdownComoConheceu(),
            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancelar'),
        ),
        ElevatedButton(onPressed: _cadastrarCliente, child: Text('Cadastrar')),
      ],
    );
  }

  Widget _construirCampoTexto(
    String label,
    TextEditingController controller, {
    List<TextInputFormatter>? inputFormatters, // Especifica o tipo correto aqui
    TextInputType? keyboardType,
    String? errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, errorText: errorText),
        inputFormatters: inputFormatters,
        keyboardType: keyboardType,
        validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
      ),
    );
  }

  Widget _construirCampoCep() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _cepController,
              decoration: InputDecoration(
                labelText: 'CEP',
                errorText: _cepValido ? null : 'CEP inválido',
              ),
              keyboardType: TextInputType.number,
              validator: (value) => value!.isEmpty ? 'Campo obrigatório' : null,
            ),
          ),
          IconButton(onPressed: _buscarCep, icon: Icon(Icons.search)),
        ],
      ),
    );
  }

  Widget _construirDropdownComoConheceu() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: _comoConheceu,
        items:
            <String>[
                  'Indicação',
                  'Redes Sociais',
                  'Google',
                  'Anúncio',
                  'Outros',
                ]
                .map(
                  (String value) => DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  ),
                )
                .toList(),
        onChanged: (value) {
          setState(() {
            _comoConheceu = value!;
          });
        },
        decoration: InputDecoration(labelText: 'Como conheceu a loja'),
      ),
    );
  }

  Widget _construirCampoData(
    String label,
    TextEditingController controller, {
    String? errorText,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, errorText: errorText),
        keyboardType: TextInputType.datetime,
        inputFormatters: [
          MaskTextInputFormatter(
            mask: '##/##/####',
            filter: {"#": RegExp(r'[0-9]')},
          ),
        ],
        validator: (value) {
          if (value!.isEmpty) {
            return 'Campo obrigatório';
          }
          try {
            DateFormat('dd/MM/yyyy').parseStrict(value);
            return null;
          } catch (e) {
            return 'Data inválida (dd/MM/yyyy)';
          }
        },
      ),
    );
  }
}
