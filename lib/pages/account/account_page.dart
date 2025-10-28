import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_projects/color/app_colors.dart';

import '../Text/about/about_page.dart';
import '../Text/help and support/help_and_support_page.dart';
import '../Text/privacy policy/privacy_policy_page.dart';
import '../Text/terms of use/terms_of_use_page.dart';
import '../welcome/welcome_page.dart';
import 'account_page_model.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late AccountPageModel model;

  @override
  void initState() {
    super.initState();
    model = AccountPageModel();
    model.loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: model,
      child: Consumer<AccountPageModel>(
        builder: (context, model, child) {
          final displayName = (model.firstName.isNotEmpty || model.lastName.isNotEmpty)
              ? "${model.firstName} ${model.lastName}"
              : "";

          return Scaffold(
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(50),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColors.surfaceA0,
                title: const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryA0,
                  ),
                ),
                centerTitle: false,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Container(
                    color: AppColors.surfaceA30,
                    height: 1.5,
                  ),
                ),
              ),
            ),
            body: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColors.surfaceA30, width: 1.5),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: CircleAvatar(
                              radius: 55,
                              backgroundColor: model.getRandomDarkColor(),
                              child: Text(
                                (model.firstName.isNotEmpty || model.lastName.isNotEmpty)
                                    ? (model.firstName[0].toUpperCase() +
                                    (model.lastName.isNotEmpty
                                        ? model.lastName[0].toUpperCase()
                                        : ""))
                                    : "",
                                style: const TextStyle(
                                  fontSize: 48,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              model.emailText,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              model.joinedDate,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        _buildActionTile(
                          icon: Icons.info_outline,
                          title: 'About',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const AboutPage()),
                          ),
                        ),
                        _buildActionTile(
                          icon: Icons.help_outline,
                          title: 'Help & Support',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const HelpSupportPage()),
                          ),
                        ),
                        _buildActionTile(
                          icon: Icons.description_outlined,
                          title: 'Terms of Use',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const TermsOfUsePage()),
                          ),
                        ),
                        _buildActionTile(
                          icon: Icons.privacy_tip_outlined,
                          title: 'Privacy Policy',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const PrivacyPolicyPage()),
                          ),
                        ),
                        _buildActionTile(
                          icon: Icons.logout,
                          title: 'Log Out',
                          onTap: () async {
                            await model.logout(
                              context,
                                  () async {
                                final prefs = await SharedPreferences.getInstance();
                                await prefs.clear();
                              },
                                  () => Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const WelcomePage()),
                                    (route) => false,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white, size: 24),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
      trailing: const Icon(Icons.arrow_forward_ios,
          color: Colors.white70, size: 14),
      onTap: onTap,
    );
  }
}
