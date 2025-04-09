import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'GITHUB_API_KEY', obfuscate: true)
  static String githubApiKey = _Env.githubApiKey;

  @EnviedField(varName: 'GITHUB_AUTH_TOKEN', obfuscate: true)
  static String githubAuthToken = _Env.githubAuthToken;

  @EnviedField(varName: 'GITHUB_GIST_URL', obfuscate: true)
  static String githubGistUrl = _Env.githubGistUrl;

  @EnviedField(varName: 'CPF_URL', obfuscate: true)
  static String cpfUrl = _Env.cpfUrl;

  @EnviedField(varName: 'ISIS_TOKEN', obfuscate: true)
  static String isisToken = _Env.isisToken;
}
