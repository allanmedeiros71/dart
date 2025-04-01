import 'package:http/http.dart';
import 'dart:convert';

void main() {
  print("Olá mundo");
  requestData();
  // requestDataAsync();
  print("Esperado função assíncrona");
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

requestDataAsync() async {
  String url =
      "https://gist.githubusercontent.com/allanmedeiros71/65e7a2458fa78fee036c9129af64548b/raw/80b0e1732295475b55e6f60271812e641cae0451/account.json";
  Response response = await get(Uri.parse(url));
  print(json.decode(response.body)[0]);
  print("Última coisa a ser executada");
}
