import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import '../config/cloudinary_config.dart';
import '../error/failure.dart';

enum CloudinaryResourceType { image, raw }

/// Uploads files to Cloudinary and returns secure URLs stored in Firestore.
class CloudinaryService {
  CloudinaryService({
    String? cloudName,
    String? uploadPreset,
  })  : _cloudName = cloudName ?? CloudinaryConfig.cloudName,
        _uploadPreset = uploadPreset ?? CloudinaryConfig.uploadPreset;

  final String _cloudName;
  final String _uploadPreset;

  bool get isConfigured => CloudinaryConfig.isConfigured;

  Future<String> uploadXFile({
    required XFile file,
    required String folder,
    CloudinaryResourceType resourceType = CloudinaryResourceType.image,
  }) async {
    final bytes = await file.readAsBytes();
    return uploadBytes(
      bytes: bytes,
      folder: folder,
      fileName: file.name,
      resourceType: resourceType,
    );
  }

  Future<String> uploadBytes({
    required List<int> bytes,
    required String folder,
    String? fileName,
    CloudinaryResourceType resourceType = CloudinaryResourceType.image,
  }) async {
    if (!isConfigured) {
      throw const Failure(
        'Cloudinary is not configured yet. See CLOUDINARY_SETUP.md.',
        code: 'cloudinary',
      );
    }

    final resource =
        resourceType == CloudinaryResourceType.raw ? 'raw' : 'image';
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$_cloudName/$resource/upload',
    );

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = _uploadPreset
      ..fields['folder'] = 'launchpad_alu/$folder';

    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: fileName ?? 'upload',
      ),
    );

    final response = await http.Response.fromStream(await request.send());
    if (response.statusCode != 200) {
      throw Failure(
        'Cloudinary upload failed (${response.statusCode}).',
        code: 'cloudinary',
      );
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final url = json['secure_url'] as String?;
    if (url == null || url.isEmpty) {
      throw const Failure(
        'Cloudinary did not return a file URL.',
        code: 'cloudinary',
      );
    }
    return url;
  }
}
