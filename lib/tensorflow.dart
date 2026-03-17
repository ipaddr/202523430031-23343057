import 'dart:io';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class Tensorflow {
  static Interpreter? _interpreter;
  static List<String>? _labels;
  static bool _isLoaded = false;

  static bool get isLoaded => _isLoaded;

  // memuat model dari assets
  static Future<void> loadModel() async {
    if (_isLoaded) return;
    try {
      _interpreter = await Interpreter.fromAsset("assets/batik_model.tflite");
      final labelData = await rootBundle.loadString("assets/labels.txt");
      _labels = labelData.split('\n').where((s) => s.isNotEmpty).toList();
      _isLoaded = true;
      
      // log informasi model untuk debugging
      final inputShape = _interpreter!.getInputTensor(0).shape;
      final outputShape = _interpreter!.getOutputTensor(0).shape;
      print("Model berhasil dimuat!");
      print("Input shape: $inputShape");
      print("Output shape: $outputShape");
      print("Total label: ${_labels?.length}");
    } catch (e) {
      print("Gagal memuat model: $e");
      _isLoaded = false;
    }
  }

  // melakukan klasifikasi gambar
  static Future<List<Map<String, dynamic>>?> classifyImage(
    File imageFile,
  ) async {
    if (!_isLoaded || _interpreter == null || _labels == null) {
      print("Klasifikasi dibatalkan: Model belum siap.");
      return null;
    }

    try {
      var imageBytes = await imageFile.readAsBytes();
      img.Image? image = img.decodeImage(imageBytes);
      if (image == null) return null;

      var inputTensor = _interpreter!.getInputTensor(0);
      var inputShape = inputTensor.shape;
      int height = inputShape[1];
      int width = inputShape[2];

      img.Image resizedImage = img.copyResize(
        image,
        width: width,
        height: height,
      );

      var inputType = inputTensor.type;
      var input = List.generate(
        1,
        (i) => List.generate(
          height,
          (y) => List.generate(width, (x) {
            final pixel = resizedImage.getPixel(x, y);
            if (inputType == TensorType.float32) {
              return [
                pixel.r / 255.0,
                pixel.g / 255.0,
                pixel.b / 255.0,
              ];
            } else {
              return [pixel.r.toInt(), pixel.g.toInt(), pixel.b.toInt()];
            }
          }),
        ),
      );

      var outputShape = _interpreter!.getOutputTensor(0).shape;
      int numClasses = outputShape[1];
      var output = List.generate(1, (i) => List.filled(numClasses, 0.0));

      _interpreter!.run(input, output);
      var probabilities = output[0];

      double maxProb = 0;
      int maxIndex = -1;
      for (int i = 0; i < probabilities.length; i++) {
        if (probabilities[i] > maxProb) {
          maxProb = probabilities[i];
          maxIndex = i;
        }
      }

      if (maxIndex != -1 && maxProb >= 0.1) {
        String label = _labels![maxIndex];
        if (label.contains(' ')) {
          label = label.substring(label.indexOf(' ') + 1);
        }
        return [
          {"label": label, "confidence": maxProb},
        ];
      } else {
        return [
          {"label": "Tidak dikenali", "confidence": maxProb},
        ];
      }
    } catch (e) {
      print("Error saat klasifikasi: $e");
      return null;
    }
  }

  static void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _isLoaded = false;
  }
}
