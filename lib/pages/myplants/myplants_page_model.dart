import 'package:flutter/material.dart';
import '../../api/saved_plants_api.dart';

class MyplantsPageModel extends ChangeNotifier {
  late Future<List<dynamic>> futurePlants;

  MyplantsPageModel() {
    futurePlants = SavedPlantsApi.fetchSavedPlants();
  }

  Future<void> refreshPlants() async {
    futurePlants = SavedPlantsApi.fetchSavedPlants();
    notifyListeners();
  }

  Future<void> deletePlant(int id) async {
    await SavedPlantsApi.deleteSavedPlant(id);
    await refreshPlants();
  }
}
