import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../Utils/constants.dart';
import 'notifications_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool pushNotifications = true;
  bool measurementMetric = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        backgroundColor: kbackgroundColor,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          "Settings",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profile Header Card
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundColor: kprimaryColor,
                    child: Icon(Iconsax.user, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nazmul Hasan Shipon",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "shipon@gmail.com",
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Iconsax.edit, color: kprimaryColor),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            "Preferences",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          // Push Notifications Switch Tile
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: const Icon(Iconsax.notification, color: kprimaryColor),
              title: const Text(
                "Push Notifications",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: Switch(
                value: pushNotifications,
                activeTrackColor: kprimaryColor,
                onChanged: (val) {
                  setState(() {
                    pushNotifications = val;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Metric Units Switch Tile
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            clipBehavior: Clip.antiAlias,
            child: ListTile(
              leading: const Icon(Iconsax.weight, color: kprimaryColor),
              title: const Text(
                "Metric Units (gm / ml)",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: Switch(
                value: measurementMetric,
                activeTrackColor: kprimaryColor,
                onChanged: (val) {
                  setState(() {
                    measurementMetric = val;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            "General",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          // Notification Center Link
          _buildActionTile(
            icon: Iconsax.notification_status,
            title: "Notification Center",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotificationsScreen()),
              );
            },
          ),
          // About Dialog Link
          _buildActionTile(
            icon: Iconsax.info_circle,
            title: "About Recipe App",
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: "Recipe App",
                applicationVersion: "1.0.0",
                applicationLegalese: "Built with Flutter, Firebase & Provider",
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          leading: Icon(icon, color: kprimaryColor),
          title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            size: 16,
            color: Colors.grey,
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
