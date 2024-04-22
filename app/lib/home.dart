import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _listadeTarefas = [];

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/dados.json");
  }

  _salvarTarefa(String titulo) async {
    var arquivo = await _getFile();
    
    Map<String, dynamic> tarefa = {
      "titulo": titulo,
      "realizada": false
    };

    _listadeTarefas.add(tarefa);

    String dados = jsonEncode(_listadeTarefas);
    arquivo.writeAsStringSync(dados);
  }

  _lerArquivo() async {
    try {
      final arquivo = await _getFile();
      String dados = await arquivo.readAsString();
      if (dados.isNotEmpty) {
        setState(() {
          _listadeTarefas = json.decode(dados);
        });
      }
    } catch (e) {
      setState(() {
        _listadeTarefas = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _lerArquivo();
  }

  @override
  Widget build(BuildContext context) {
    print("items:" + _listadeTarefas.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TO DO LIST-APP',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String novaTarefa = "";
              return AlertDialog(
                title: Text("Adicionar Tarefa"),
                content: TextField(
                  decoration: InputDecoration(labelText: "Digite a Sua Tarefa"),
                  onChanged: (text) {
                    novaTarefa = text;
                  },
                ),
                actions: [
                  TextButton(
                    child: Text("Cancelar"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: Text("Salvar"),
                    onPressed: () {
                      _salvarTarefa(novaTarefa);
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            },
          );
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _listadeTarefas.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_listadeTarefas[index]['titulo']),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
