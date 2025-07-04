import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import 'detail_profile.dart';
import '../models/profile.dart';

const List<String> quotes = [
  "Hidup adalah perjalanan, bukan tujuan.",
  "Jangan takut gagal, takutlah untuk tidak mencoba.",
  "Kamu lebih kuat dari yang kamu kira.",
  "Bahagia itu sederhana.",
  "Percaya proses.",
  "Jadilah versi terbaik dirimu.",
  "Senyum adalah kekuatanmu.",
  "Lakukan dengan hati.",
  "Setiap hari adalah awal yang baru.",
  "Bersyukurlah atas hal-hal kecil.",
];

class ListProfile extends StatefulWidget {
  const ListProfile({super.key});

  @override
  State<ListProfile> createState() => _ListProfileState();
}

class _ListProfileState extends State<ListProfile> {
  @override
  void initState() {
    super.initState();
    Provider.of<ProfileProvider>(context, listen: false).fetchProfiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daftar Profil")),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, _) {
          final profiles = profileProvider.profiles;

          if (profiles.isEmpty) {
            return const Center(child: Text("Belum ada data profil."));
          }

          return ListView.builder(
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              final profile = profiles[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(profile.profilePhoto),
                ),
                title: Text(profile.name),
                subtitle: Text(profile.phone),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailProfile(profile: profile),
                    ),
                  );
                },
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await profileProvider.deleteProfile(profile.id!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Profil dihapus")),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final provider = Provider.of<ProfileProvider>(context, listen: false);

          final int random = DateTime.now().millisecondsSinceEpoch % 100;
          final newProfile = Profile(
            name: "Putri $random",
            phone: "+62812$random",
            profilePhoto: "https://i.pravatar.cc/150?img=$random",
            coverPhoto: "https://picsum.photos/600/200?random=$random",
            quote: "Semangat terus yaa 💪",
            id: null,
          );

          await provider.addProfile(newProfile);
        },
        child: const Icon(Icons.add),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Friends"),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "My Profile",
          ),
        ],
        onTap: (index) async {
          if (index == 1) {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  final myProfile = context.read<ProfileProvider>().myProfile;
                  return DetailProfile(profile: myProfile);
                },
              ),
            );
            if (result != null && result is Profile) {
              context.read<ProfileProvider>().updateMyProfile(result);
            }
          }
        },
      ),
    );
  }
}
