import 'package:http/http.dart';

void main() {
  print("Olá mundo");
  requestData();
}

requestData() {
  String url =
      "https://gist.githubusercontent.com/allanmedeiros71/65e7a2458fa78fee036c9129af64548b/raw/80b0e1732295475b55e6f60271812e641cae0451/account.json";

  Future<Response> futureResponse = get(Uri.parse(url));
  print(futureResponse);

  futureResponse.then((Response response) {
    print(response.body);
  });
}
