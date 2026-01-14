import 'package:flutter_dotenv/flutter_dotenv.dart';

class AssetConfig {
  static String get s3Url => dotenv.env['S3_BUCKET_URL'] ?? '';
  
  static String getImageUrl(String filename) => '$s3Url/$filename';
}
