import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/services/auth_service.dart';
import 'package:frontend/templates/profile_page.dart';
import 'package:frontend/widgets/root_page_controller.dart';
import 'package:frontend/widgets/utils/icon_and_text_widget.dart';
import 'package:frontend/services/profile_service.dart';

class SideUserMenu extends StatefulWidget {
  const SideUserMenu({super.key});

  @override
  State<SideUserMenu> createState() => _SideUserMenuState();
}

class _SideUserMenuState extends State<SideUserMenu> {
  late Future<Map<String, dynamic>?> profileData;
  late String? imageUrl;
  late String? userName;

  @override
  void initState() {
    super.initState();
    profileData = AccountService().getProfileData();
    profileData.then((data) {
      if (data != null) {
        setState(() {
          imageUrl = data['image_rel_path'];
          userName = data['username'] ?? 'Usuario';
        });
      } else {
        imageUrl = null;
        userName = 'Usuario';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: 374.0,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          border: Border(
            left: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary,
              width: 2.0,
            ),
          ),
        ),
        child: Column(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF351904)),
                  iconSize: 28, // Tamaño del icono de búsqueda
                  onPressed: () {
                    // Acción al presionar el botón de cerrar
                    Navigator.of(context)
                        .pop(); // This will close the dialog/overlay
                  },
                )),
            const SizedBox(height: 30.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FutureBuilder<Map<String, dynamic>?>(
                  future: profileData,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFF351904),
                              width: 2.0,
                            ),
                            shape: BoxShape.circle,
                          ),
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 18,
                                  backgroundColor: const Color(0xFFFFECB8),
                                  child: const CircularProgressIndicator(),
                                ),
                                Text(
                                  ('Usuario').toUpperCase(),
                                  style: const TextStyle(
                                    color: Color(0xFF351904),
                                    fontSize: 20.0,
                                    fontFamily: 'Aboreto',
                                  ),
                                ),
                              ],
                            ),
                          ));
                    } else {
                      final data = snapshot.data!;
                      final imageUrl = data['image_rel_path'];
                      final userName = data['username'];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFF351904),
                                  width: 2.0,
                                ),
                                shape: BoxShape.circle,
                              ),
                              child: CircleAvatar(
                                radius: 28,
                                backgroundColor: const Color(0xFF50B2C0),
                                backgroundImage: imageUrl != null
                                    ? NetworkImage(imageUrl)
                                    : null,
                                child: imageUrl == null
                                    ? const Icon(Icons.person,
                                        color: Color(0xFFFFECB8))
                                    : null,
                              )),
                          const SizedBox(height: 10.0),
                          Text(
                            (userName).toUpperCase(),
                            style: const TextStyle(
                              color: Color(0xFF351904),
                              fontSize: 20.0,
                              fontFamily: 'Aboreto',
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconAndTextWidget(
                    icon: Icons.person_outline,
                    text: 'My Profile',
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ProfilePage()),
                      );
                    },
                  ),
                  const SizedBox(height: 15.0),
                  IconAndTextWidget(
                    icon: Icons.list,
                    text: 'Lists',
                    onTap: () {
                      debugPrint('Lists Tapped');
                    },
                  ),
                  const SizedBox(height: 15.0),
                  IconAndTextWidget(
                    icon: Icons.water_drop_outlined,
                    text: 'Honey Drops',
                    onTap: () {
                      debugPrint('Honey Drops Tapped');
                    },
                  ),
                  const SizedBox(height: 30.0),
                  Divider(
                    color: Color(0xFF351904),
                    thickness: 2,
                  ),
                  const SizedBox(height: 30.0),
                  IconAndTextWidget(
                    icon: Icons.settings_outlined,
                    text: 'Settings',
                    onTap: () {
                      debugPrint('Settings Tapped');
                    },
                  ),
                  const SizedBox(height: 15.0),
                  IconAndTextWidget(
                    icon: Icons.help_outline,
                    text: 'Help',
                    onTap: () {
                      debugPrint('Help Tapped');
                    },
                  ),
                  const SizedBox(height: 15.0),
                  IconAndTextWidget(
                    icon: Icons.logout,
                    text: 'Logout',
                      onTap: () async {
                        final navigator = Navigator.of(context); // Captura antes del await
                        await AuthService.logout();
                        if (mounted) {
                          navigator.pushReplacement(
                            MaterialPageRoute(builder: (context) => const RootPage()),
                          );
                        }
                      },
                  ),
                ],
              ),
            ),
            const Spacer(),
            Align(
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  'assets/icons/logo+title.svg',
                  height: 40,
                )),
          ],
        ),
      ),
    );
  }
}
