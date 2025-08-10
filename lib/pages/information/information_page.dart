import 'package:flutter/material.dart';
import 'package:flutter_projects/color/app_colors.dart';

class InformationPage extends StatefulWidget {
  final String imageUrl;
  final String commonName;
  final String scientificName;

  const InformationPage({
    super.key,
    required this.imageUrl,
    required this.commonName,
    required this.scientificName,
  });

  @override
  State<InformationPage> createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  final ScrollController _scrollController = ScrollController();
  double _appBarOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      double offset = _scrollController.offset;
      double opacity = (offset / 300).clamp(0, 1);
      if (opacity != _appBarOpacity) {
        setState(() {
          _appBarOpacity = opacity;
        });
      }
    });
  }

  Widget _buildTagButton(String label, {required VoidCallback onPressed}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(
        color: AppColors.surfaceA10,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.center,
      child: InkWell(
        onTap: onPressed,
        child: Text(
          label,
          style: const TextStyle(color: AppColors.primaryDark10, fontSize: 14),
        ),
      ),
    );
  }

  Widget _buildSection(IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceA10,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryDark10, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: AppColors.surfaceA50),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        leading: const BackButton(),
        backgroundColor: AppColors.surfaceA0.withOpacity(_appBarOpacity),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 80),
          child: Column(
            children: [
              Container(
                color: Colors.white,
                height: 300,
                width: double.infinity,
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Image.asset(
                    'lib/images/plant_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Container(
                color: AppColors.surfaceA0,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 5),
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.commonName,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.scientificName,
                              style: const TextStyle(
                                  fontSize: 16, color: AppColors.surfaceA50),
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildTagButton("Medical", onPressed: () {}),
                            _buildTagButton("Culinary", onPressed: () {}),
                            _buildTagButton("Cultural Significance", onPressed: () {}),
                            _buildTagButton("Safety & Toxicity", onPressed: () {}),
                            _buildTagButton("Ecological Role", onPressed: () {}),
                            _buildTagButton("Cultivation Tips", onPressed: () {}),
                          ],
                        ),
                      ),
                    ),
                    Column( spacing: 10,
                      children: [
                        _buildSection(Icons.healing, "Medical Use",
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."),
                        _buildSection(Icons.restaurant, "Culinary Use",
                            "Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat."),
                        _buildSection(Icons.public, "Cultural Significance",
                            "Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur."),
                        _buildSection(Icons.warning, "Safety & Toxicity",
                            "Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."),
                        _buildSection(Icons.eco, "Ecological Role",
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
                        _buildSection(Icons.grass, "Cultivation Tips",
                            "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium."),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              AppColors.surfaceA0,
              Colors.transparent,
            ],
          ),
        ),
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 60),
            ),
            onPressed: () {
              // Handle button press
            },
            child: const Text(
              "Save to My Garden",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
