import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';

class ModelIntegrationPage extends StatefulWidget { // Rename to ModelIntegrationPage
  @override
  _ModelIntegrationPageState createState() => _ModelIntegrationPageState();
}

class _ModelIntegrationPageState extends State<ModelIntegrationPage> {
  String? _output;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  // Load the TFLite model
  Future<void> loadModel() async {
    String? res = await Tflite.loadModel(
      model: 'assets/model.tflite', // Path to the .tflite file
      labels: 'assets/labels.txt',  // Path to the labels if you have them
    );
    print(res);
  }

  // Run inference
  Future<void> runModel(String imagePath) async {
    var output = await Tflite.runModelOnImage(
      path: imagePath, // Path to image for prediction
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2,
      threshold: 0.5,
    );
    setState(() {
      _output = output != null ? output.toString() : 'No result';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI Model Integration'),
      ),
      body: Center(
        child: _output == null
            ? Text('Waiting for result...')
            : Text('Output: $_output'),
      ),
    );
  }
}
