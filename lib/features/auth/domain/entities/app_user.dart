import 'package:equatable/equatable.dart';

class AppUser extends Equatable {
  const AppUser({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.language = 'English',
    this.aiConsent = false,
    this.profileComplete = false,
  });

  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String language;
  final bool aiConsent;
  final bool profileComplete;

  AppUser copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    String? language,
    bool? aiConsent,
    bool? profileComplete,
  }) {
    return AppUser(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      language: language ?? this.language,
      aiConsent: aiConsent ?? this.aiConsent,
      profileComplete: profileComplete ?? this.profileComplete,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'email': email,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'language': language,
        'aiConsent': aiConsent,
        'profileComplete': profileComplete,
      };

  factory AppUser.fromMap(Map<String, dynamic> map) => AppUser(
        id: map['id'] as String,
        email: map['email'] as String? ?? '',
        displayName: map['displayName'] as String?,
        photoUrl: map['photoUrl'] as String?,
        language: map['language'] as String? ?? 'English',
        aiConsent: map['aiConsent'] as bool? ?? false,
        profileComplete: map['profileComplete'] as bool? ?? false,
      );

  @override
  List<Object?> get props =>
      [id, email, displayName, photoUrl, language, aiConsent, profileComplete];
}
