import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

Future<Response> getUsers(Request request) async {
  try {
    final file = File('bin/users.json'); // yoki 'users.json' agar ildizda bo'lsa

    if (await file.exists()) {
      String content = await file.readAsString();
      return Response.ok(content, headers: {'Content-Type': 'application/json'});
    } else {
      return Response.notFound(
          jsonEncode({'error': 'Fayl topilmadi'}),
          headers: {'Content-Type': 'application/json'});
    }
  } catch (e) {
    return Response.internalServerError(
        body: jsonEncode({'error': 'Server xatosi: $e'}),
        headers: {'Content-Type': 'application/json'});
  }
}

void main() async {
  final handler = Pipeline().addHandler((Request request) {
    if (request.url.path == 'users') { // '/users' endpointi
      return getUsers(request);
    }
    return Response.notFound('Sahifa topilmadi');
  });

  final server = await io.serve(handler, InternetAddress.anyIPv4, 8086);
  print('Server ishga tushdi: http://${server.address.host}:${server.port}/users');
}