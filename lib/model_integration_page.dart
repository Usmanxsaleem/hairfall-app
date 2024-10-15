import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class ModelIntegrationPage extends StatefulWidget {
  @override
  _ModelIntegrationPageState createState() => _ModelIntegrationPageState();
}

class _ModelIntegrationPageState extends State<ModelIntegrationPage> {
  String? _output;
  XFile? _image;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  // Load the TFLite model
  Future<void> loadModel() async {
    String? res = await Tflite.loadModel(
      model: 'assets/model.tflite',
      labels: 'assets/labels.txt',
    );
    print("Model Loaded: $res");
  }

  // Pick an image from the gallery or camera
  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    var image = await picker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _image = image;
      });
      runModel(image.path);
    }
  }

  // Run inference on the selected image
  Future<void> runModel(String imagePath) async {
    var output = await Tflite.runModelOnImage(
      path: imagePath,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 2, // Adjust as per your model output
      threshold: 0.5,
    );

    print("Model Output: $output"); // Debug log for prediction result

    setState(() {
      _output = output != null ? output.toString() : 'No result';
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Hair Disease Detection')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _image == null
                ? Text('No image selected.')
                : Image.file(File(_image!.path)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => pickImage(ImageSource.gallery),
              child: Text('Pick Image'),
            ),
            SizedBox(height: 20),
            _output == null
                ? Text('Waiting for result...')
                : Text('Prediction: $_output'),
          ],
        ),
      ),
    );
  }
}
