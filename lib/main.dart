import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(hintColor: const Color.fromARGB(255, 28, 255, 7), primaryColor: Colors.amber),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  Future<Map<String, dynamic>> fetchFinanceData() async {
    final response = await http.get(Uri.parse('https://api.hgbrasil.com/finance?format=json-cors&key=153e1b7b'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Erro ao carregar');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("\$ Finance \$"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchFinanceData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final financeData = snapshot.data;
            final indices = financeData!['results']['stocks'];
            final currencies = financeData['results']['currencies'];
            final bitcoin = financeData['results']['bitcoin']['coinbase'];
            final bitcoin2 = financeData['results']['bitcoin']['foxbit'];
            final lastValue = bitcoin['last'];
            final lastValue2 = bitcoin2['last'];
            final interestRates = financeData['results']['taxes'][0];
            final cdi = interestRates['cdi'];

            return ListView(
              children: [
                ListTile(
                  title: Text('IBOVESPA: ${indices['IBOVESPA']['points']}'),
                ),
                ListTile(
                  title: Text('IFIX: ${indices['IFIX']['points']}'),
                ),
                ListTile(
                  title: Text('NASDAQ: ${indices['NASDAQ']['points']}'),
                ),
                ListTile(
                  title: Text('DOW JONES: ${indices['DOWJONES']['points']}'),
                ),
                ListTile(
                  title: Text('NIKKEI: ${indices['NIKKEI']['points']}'),
                ),
                ListTile(
                  title: Text('Dólar: ${currencies['USD']['buy']}'),
                ),
                ListTile(
                  title: Text('EURO: ${currencies['EUR']['buy']}'),
                ),
                ListTile(
                  title: Text('Libra: ${currencies['GBP']['buy']}'),
                ),
              ListTile(
                  title: Text('Bitcoin na Coinbase (USD): $lastValue'),
                ),
                ListTile(
                  title: Text('Bitcoin na FoxBit (BRL): $lastValue2'),
                ),
                ListTile(
                  title: Text('CDI: $cdi%'),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
