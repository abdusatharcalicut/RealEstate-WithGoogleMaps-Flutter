class AppSettingsModel {
  AppSettingsModel({
    this.email,
    this.website,
    this.appVersion,
    this.aboutUs,
    this.headerImages,
    this.privacyPolicy,
    this.facebookUrl,
    this.twitterUrl,
    this.youtubeUrl,
    this.instagramUrl,
  });

  String? email;
  String? website;
  String? appVersion;
  String? aboutUs;
  String? headerImages;
  String? privacyPolicy;
  String? facebookUrl;
  String? twitterUrl;
  String? youtubeUrl;
  String? instagramUrl;

  factory AppSettingsModel.fromJson(Map<String, dynamic>? json) =>
      AppSettingsModel(
        email: json?["email"],
        website: json?["website"],
        appVersion: json?["appVersion"],
        aboutUs: json?["aboutUs"],
        headerImages: json?["headerImages"],
        privacyPolicy: json?["privacyPolicy"],
        facebookUrl: json?["facebookUrl"],
        twitterUrl: json?["twitterUrl"],
        youtubeUrl: json?["youtubeUrl"],
        instagramUrl: json?["instagramUrl"],
      );
}
