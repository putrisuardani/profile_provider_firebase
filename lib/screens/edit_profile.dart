import 'package:flutter/material.dart';
import '../models/profile.dart';

class EditProfile extends StatefulWidget {
  final Profile profile;
  const EditProfile({super.key, required this.profile});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController profilePhotoController;
  late TextEditingController coverPhotoController;
  late TextEditingController quoteController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profile.name);
    phoneController = TextEditingController(text: widget.profile.phone);
    profilePhotoController = TextEditingController(
      text: widget.profile.profilePhoto,
    );
    coverPhotoController = TextEditingController(
      text: widget.profile.coverPhoto,
    );
    quoteController = TextEditingController(text: widget.profile.quote);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    profilePhotoController.dispose();
    coverPhotoController.dispose();
    quoteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profil")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nama"),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: "No HP"),
            ),
            TextField(
              controller: profilePhotoController,
              decoration: const InputDecoration(labelText: "URL Foto Profil"),
            ),
            TextField(
              controller: coverPhotoController,
              decoration: const InputDecoration(labelText: "URL Cover Photo"),
            ),
            TextField(
              controller: quoteController,
              decoration: const InputDecoration(labelText: "Quote"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final updated = Profile(
                  id: widget.profile.id,
                  name: nameController.text,
                  phone: phoneController.text,
                  profilePhoto: profilePhotoController.text,
                  coverPhoto: coverPhotoController.text,
                  quote: quoteController.text,
                );
                Navigator.pop(context, updated);
              },
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}
