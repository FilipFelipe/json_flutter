import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int contagem = 0;
  String crack = "true";
  List data;
  Future<String> getJSONData(page,crack) async {
    
    print(page);
    final String url =
        "https://api.crackwatch.com/api/games?page=$page&is_cracked=$crack";
    print(url);
    var response = await http.get(url);
    setState(() {
      data = json.decode(response.body);
    });

    return "Sucesso";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CrackWatch Games"),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      body: _listView(0),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.exit_to_app),
        onPressed: () => {getJSONData((contagem = contagem + 1),true)},
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.black87,
              ),
              
            ),
            ListTile(
              title: Text('Não crackeado'),
              onTap: () {
               getJSONData((0),false);
              },
            ),
            ListTile(
              title: Text('Crackeados'),
              onTap: () {
               getJSONData((1),false);
              },
            ),
          ],
        ),
      ),
    );
  }

  _listView(int op) {
    return ListView.builder(
      itemCount: data == null ? 0 : data.length,
      itemBuilder: (context, index) {
        return _exibirImagem(data[index]);
      },
    );
  }

  _exibirImagem(dynamic item) => Container(
      decoration: BoxDecoration(color: Colors.white),
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: item['image'],
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
            fadeOutDuration: Duration(seconds: 2),
            fadeInDuration: Duration(seconds: 2),
          ),
          _criaLinhaTexto(item),
          Container(
            width: 1200.0,
            height: 30.0,
            child: RaisedButton(
              onPressed: () => {},
              color: Color(0XFFFF0000),
              child: Row(
                children: <Widget>[
                  Text(
                    'Mais info',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ],
      ));

  _criaLinhaTexto(dynamic item) {
    return ListTile(
      title: Text(item['title'] == null ? '' : item['title']),
      subtitle: Text("Data de lançamento: " +
          item['releaseDate'].toString() +
          " Seguidores: " +
          item['followersCount'].toString() +
          " link: " +
          item['url'].toString()),
    );
  }

  @override
  void initState() {
    super.initState();
    this.getJSONData(0,true);
  }
}
