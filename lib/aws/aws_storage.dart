library aws_s3_upload;

import 'dart:io';

import 'package:amazon_cognito_identity_dart_2/sig_v4.dart';
import 'package:http/http.dart' as http;
import 'package:partner/aws/policy.dart';
import 'package:path/path.dart' as path;

class AwsS3 {
  static Future<String?> uploadFile({
    /// AWS access key
    String accessKey = 'AKIAW66ROFWWWUVEC4FG',

    /// AWS secret key
    String secretKey = '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',

    /// The name of the S3 storage bucket to upload  to
    String bucket = 'silambudemo160212-dev',

    /// The file to upload
    required File file,

    /// The path to upload the file to (e.g. "uploads/public"). Defaults to the root "directory"
    String destDir = 'namma_mechanics',

    /// The AWS region. Must be formatted correctly, e.g. us-west-1
    String region = 'eu-west-2',

    /// The filename to upload as. If null, defaults to the given file's current filename.
    String? filename,
  }) async {
    final endpoint = 'https://$bucket.s3-$region.amazonaws.com';
    final uploadDest = '$destDir/${filename ?? path.basename(file.path)}';

    final stream = http.ByteStream(Stream.castFrom(file.openRead()));
    final length = await file.length();

    final uri = Uri.parse(endpoint);
    final req = http.MultipartRequest("POST", uri);
    final multipartFile = http.MultipartFile('file', stream, length,
        filename: path.basename(file.path));

    final policy = Policy.fromS3PresignedPost(
        uploadDest, bucket, accessKey, 15, length,
        region: region);
    final key =
        SigV4.calculateSigningKey(secretKey, policy.datetime, region, 's3');
    final signature = SigV4.calculateSignature(key, policy.encode());

    req.files.add(multipartFile);
    req.fields['key'] = policy.key;
    req.fields['acl'] = 'public-read';
    req.fields['X-Amz-Credential'] = policy.credential;
    req.fields['X-Amz-Algorithm'] = 'AWS4-HMAC-SHA256';
    req.fields['X-Amz-Date'] = policy.datetime;
    req.fields['Policy'] = policy.encode();
    req.fields['X-Amz-Signature'] = signature;

    try {
      final res = await req.send();

      if (res.statusCode == 204) return '$endpoint/$uploadDest';
    } catch (e) {
      print('Failed to upload to AWS, with exception:');
      print(e);
      return null;
    }
  }
}
