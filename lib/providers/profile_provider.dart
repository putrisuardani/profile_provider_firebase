import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/profile.dart';

class ProfileProvider with ChangeNotifier {
  final _firestore = FirebaseFirestore.instance;

  List<Profile> _profiles = [];
  List<Profile> get profiles => _profiles;

  Profile _myProfile = Profile(
    name: 'Luh Gede Putri',
    phone: '+6281337136811',
    profilePhoto: 'https://i.pravatar.cc/150?img=25',
    coverPhoto: 'https://picsum.photos/600/200?xrandom=25',
    quote:
        '"Jangan jadi orang lucu karena ujung-ujungnya cuma enak dijadiin temen."',
  );
  Profile get myProfile => _myProfile;

  void updateMyProfile(Profile profile) {
    _myProfile = profile;
    notifyListeners();
  }

  Future<void> fetchProfiles() async {
    final snapshot = await _firestore.collection('profiles').get();
    _profiles = snapshot.docs.map((doc) {
      final data = doc.data();
      return Profile(
        id: doc.id,
        name: data['name'],
        phone: data['phone'],
        profilePhoto: data['profilePhoto'],
        coverPhoto: data['coverPhoto'],
        quote: data['quote'],
      );
    }).toList();
    notifyListeners();
  }

  Future<void> addProfile(Profile profile) async {
    final docRef = await _firestore.collection('profiles').add(profile.toMap());
    _profiles.add(
      Profile(
        id: docRef.id,
        name: profile.name,
        phone: profile.phone,
        profilePhoto: profile.profilePhoto,
        coverPhoto: profile.coverPhoto,
        quote: profile.quote,
      ),
    );
    notifyListeners();
  }

  Future<void> updateProfile(String id, Profile profile) async {
    await _firestore.collection('profiles').doc(id).update(profile.toMap());
    await fetchProfiles();
  }

  Future<void> deleteProfile(String id) async {
    await _firestore.collection('profiles').doc(id).delete();
    _profiles.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
