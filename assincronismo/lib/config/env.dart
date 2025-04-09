import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'GITHUB_API_KEY')
  static const String githubApiKey = _Env.githubApiKey;

  @EnviedField(varName: 'GITHUB_AUTH_TOKEN')
  static const String githubAuthToken = _Env.githubAuthToken;

  @EnviedField(varName: 'GITHUB_GIST_URL')
  static const String githubGistUrl = _Env.githubGistUrl;

  @EnviedField(varName: 'CPF_URL')
  static const String cpfUrl = _Env.cpfUrl;

  @EnviedField(varName: 'ISIS_TOKEN')
  static const String isisToken = _Env.isisToken;
}
