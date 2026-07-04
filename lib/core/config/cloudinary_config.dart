/// Cloudinary credentials for unsigned uploads.
///
/// 1. Create a free account at https://cloudinary.com
/// 2. Settings → Upload → Add upload preset → set Signing mode to **Unsigned**
/// 3. Replace the values below with your cloud name and preset name.
class CloudinaryConfig {
  const CloudinaryConfig._();

  static const String cloudName = 'x8k2dmzk';
  static const String uploadPreset = 'launchpad_unsigned';

  static bool get isConfigured =>
      cloudName.isNotEmpty &&
      cloudName != 'YOUR_CLOUD_NAME' &&
      uploadPreset.isNotEmpty &&
      uploadPreset != 'YOUR_UPLOAD_PRESET';
}
