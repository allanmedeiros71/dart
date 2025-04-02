import 'dart:async';

import 'package:assincronismo/env.dart';
import 'package:http/http.dart';
import 'dart:convert';

StreamController<String> streamController = StreamController<String>();

void main() {
  StreamSubscription streamSubscription = streamController.stream.listen((
    String info,
  ) {
    print(info);
  });

  requestData();
  requestDataAsync();
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

  futureResponse.then((Response response) {
    streamController.add(
      "${DateTime.now()} | Requisição de leitura (usando then)",
    );
  });
}

Future<List<dynamic>> requestDataAsync() async {
  String url =
      "https://gist.githubusercontent.com/allanmedeiros71/65e7a2458fa78fee036c9129af64548b/raw/80b0e1732295475b55e6f60271812e641cae0451/account.json";
  Response response = await get(Uri.parse(url));
  streamController.add("${DateTime.now()} | Requisição de leitura");
  return json.decode(response.body);
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

  if (response.statusCode.toString()[0] == "2") {
    streamController.add(
      "${DateTime.now()} | Requisição de adição bem sucedida (${mapAccount["name"]})",
    );
  } else {
    streamController.add("${DateTime.now()} | Requisição falhou");
  }
}
