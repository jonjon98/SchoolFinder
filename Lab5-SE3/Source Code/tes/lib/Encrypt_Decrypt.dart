import 'package:flutter_string_encryption/flutter_string_encryption.dart';

class encrypt
{
  static Future<String> encryptString(String str)
  async {
    var key = null;
    var encrypted;
    PlatformStringCryptor cryptor;
    cryptor= PlatformStringCryptor();
    key="5io+ErrzSGh2L+FUV7ou2g==:uSsfvl+tvfQCN/0e8j+RG+B5QFMw6YZI6oAvKyGbq+k=";
    encrypted = await cryptor.encrypt(str, key);
    return encrypted;
  }
  static Future<String> decryptString(String str)
  async {
    var key = null;
    PlatformStringCryptor cryptor;
    cryptor= PlatformStringCryptor();
    key="5io+ErrzSGh2L+FUV7ou2g==:uSsfvl+tvfQCN/0e8j+RG+B5QFMw6YZI6oAvKyGbq+k=";
    var decrypt=await cryptor.decrypt(str, key);
    return decrypt;
  }
}