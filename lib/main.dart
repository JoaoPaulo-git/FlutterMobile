import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MaterialApp(
      title: "Previsão do Tempo",
      home: PaginaInicial(),
    ));

class PaginaInicial extends StatefulWidget {
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<PaginaInicial> {
  var temp;
  var description;
  var currently;
  var humidity;
  var windSpeed;
  var codigoPostal;
  var nomeCidade;
  var estado;
  var lon;
  var lat;

  TextEditingController cep = TextEditingController();

  Future getcep() async {
    http.Response response =
        await http.get("https://viacep.com.br/ws/${cep.text}/json/");
    var results = jsonDecode(response.body);

    setState(() {
      this.codigoPostal = results['cep'];
      this.nomeCidade = results['localidade'];
      this.estado = results['uf'];
    });

    this.getWeather();
  }

  void initState() {
    super.initState();
    this.getWeather();
  }

  Future getWeather() async {
    http.Response response = await http.get(
        "http://api.openweathermap.org/data/2.5/weather?q=$nomeCidade&lang=pt_br&appid=0163a82e979110a64e9b565f0a70167b");
    var results = jsonDecode(response.body);

    setState(() {
      this.temp = results['main']['temp'];
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windSpeed = results['wind']['speed'];
      this.lon = results['coord']['lon'];
      this.lat = results['coord']['lat'];
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      Container(
        height: MediaQuery.of(context).size.height / 3,
        width: MediaQuery.of(context).size.width,
        color: Colors.blue,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15, right: 15, bottom: 10.0),
                    child: TextFormField(
                      controller: cep,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: "Digite um Cep",
                        labelStyle:
                            TextStyle(fontSize: 18, color: Colors.white),
                        hintText: "xxxxx-xxx",
                        hintStyle: TextStyle(fontSize: 12, color: Colors.white),
                      ),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    height: 100,
                    padding: EdgeInsets.only(top: 35),
                    alignment: Alignment.center,
                    child: IconButton(
                      onPressed: getcep,
                      icon: FaIcon(FontAwesomeIcons.globe,
                          color: Colors.white, size: 64),
                      padding: EdgeInsets.only(bottom: 45, right: 45),
                    ),
                  ),
                ],
              ),
            ]),
      ),
      Expanded(
          child: Padding(
              padding: EdgeInsets.all(20.0),
              child: ListView(
                children: <Widget>[
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                    title: Text("Temperatura"),
                    trailing: Text(
                        temp != null ? temp.toString() + "\u00B0" : "Loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.cloud),
                    title: Text("Clima"),
                    trailing: Text(description != null
                        ? description.toString()
                        : "Loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.sun),
                    title: Text("Umidade"),
                    trailing: Text(humidity != null
                        ? humidity.toString() + " %"
                        : "Loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.wind),
                    title: Text("Velocidade do Vento"),
                    trailing: Text(windSpeed != null
                        ? windSpeed.toString() + " Km/h"
                        : "Loading"),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.city),
                    title: Text("Cidade"),
                    trailing: Text(
                      nomeCidade.toString(),
                    ),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.landmark),
                    title: Text("Estado"),
                    trailing:
                        Text(estado != null ? estado.toString() : "Loading"),
                  ),
                ],
              )))
    ]));
  }
}
