import 'dart:async';

import 'package:animated_text_lerp/animated_text_lerp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/color/app_colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';
import '../../api/trefle_api.dart';
import '../information/information_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Plant>> _plantsFuture;
  String _headerText = 'Plant Identifier';

  @override
  void initState() {
    super.initState();
    _plantsFuture = TrefleApi.getRandomPlants();

    Timer.periodic(const Duration(seconds: 7), (timer) {
      setState(() {
        _headerText = _headerText == 'Plant Identifier'
            ? 'Scan and Learn'
            : 'Plant Identifier';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(spacing: 8,
                children: [
                  SvgPicture.asset( 'assets/images/logo.svg',
                    width: 40, height: 40,
                  ),
                  AnimatedStringText(
                    _headerText,
                    curve: Curves.ease,
                    duration: const Duration(seconds: 1),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark10,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                const Text(
                  'Explore Plants',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark10,
                  ),
                ),
                Spacer(),
                const Text(
                  'Random picks for you',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: FutureBuilder<List<Plant>>(
                        future: _plantsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return ListView.builder(
                              itemCount: 20,
                              itemBuilder: (context, index) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  margin: const EdgeInsets.only(bottom: 10),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(6),
                                          child: Shimmer.fromColors(
                                            baseColor: AppColors.surfaceA30,
                                            highlightColor: AppColors.surfaceA40,
                                            child: Container(
                                              width: 100,
                                              height: 100,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 11),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 6),
                                              Shimmer.fromColors(
                                                baseColor: AppColors.surfaceA30,
                                                highlightColor: AppColors.surfaceA50,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(2),
                                                  child: Container(
                                                    height: 14,
                                                    width: 180,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 14),
                                              Shimmer.fromColors(
                                                baseColor: AppColors.surfaceA30,
                                                highlightColor: AppColors.surfaceA50,
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(2),
                                                  child: Container(
                                                    height: 13,
                                                    width: 140,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          }

                          final plants = snapshot.data!;

                          return ListView.builder(
                            itemCount: plants.length,
                            itemBuilder: (context, index) {
                              final plant = plants[index];
                              return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6)),
                                margin: const EdgeInsets.only(bottom: 10),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(6),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => InformationPage(
                                          imageUrl: plant.imageUrl,
                                          commonName: plant.commonName,
                                          scientificName: plant.scientificName,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(6),
                                          child: Container(
                                            color: AppColors.surfaceA30,
                                            child: Image.network(
                                              plant.imageUrl,
                                              width: 100,
                                              height: 100,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) =>
                                                  Image.asset(
                                                    'lib/images/plant_logo.png',
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.contain,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                plant.commonName,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                plant.scientificName,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontStyle: FontStyle.italic),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
