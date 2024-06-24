import 'package:flutter/material.dart';

class ImcCalculatorScreen extends StatefulWidget {
  @override
  _ImcCalculatorScreenState createState() => _ImcCalculatorScreenState();
}

class _ImcCalculatorScreenState extends State<ImcCalculatorScreen> {
  // Variáveis para armazenar os valores de peso e altura
  double _peso = 0;
  double _altura = 0;
  double _imc = 0;
  String _resultado = "";

  // Método para calcular o IMC
  void _calcularImc() {
    setState(() {
      _imc = _peso / (_altura * _altura);
      _resultado = "Seu IMC: ${_imc.toStringAsFixed(2)}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculadora de IMC'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campo de entrada para o peso
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Peso (kg)',
              ),
              onChanged: (text) {
                setState(() {
                  _peso = double.tryParse(text) ?? 0;
                });
              },
            ),
            SizedBox(height: 16.0),
            // Campo de entrada para a altura
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Altura (cm)',
              ),
              onChanged: (text) {
                setState(() {
                  _altura = double.tryParse(text) ?? 0;
                });
              },
            ),
            SizedBox(height: 32.0),
            // Botão para calcular o IMC
            ElevatedButton(
              onPressed: _calcularImc,
              child: Text('Calcular IMC'),
            ),
            SizedBox(height: 32.0),
            // Exibe o resultado do cálculo
            Text(
              _resultado,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}