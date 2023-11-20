import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:tutorial_api_git/repository_model.dart';
import 'package:http/http.dart' as http;


class HomeView2 extends StatelessWidget {
  //final _baseURL = 'localhost:8080/discipulos'; /* >>>> aqui é o EnPoint*/
  static const baseUrl = "fgfkl2ebzd.execute-api.us-east-1.amazonaws.com";

  const HomeView2({Key? key}) : super(key: key);

  Future<List<RepositoryModel>> loadRepositories() async {
    List<RepositoryModel> repositories = []; /* >>>> aqui iniciando a lista*/
    var url = Uri.https(baseUrl, "/dev/consultar_historico");
    final response = await http.get(url);
    var reposit = jsonDecode(response.body);
    var data = jsonDecode(reposit['historico']);
    if (response.statusCode == 200) {
      for (var i = 0; i < data.length; i++) {
        repositories.add(
          RepositoryModel(
            datahora: data[i]['datahora'],
            sala: data[i]['sala'],
          ),
        );
      }

      return repositories;
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade400,
        centerTitle: true,
        title: const Text('Relatório de histórico',
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<RepositoryModel>>(
              future: loadRepositories(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                List<RepositoryModel>? repositories = snapshot.data;

                return repositories != null && repositories.isNotEmpty
                    ? ListView.builder(
                  itemCount: repositories.length,
                  itemBuilder: (_, i) {
                    return Text(
                        style: const TextStyle(fontSize: 18,),
                        '\n' + repositories[i].datahora! + '   ' + repositories[i].sala!
                    );
                  },
                )
                    : const Center(
                  child: Text(
                      style: TextStyle(fontSize: 18,),
                      'Ops, sem Informação'
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
