class AppConfig {
  // These values are optional. Pass them with --dart-define for image/AI features.
  static const cloudinaryCloudName = String.fromEnvironment('CLOUDINARY_CLOUD_NAME');
  static const cloudinaryUploadPreset = String.fromEnvironment('CLOUDINARY_UPLOAD_PRESET');
  static const aiBaseUrl = String.fromEnvironment('AI_BASE_URL');

  static bool get cloudinaryReady => cloudinaryCloudName.isNotEmpty && cloudinaryUploadPreset.isNotEmpty;
  static bool get aiReady => aiBaseUrl.isNotEmpty;
}
