import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'main.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  TextEditingController ufController = TextEditingController();
  TextEditingController localidadeController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  List<Address> addresses = [];

  void fetchAddresses() async {
    String uf = ufController.text;
    String localidade = localidadeController.text;
    String bairro = bairroController.text;

    if (localidade.length < 3 || bairro.length < 3) {
      return;
    }

    String url = "https://viacep.com.br/ws/$uf/$localidade/$bairro/json/";
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      setState(() {
        addresses = data.map((json) => Address.fromJson(json)).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Image.asset("images/logo.png", height: 125, width: 125),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(30.0),
          decoration: BoxDecoration(
              color: Colors.black, borderRadius: BorderRadius.circular(20.0)),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0)),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextField(
                    controller: ufController,
                    style: TextStyle(color: Colors.orange),
                    decoration: InputDecoration(labelText: '  UF',
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0)),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextField(
                    controller: localidadeController,
                    style: TextStyle(color: Colors.orange),
                    decoration: InputDecoration(
                        labelText: '  Cidade (mínimo 3 caracteres)',
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.0)),
                child: Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: TextField(
                    controller: bairroController,
                    style: TextStyle(color: Colors.orange),
                    decoration: InputDecoration(
                        labelText: '  Bairro (mínimo 3 caracteres)'),
                  ),
                ),
              ),
              SizedBox(height: 15),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: fetchAddresses,
                  child: Text('Buscar Endereços'),
                ),
              ),
              const SizedBox(height: 8),
              Column(
                children: addresses.map((address) {
                  return Container(
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15.0)),
                    child: ListTile(
                      title: Text(address.logradouro),
                      subtitle: Text(
                          '${address.bairro}, ${address.localidade}/${address.uf}'),
                      trailing: Text('CEP: ${address.cep}'),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
