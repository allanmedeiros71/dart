import 'package:assincronismo/env.dart';
import 'package:http/http.dart';
import 'dart:convert';

void main() {
  // print("Olá mundo");
  // requestData();
  // requestDataAsync();
  // print("Esperado função assíncrona");
  sendDataAsync({
    "id": "NEW001",
    "name": "Allan",
    "lastName": "Medeiros",
    "balance": 2100.0,
  });
}

requestData() {
  String url =
      "https://gist.githubusercontent.com/allanmedeiros71/65e7a2458fa78fee036c9129af64548b/raw/80b0e1732295475b55e6f60271812e641cae0451/account.json";

  Future<Response> futureResponse = get(Uri.parse(url));
  print(futureResponse);

  futureResponse.then((Response response) {
    print(response);
    print(response.body);
    List<dynamic> listAccounts = json.decode(response.body);
    // Ver: https://medium.com/@ahsan-001/exploring-dart-functions-a-comprehensive-guide-with-coding-examples-a2b836f36d85
    Map<String, dynamic> mapCarla = listAccounts.firstWhere(
      (element) => element["name"] == "Carla",
    );
    print(mapCarla["balance"]);
  });

  print("Última coisa a acontecer na função");
}

Future<List<dynamic>> requestDataAsync() async {
  String url =
      "https://gist.githubusercontent.com/allanmedeiros71/65e7a2458fa78fee036c9129af64548b/raw/80b0e1732295475b55e6f60271812e641cae0451/account.json";
  Response response = await get(Uri.parse(url));
  return json.decode(response.body);
  // print(json.decode(response.body)[0]);
  // print("Última coisa a ser executada");
}

sendDataAsync(Map<String, dynamic> mapAccount) async {
  List<dynamic> listAccounts = await requestDataAsync();
  listAccounts.add(mapAccount);
  String content = json.encode(listAccounts);

  String url = "https://api.github.com/gists/65e7a2458fa78fee036c9129af64548b";

  Response response = await post(
    Uri.parse(url),
    headers: {"Authorization": "Bearer $githubApiKey"},
    body: json.encode({
      "descrption": "Alteração de accounts.json via API com Dart",
      "public": true,
      "files": {
        "account.json": {"content": content},
      },
    }),
  );
  print(response.statusCode);
}
