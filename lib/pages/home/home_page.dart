import 'package:flutter/material.dart';
import 'package:flutter_projects/color/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../api/trefle_api.dart';
import '../information/information_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Plant>> _plantsFuture;

  @override
  void initState() {
    super.initState();
    _plantsFuture = TrefleApi.getRandomPlants();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          spacing: 15,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                spacing: 8,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      'lib/images/circle.png',
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const Text(
                    'Plant Identifier',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryA0,
                    ),
                  )
                ],
              ),
            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for plants...',
                filled: true,
                fillColor: Colors.white10,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Icon(LucideIcons.search),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: FutureBuilder<List<Plant>>(
                  future: _plantsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No plants found'));
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(borderRadius: BorderRadius.circular(6),
                                    child: Container( color: AppColors.primaryDark70,
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
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            plant.commonName,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: Text(
                                            plant.scientificName,
                                            style: const TextStyle(
                                                fontSize: 14,
                                                fontStyle: FontStyle.italic),
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
}
