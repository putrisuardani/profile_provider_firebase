class Profile {
  final String? id;
  String name;
  String phone;
  String profilePhoto;
  String coverPhoto;
  String quote;

  Profile({
    this.id,
    required this.name,
    required this.phone,
    required this.profilePhoto,
    required this.coverPhoto,
    required this.quote,
  });

  // JSON mapping untuk SQLite (Map<String, dynamic>)
  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      profilePhoto: map['profilePhoto'],
      coverPhoto: map['coverPhoto'],
      quote: map['quote'],
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'name': name,
      'phone': phone,
      'profilePhoto': profilePhoto,
      'coverPhoto': coverPhoto,
      'quote': quote,
      'id': id,
    };

    // // Tambahkan id jika tidak null (saat update misalnya)
    // if (id != null) {
    //   map['id'] = id;
    // }

    return map;
  }
}
