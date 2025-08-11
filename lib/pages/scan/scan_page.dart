import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_projects/color/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../api/plantnet_api.dart';
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

  final PlantNetApi _plantNetApi = PlantNetApi();

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

      final result = await _plantNetApi.identifyPlant(imageFile);

      print('Raw API response: ${jsonEncode(result)}');

      if (result.isEmpty || result['results'] == null || (result['results'] as List).isEmpty) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const UnknownPage()),
          );
        }
        return;
      }

      final firstResult = (result['results'] as List).first;
      final species = firstResult['species'];

      final commonName = species['commonNames'] != null &&
          (species['commonNames'] as List).isNotEmpty
          ? species['commonNames'][0]
          : 'Unknown';

      final scientificName =
          species['scientificNameWithoutAuthor'] ?? 'Unknown';

      // Correctly extract the image URL string from nested url object
      final imageUrl = firstResult['images'] != null &&
          (firstResult['images'] as List).isNotEmpty
          ? (firstResult['images'][0]['url'] != null
          ? firstResult['images'][0]['url']['o'] ?? ''
          : '')
          : '';

      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => InformationPage(
              imageUrl: imageUrl,
              commonName: commonName,
              scientificName: scientificName,
            ),
          ),
              (Route<dynamic> route) => route.isFirst,
        );
      }
    } catch (e) {
      print('Error analyzing image: $e');
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const UnknownPage()),
        );
      }
    } finally {
      _controller.stop();
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
                      RotationTransition(
                        turns: _controller,
                        child: Transform.scale(
                          scale: 1.5,
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                            color: AppColors.primaryDark10,
                          ),
                        ),
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
              ] else
                const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
