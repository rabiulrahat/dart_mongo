import 'dart:io';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:mongo_dart/mongo_dart.dart' as dart_mongo;

main(List<String> args) async {
  int port = 27018;
  var server = await HttpServer.bind('localhost', port);
  var db = Db('mongodb://localhost:27017/test');
  await db.open();
  print('Connected to database');
  DbCollection coll = db.collection('people');
  server.listen((event) async {
    // if (event.uri.path == '/') {
    //   event.response.write('Hello ');
    // } else if (event.uri.path == '/people') {
    //   event.response.write(await coll.find().toList());
    // } else {
    //   event.response.write('Wrong call');
    // }
    // *(..) means cascades method using this we can use both method same time
    switch (event.uri.path) {
      case '/':
        event.response
          ..write('Hello ')
          ..close();
        event.response.close;
        break;
      case '/people':
        event.response
          ..write(await coll.find().toList())
          ..close();
        break;
      default:
        event.response
          ..statusCode = HttpStatus.notFound
          ..write('Not Found')
          ..close();
    }
    event.response.close();
  });
  print('Server listening at http://localhost:$port');
}
