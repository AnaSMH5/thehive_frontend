import 'package:flutter/material.dart';
import 'package:frontend/services/profile_service.dart';
import 'package:frontend/widgets/navigation_widget/nav_bar_controller.dart';
import 'package:frontend/widgets/utils/footer.dart';
import 'package:frontend/widgets/utils/stat_and_text_widget.dart';

Future<Map<String, dynamic>?> getCombinedProfileData() async {
  final user = await AccountService().getUserData();
  final profile = await AccountService().getProfileData();
  if (user == null || profile == null) return null;
  // Merge both maps, giving priority to profile fields if duplicated
  return {...user, ...profile};
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>?> profileData;

  @override
  void initState() {
    super.initState();
    profileData = getCombinedProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const NavBarController(),
          Expanded(
            child: Container(
              padding:
                  const EdgeInsets.only(left: 200.0, top: 40.0, right: 200.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    FutureBuilder<Map<String, dynamic>?>(
                      future: profileData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                          final theme = Theme.of(context);
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: theme.colorScheme.primary,
                                      width: 2.0,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: CircleAvatar(
                                    radius: 68,
                                    backgroundColor:
                                        theme.colorScheme.secondary,
                                    backgroundImage: imageUrl != null
                                        ? NetworkImage(imageUrl)
                                        : null,
                                    child: imageUrl == null
                                        ? Icon(
                                            Icons.person,
                                            color: theme.colorScheme.primary,
                                          )
                                        : null,
                                  )),
                              const SizedBox(width: 20.0),
                              SizedBox(
                                width: 400.0,
                                child: Column(
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Wrap(
                                          alignment: WrapAlignment.start,
                                          crossAxisAlignment:
                                              WrapCrossAlignment.end,
                                          spacing: 10.0,
                                          children: [
                                            Text(
                                              data['username'],
                                              style: TextStyle(
                                                  color:
                                                      theme.colorScheme.primary,
                                                  fontSize: 50.0,
                                                  fontFamily: 'Aboreto',
                                                  height: 0.8),
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5.0,
                                                      horizontal: 10.0),
                                              decoration: BoxDecoration(
                                                color:
                                                    theme.colorScheme.secondary,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: Text(
                                                (data['profile_role'])
                                                        .toUpperCase() ??
                                                    'SUBSCRIBER',
                                                style: TextStyle(
                                                  color: theme
                                                      .colorScheme.onSurface,
                                                  fontSize: 14.0,
                                                  fontFamily: 'Jost',
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 5.0),
                                        Text(
                                          data['full_name'] ?? '',
                                          style: TextStyle(
                                            color: theme.colorScheme.onSurface,
                                            fontSize: 20.0,
                                            fontFamily: 'Jost',
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                        const SizedBox(height: 10.0),
                                        Text(
                                          data['description'] ?? '',
                                          style: TextStyle(
                                            color: theme.colorScheme.onSurface,
                                            fontSize: 18.0,
                                            fontFamily: 'Jost',
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  StatAndTextWidget(
                                    stats: '${data['followers_count']}',
                                    text: 'Followers',
                                    color: theme.colorScheme.primary,
                                    onTap: () {
                                      // Navigate to followers page
                                      debugPrint('Followers tapped');
                                    },
                                  ),
                                  const SizedBox(width: 30.0),
                                  StatAndTextWidget(
                                    stats: '${data['following_count']}',
                                    text: 'Following',
                                    color: theme.colorScheme.primary,
                                    onTap: () {
                                      // Navigate to following page
                                      debugPrint('Following tapped');
                                    },
                                  ),
                                  const SizedBox(width: 30.0),
                                  StatAndTextWidget(
                                    stats: '${data['lists_count']}',
                                    text: 'Public Lists',
                                    color: theme.colorScheme.primary,
                                    onTap: () {
                                      // Navigate to reviews page
                                      debugPrint('Public Lists tapped');
                                    },
                                  ),
                                  const SizedBox(width: 30.0),
                                  StatAndTextWidget(
                                    stats: '${data['movies_rated']}',
                                    text: 'Movies Rated',
                                    color: theme.colorScheme.primary,
                                    onTap: () {
                                      // Navigate to reviews page
                                      debugPrint('Movies Rated tapped');
                                    },
                                  ),
                                ],
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 40.0),
                  ],
                ),
              ),
            ),
          ),
          const Footer(),
        ],
      ),
    );
  }
}
