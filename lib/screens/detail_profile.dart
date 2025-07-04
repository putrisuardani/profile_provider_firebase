import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/profile.dart';
import '../providers/profile_provider.dart';
import 'edit_profile.dart';

class DetailProfile extends StatelessWidget {
  final Profile profile;
  const DetailProfile({super.key, required this.profile});

  final List<String> gallery = const [
    "https://picsum.photos/200?1",
    "https://picsum.photos/200?2",
    "https://picsum.photos/200?3",
    "https://picsum.photos/200?4",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Profil")),
      body: Consumer<ProfileProvider>(
        builder: (context, provider, _) {
          final currentProfile = profile.id == null
              ? provider.myProfile
              : provider.profiles.firstWhere(
                  (p) => p.id == profile.id,
                  orElse: () => profile,
                );

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(currentProfile.coverPhoto),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: -80,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                        child: CircleAvatar(
                          radius: 80,
                          backgroundImage: NetworkImage(
                            currentProfile.profilePhoto,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 96),
                Center(
                  child: Text(
                    currentProfile.name,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.pink[500],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        final Uri telUri = Uri(
                          scheme: 'tel',
                          path: currentProfile.phone,
                        );
                        launchUrl(telUri);
                      },
                      icon: Icon(Icons.call, size: 24, color: Colors.pink[200]),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.email, size: 24, color: Colors.pink[200]),
                    const SizedBox(width: 16),
                    Icon(Icons.share, size: 24, color: Colors.pink[200]),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 265,
                  child: PageView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      Card(
                        child: SizedBox(
                          width: double.infinity,
                          child: GridView.builder(
                            shrinkWrap: true,
                            itemCount: gallery.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                            itemBuilder: (context, index) {
                              return ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  gallery[index],
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Card(
                        margin: const EdgeInsets.all(16),
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Kata-kata hari ini...",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.pink[700],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  currentProfile.quote,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context, true);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Kembali ke Daftar"),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final updatedProfile = await Navigator.push<Profile>(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditProfile(profile: currentProfile),
                        ),
                      );
                      if (updatedProfile != null) {
                        if (currentProfile.id == null) {
                          provider.updateMyProfile(updatedProfile);
                        } else {
                          await provider.updateProfile(
                            currentProfile.id!,
                            updatedProfile,
                          );
                        }
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Profil diperbarui")),
                        );
                      }
                    },
                    child: const Text("Edit Profil"),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
