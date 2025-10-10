import 'package:flutter/material.dart';
import 'package:flutter_projects/color/app_colors.dart';
import '../../api/saved_plants_api.dart';
import '../information/information_page.dart'; // adjust the import path to your project structure

class MyplantsPage extends StatefulWidget {
  const MyplantsPage({super.key});

  @override
  State<MyplantsPage> createState() => _MyplantsPageState();
}

class _MyplantsPageState extends State<MyplantsPage> {
  late Future<List<dynamic>> _futurePlants;

  @override
  void initState() {
    super.initState();
    _futurePlants = SavedPlantsApi.fetchSavedPlants();
  }

  Future<void> _refreshPlants() async {
    setState(() {
      _futurePlants = SavedPlantsApi.fetchSavedPlants();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
        child: FutureBuilder<List<dynamic>>(
          future: _futurePlants,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Failed to load saved plants:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'No saved plants yet.',
                  style: TextStyle(fontSize: 16),
                ),
              );
            }

            final plants = snapshot.data!;

            return RefreshIndicator(
              onRefresh: _refreshPlants,
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 85),
                itemCount: plants.length,
                itemBuilder: (context, index) {
                  final plant = plants[index];
                  final commonName = plant['common_name'] ?? 'Unknown';
                  final scientificName = plant['scientific_name'] ?? 'Unknown';
                  final imageUrl = plant['image_url'];

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
                              imageUrl: plant['image_url'] ?? '',
                              predictedIndex: 0,
                              speciesId: plant['species_id'] ?? 0,
                              commonName: plant['common_name'] ?? 'Unknown',
                              scientificName: plant['scientific_name'] ?? 'Unknown',
                              confidence: (plant['confidence'] is num)
                                  ? (plant['confidence'] as num).toDouble()
                                  : null,
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
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: imageUrl != null && imageUrl.isNotEmpty
                                  ? Image.network(
                                imageUrl,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 60,
                                    height: 60,
                                    color: AppColors.primaryDark70,
                                    child: const Icon(Icons.image_not_supported),
                                  );
                                },
                              )
                                  : Container(
                                width: 60,
                                height: 60,
                                color: AppColors.primaryDark70,
                                child: const Icon(Icons.local_florist, color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    commonName, maxLines: 1,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      overflow: TextOverflow.ellipsis
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    scientificName, maxLines: 1,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      overflow: TextOverflow.ellipsis,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.redAccent),
                              onPressed: () async {
                                await SavedPlantsApi.deleteSavedPlant(plant['id']);
                                _refreshPlants(); // Refresh list after deletion
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
