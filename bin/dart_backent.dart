import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;

Future<Response> getUsers(Request request) async {
  final file = File('bin/users.json');

  if (await file.exists()) {
    String content = await file.readAsString();
    return Response.ok(content, headers: {'Content-Type': 'application/json'});
  } else {
    return Response.notFound(jsonEncode({'error': 'Fayl topilmadi'}), headers: {'Content-Type': 'application/json'});
  }
}

void main() async {
  final handler = Pipeline().addHandler((Request request) {
    if (request.url.path == 'bin/users.json') {
      return getUsers(request);
    }
    return Response.notFound('Sahifa topilmadi');
  });

  final server = await io.serve(handler, InternetAddress.anyIPv4, 8086);
  print('Server ishga tushdi: http://${server.address.host}:${server.port}');
}
