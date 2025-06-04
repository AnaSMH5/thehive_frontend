import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:frontend/services/profile_service.dart';
import 'package:frontend/widgets/interactions_widgets/edit_profile_widget.dart';
import 'package:frontend/widgets/interactions_widgets/follow_button.dart';
import 'package:frontend/widgets/navigation_widget/nav_bar_controller.dart';
import 'package:frontend/widgets/utils/footer.dart';
import 'package:frontend/widgets/utils/stat_and_text_widget.dart';

Future<Map<String, dynamic>?> getCombinedProfileData(String? profileId) async {
  final user = await AccountService().getUserData();
  final profile = await AccountService().getProfileData(profileId: profileId);
  if (user == null || profile == null) return null;
  // Merge both maps, giving priority to profile fields if duplicated
  return {...user, ...profile};
}

class ProfilePage extends StatefulWidget {
  final String? profileId;

  const ProfilePage({super.key, this.profileId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>?> profileData;

  @override
  void initState() {
    super.initState();
    profileData = getCombinedProfileData(widget.profileId);
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
                          return SizedBox(
                              width: double.infinity,
                              child: Column(
                                children: [
                                  Wrap(
                                    crossAxisAlignment:
                                        WrapCrossAlignment.center,
                                    alignment: WrapAlignment.spaceBetween,
                                    runSpacing: 20.0,
                                    children: [
                                      Wrap(
                                        alignment: WrapAlignment.start,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        spacing: 20.0,
                                        runSpacing: 20.0,
                                        children: [
                                          Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color:
                                                      theme.colorScheme.primary,
                                                  width: 2.0,
                                                ),
                                                shape: BoxShape.circle,
                                              ),
                                              child: CircleAvatar(
                                                radius: 68,
                                                backgroundColor:
                                                    theme.colorScheme.secondary,
                                                backgroundImage: (imageUrl !=
                                                            null &&
                                                        imageUrl is String &&
                                                        imageUrl.isNotEmpty)
                                                    ? NetworkImage(imageUrl)
                                                    : null,
                                                child: (imageUrl == null ||
                                                        imageUrl == '')
                                                    ? Icon(
                                                        Icons.person,
                                                        color: theme.colorScheme
                                                            .primary,
                                                      )
                                                    : null,
                                              )),
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
                                                      alignment:
                                                          WrapAlignment.start,
                                                      crossAxisAlignment:
                                                          WrapCrossAlignment
                                                              .end,
                                                      spacing: 10.0,
                                                      runSpacing: 5.0,
                                                      children: [
                                                        AutoSizeText(
                                                          data['username'] ??
                                                              'username',
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              color: theme
                                                                  .colorScheme
                                                                  .primary,
                                                              fontSize: 50.0,
                                                              fontFamily:
                                                                  'Aboreto',
                                                              height: 0.8),
                                                        ),
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  vertical: 5.0,
                                                                  horizontal:
                                                                      10.0),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: theme
                                                                .colorScheme
                                                                .secondary,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                          child: Text(
                                                            (data['profile_role']) !=
                                                                    null
                                                                ? (data['profile_role'])
                                                                    .toUpperCase()
                                                                : 'SUBSCRIBER',
                                                            style: TextStyle(
                                                              color: theme
                                                                  .colorScheme
                                                                  .onSecondary,
                                                              fontSize: 14.0,
                                                              fontFamily:
                                                                  'Jost',
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                        height: 10.0),
                                                    data.containsKey(
                                                            'status_code')
                                                        ? const SizedBox
                                                            .shrink()
                                                        : Text(
                                                            data['description'] ??
                                                                '',
                                                            style: TextStyle(
                                                              color: theme
                                                                  .colorScheme
                                                                  .onSecondary,
                                                              fontSize: 18.0,
                                                              fontFamily:
                                                                  'Jost',
                                                            ),
                                                          ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Wrap(
                                        alignment: WrapAlignment.center,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        spacing: 20.0,
                                        runSpacing: 10.0,
                                        children: [
                                          StatAndTextWidget(
                                            stats:
                                                '${data['followers_count'] ?? 0}',
                                            text: 'Followers',
                                            color: theme.colorScheme.primary,
                                            onTap: () {
                                              // Navigate to followers page
                                              debugPrint('Followers tapped');
                                            },
                                          ),
                                          StatAndTextWidget(
                                            stats:
                                                '${data['following_count'] ?? 0}',
                                            text: 'Following',
                                            color: theme.colorScheme.primary,
                                            onTap: () {
                                              // Navigate to following page
                                              debugPrint('Following tapped');
                                            },
                                          ),
                                          StatAndTextWidget(
                                            stats:
                                                '${data['lists_count'] ?? 0}',
                                            text: 'Public Lists',
                                            color: theme.colorScheme.primary,
                                            onTap: () {
                                              // Navigate to reviews page
                                              debugPrint('Public Lists tapped');
                                            },
                                          ),
                                          StatAndTextWidget(
                                            stats:
                                                '${data['movies_rated'] ?? 0}',
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
                                  ),
                                  const SizedBox(height: 40.0),
                                  data.containsKey('status_code')
                                      ? const SizedBox.shrink()
                                      : SizedBox(
                                          width: double.infinity,
                                          child: Wrap(
                                            children: [
                                              widget.profileId != null
                                                  ? FollowButton(
                                                      profileId:
                                                          widget.profileId!,
                                                      onFollowed: () {
                                                        setState(() {
                                                          profileData =
                                                              getCombinedProfileData(
                                                                  widget
                                                                      .profileId);
                                                        });
                                                      },
                                                    )
                                                  : EditProfileButton(
                                                      profilePicUrl:
                                                          imageUrl ?? '',
                                                      onProfileUpdated: () {
                                                        setState(() {
                                                          profileData =
                                                              getCombinedProfileData(
                                                                  widget
                                                                      .profileId);
                                                        });
                                                      },
                                                    ),
                                            ],
                                          ),
                                        )
                                ],
                              ));
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
