import 'package:animated_text_lerp/animated_text_lerp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_projects/color/app_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import '../../api/random_plant_api.dart';
import '../information/information_page.dart';
import 'home_page_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HomePageModel(),
      child: const _HomePageView(),
    );
  }
}

class _HomePageView extends StatelessWidget {
  const _HomePageView();

  @override
  Widget build(BuildContext context) {
    final model = Provider.of<HomePageModel>(context);

    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                spacing: 8,
                children: [
                  SvgPicture.asset(
                    'assets/images/logo.svg',
                    width: 40,
                    height: 40,
                  ),
                  AnimatedStringText(
                    model.headerText,
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

            // Title
            Row(
              children: const [
                Text(
                  'Explore Plants',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryDark10,
                  ),
                ),
                Spacer(),
                Text(
                  'Random picks for you',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),

            // Plant list
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: FutureBuilder<List<Plant>>(
                  future: model.plantsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return _buildShimmerList();
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Text("Error: ${snapshot.error.toString()}"),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No plants available"));
                    }

                    final plants = snapshot.data!;

                    return ListView.builder(
                      itemCount: plants.length,
                      itemBuilder: (context, index) {
                        final plant = plants[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                          margin: const EdgeInsets.only(bottom: 10),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(6),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InformationPage(
                                    imageUrl:
                                    "${RandomPlantApi.baseUrl}${plant.sampleImage}",
                                    commonName: plant.commonName,
                                    scientificName: plant.scientificName,
                                    confidence: null,
                                    predictedIndex: plant.index,
                                    speciesId: plant.speciesId,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 10,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: Container(
                                      color: AppColors.surfaceA30,
                                      child: Image.network(
                                        "${RandomPlantApi.baseUrl}${plant.sampleImage}",
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

                                  // Text
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          plant.commonName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          plant.scientificName,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontStyle: FontStyle.italic,
                                          ),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerList() {
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
}
