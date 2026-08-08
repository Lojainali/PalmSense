class UserModel {
  final String fullName;
  final String email;
  final String farmName;
  final int totalScans;
  final int diseasesFound;
  final int farmBlocks;

  const UserModel({
    required this.fullName,
    required this.email,
    required this.farmName,
    required this.totalScans,
    required this.diseasesFound,
    required this.farmBlocks,
  });

  UserModel copyWith({
    String? fullName,
    String? email,
    String? farmName,
  }) {
    return UserModel(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      farmName: farmName ?? this.farmName,
      totalScans: totalScans,
      diseasesFound: diseasesFound,
      farmBlocks: farmBlocks,
    );
  }

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
  }
}
