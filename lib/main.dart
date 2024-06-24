import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BMI Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'BMI Calculator',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalculationScreen()),
                );
              },
              child: Text('Calculate your BMI'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                elevation: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CalculationScreen extends StatefulWidget {
  @override
  _CalculationScreenState createState() => _CalculationScreenState();
}

class _CalculationScreenState extends State<CalculationScreen> {
  double _weight = 0;
  double _height = 0;
  double _bmi = 0;
  String _bmiCategory = '';
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int? _selectedGender;
  bool _showResult = false;

  void _calculateBmi() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _weight = double.parse(_weightController.text);
        _height = double.parse(_heightController.text.replaceAll(',', '.')) /
            100; // convert cm to meters
        _bmi = _weight / (_height * _height);
        if (_bmi < 18.5) {
          _bmiCategory = 'Underweight';
        } else if (_bmi < 25) {
          _bmiCategory = 'Normal weight';
        } else if (_bmi < 30) {
          _bmiCategory = 'Overweight';
        } else {
          _bmiCategory = 'Obesity';
        }
        _showResult = true; // Show result after calculation
      });
    }
  }

  void _showCategories(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the modal to take up full width horizontally
      builder: (BuildContext context) {
        return Container(
          width: double.infinity, // Takes up 100% width
          height:
          MediaQuery.of(context).size.height *
              0.75, // Set height to 75% of screen height
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'BMI Categories:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  'Greater than 30',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text('Obesity'),
                SizedBox(height: 5),
                Text(
                  '25 to 29.9',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text('Overweight'),
                SizedBox(height: 5),
                Text(
                  '18.5 to 24.9',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text('Normal weight'),
                SizedBox(height: 5),
                Text(
                  'Less than 18.5',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text('Underweight'),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the BottomSheet
                  },
                  child: Text('Return'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _resetCalculator() {
    setState(() {
      _weight = 0;
      _height = 0;
      _bmi = 0;
      _bmiCategory = '';
      _showResult = false;
      _selectedGender = null;
      _weightController.text = '';
      _heightController.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedGender = 1;
                      });
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                          AssetImage('assets/male.png'),
                          backgroundColor:
                          _selectedGender == 1 ? Colors.transparent : Colors.black.withOpacity(0.1),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Male',
                          style: TextStyle(
                            color: _selectedGender == 1
                                ? Colors.black
                                : Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedGender = 2;
                      });
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage:
                          AssetImage('assets/female.png'),
                          backgroundColor:
                          _selectedGender == 2 ? Colors.transparent : Colors.black.withOpacity(0.1),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Female',
                          style: TextStyle(
                            color: _selectedGender == 2
                                ? Colors.black
                                : Colors.black.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _weightController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        labelText: 'Weight (kg)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your weight';
                        } else if (double.tryParse(value) == null ||
                            double.parse(value) <= 0) {
                          return 'Please enter a valid weight';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      controller: _heightController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        labelText: 'Height (cm)',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your height';
                        } else if (double.tryParse(value) == null ||
                            double.parse(value) <= 0) {
                          return 'Please enter a valid height';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _calculateBmi,
                child: Text('Calculate BMI'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  elevation: 5,
                ),
              ),
              SizedBox(height: 20),
              if (_showResult)
                Column(
                  children: [
                    Text(
                      'Your BMI: ${_bmi.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 24),
                    ),//Text
                    Text(
                      'Category: $_bmiCategory',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        _showCategories(context);
                      },
                      child: Text('View Categories'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _resetCalculator,
                      child: Text('Calculate Again'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        elevation: 5,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
