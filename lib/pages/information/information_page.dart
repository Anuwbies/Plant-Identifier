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

  final GlobalKey _medicalKey = GlobalKey();
  final GlobalKey _culinaryKey = GlobalKey();
  final GlobalKey _culturalKey = GlobalKey();
  final GlobalKey _safetyKey = GlobalKey();
  final GlobalKey _ecologicalKey = GlobalKey();
  final GlobalKey _cultivationKey = GlobalKey();

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

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      final box = context.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero, ancestor: context.findRenderObject());

      final scrollableBox = _scrollController.position.context.storageContext.findRenderObject() as RenderBox;
      final viewportHeight = scrollableBox.size.height;

      final widgetOffset = box.localToGlobal(Offset.zero, ancestor: scrollableBox).dy;

      final targetOffset = _scrollController.offset + widgetOffset - (viewportHeight / 2) + (box.size.height / 2);

      _scrollController.animateTo(
        targetOffset.clamp(_scrollController.position.minScrollExtent, _scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
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

  Widget _buildSection(IconData icon, String title, List<String> bulletPoints) {
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
          ...bulletPoints.map(
                (point) => Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("•  ", style: TextStyle(fontSize: 14, color: AppColors.surfaceA50)),
                  Expanded(
                    child: Text(
                      point,
                      style: const TextStyle(fontSize: 14, color: AppColors.surfaceA50),
                    ),
                  ),
                ],
              ),
            ),
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
                color: AppColors.primaryDark60,
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
                            _buildTagButton(
                                "Medical",
                                onPressed: () =>
                                    _scrollToSection(_medicalKey)),
                            _buildTagButton(
                                "Culinary",
                                onPressed: () =>
                                    _scrollToSection(_culinaryKey)),
                            _buildTagButton(
                                "Cultural Significance",
                                onPressed: () =>
                                    _scrollToSection(_culturalKey)),
                            _buildTagButton(
                                "Safety & Toxicity",
                                onPressed: () =>
                                    _scrollToSection(_safetyKey)),
                            _buildTagButton(
                                "Ecological Role",
                                onPressed: () =>
                                    _scrollToSection(_ecologicalKey)),
                            _buildTagButton(
                                "Cultivation Tips",
                                onPressed: () =>
                                    _scrollToSection(_cultivationKey)),
                          ],
                        ),
                      ),
                    ),
                    Column( spacing: 10,
                      children: [
                        Container(
                          key: _medicalKey,
                          child: _buildSection(
                            Icons.healing,
                            "Medical Use",
                            [
                              "Used traditionally to treat inflammation and pain.",
                              "Contains antioxidants that support immune health.",
                              "May help reduce symptoms of common colds and flu.",
                              "Has compounds with antibacterial properties.",
                              "Applied topically for wound healing in some cultures.",
                            ],
                          ),
                        ),
                        Container(
                          key: _culinaryKey,
                          child: _buildSection(
                            Icons.restaurant,
                            "Culinary Use",
                            [
                              "Leaves used fresh in salads for a peppery flavor.",
                              "Flowers edible and often used as garnish.",
                              "Seeds ground into spice blends in some cuisines.",
                              "Roots cooked in stews and soups for added aroma.",
                              "Used to make herbal teas and infusions.",
                            ],
                          ),
                        ),
                        Container(
                          key: _culturalKey,
                          child: _buildSection(
                            Icons.public,
                            "Cultural Significance",
                            [
                              "Symbolizes healing and protection in folklore.",
                              "Used in traditional ceremonies and rituals.",
                              "Represents fertility and growth in various cultures.",
                              "Often gifted during festivals for good luck.",
                              "Featured in folk songs and stories across regions.",
                            ],
                          ),
                        ),
                        Container(
                          key: _safetyKey,
                          child: _buildSection(
                            Icons.warning,
                            "Safety & Toxicity",
                            [
                              "Generally safe when used in recommended amounts.",
                              "May cause allergic reactions in sensitive individuals.",
                              "Avoid ingestion in large quantities without medical advice.",
                              "Not recommended for pregnant or breastfeeding women.",
                              "Keep out of reach of children due to potential toxicity.",
                            ],
                          ),
                        ),
                        Container(
                          key: _ecologicalKey,
                          child: _buildSection(
                            Icons.eco,
                            "Ecological Role",
                            [
                              "Provides habitat and food for pollinators.",
                              "Helps improve soil quality through nitrogen fixation.",
                              "Contributes to biodiversity in native ecosystems.",
                              "Acts as a natural pest deterrent in companion planting.",
                              "Supports beneficial insect populations.",
                            ],
                          ),
                        ),
                        Container(
                          key: _cultivationKey,
                          child: _buildSection(
                            Icons.grass,
                            "Cultivation Tips",
                            [
                              "Thrives in well-drained soil with moderate moisture.",
                              "Prefers partial shade to full sun exposure.",
                              "Requires minimal fertilization once established.",
                              "Prune regularly to encourage bushier growth.",
                              "Resistant to most common pests and diseases.",
                            ],
                          ),
                        ),
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
