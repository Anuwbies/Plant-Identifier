import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_projects/color/app_colors.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../api/efficientnetb3_api.dart';
import '../information/information_page.dart';
import '../unknown/unknown_page.dart';

class ScanPage extends StatefulWidget {
  final ImageProvider image;

  const ScanPage({super.key, required this.image});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isScanning = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    analyzeImage();
  }

  Future<void> analyzeImage() async {
    try {
      File? imageFile;

      if (widget.image is FileImage) {
        imageFile = (widget.image as FileImage).file;
      } else {
        throw Exception('ScanPage only supports FileImage for now');
      }

      // Call Django EfficientNetB3 API
      final result = await EfficientNetB3Api.predictPlant(imageFile);

      if (result.containsKey("error")) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const UnknownPage()),
          );
        }
        return;
      }

      final sampleImageUrl = result["sample_image"] ?? "";
      final predictedIndex = result["predicted_index"] ?? -1;
      final commonName = result["common_name"] ?? "Unknown";
      final scientificName = result["scientific_name"] ?? "Unknown";
      final confidence = (result["confidence"] ?? 0.0) * 100;

      // Print in console
      print("Sample image URL: $sampleImageUrl");
      print("Predicted index: $predictedIndex");
      print("Common name: $commonName");
      print("Scientific name: $scientificName");
      print("Confidence level: ${confidence.toStringAsFixed(2)}%");

      if (confidence < 60.0) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const UnknownPage()),
          );
        }
      } else {
        // Otherwise, go to InformationPage
        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => InformationPage(
                imageUrl: sampleImageUrl.isNotEmpty ? sampleImageUrl : imageFile!.path,
                predictedIndex: predictedIndex,
                commonName: commonName,
                scientificName: scientificName,
                confidence: confidence,
              ),
            ),
                (Route<dynamic> route) => route.isFirst,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const UnknownPage()),
        );
      }
    } finally {
      _controller.stop();
      setState(() => _isScanning = false);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 250,
                    height: 350,
                    child: Image(
                      image: widget.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_isScanning) ...[
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      LoadingAnimationWidget.threeArchedCircle(
                        color: AppColors.primaryDark10,
                        size: 60,
                      ),
                      Icon(
                        LucideIcons.search,
                        size: 30,
                        color: AppColors.surfaceA50,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Analyzing image...",
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}