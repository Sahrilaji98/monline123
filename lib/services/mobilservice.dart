import 'package:http/http.dart' as http;

class MobileService {
  Future<http.Response> getData() async {
    http.Response data =
        await http.get(Uri.parse(("https://fakestoreapi.com/products")));
    return data;
  }
}
