import 'package:mongo_dart/mongo_dart.dart';
import 'dart:io' show Platform;

void main(List<String> args) async {
  Db db = Db('mongodb://127.0.0.1:27017/test');
  /*
  *here database endpoint i got from mongosh command form terminal
  *first of all we have to install and enable our mongo db documentation
  *found  mongo db website
  */
  await db.open();
  print("Connected to database");

  DbCollection coll = db.collection('people');

  //TODO: Read People
  var people = await coll.find(where.limit(5)).toList();
  /*
  * //////////////////////////////////////////////////////////////////////////////////////
  var people = await coll.find(where.eq('first_name', 'rahat')).toList();/////////////////
  *if both are true then it will give output from database
  var people = await coll.find(where.match('first_name', 'R')).toList();/////////////////
 *if here find name which started from letter 'R' then it will give output from database /
   var people = await coll.find(where.limit(5)).toList();
 *here it will give 5 random info from db
  ///////////////////////////////////////////////////////////////////////////////////////
  */
  // print(people);

  //  *finding single person
  // var person = await coll.findOne(where.match('first_name', 'R'));
// * here we are finding that is  person id grater than  inputted  id
  var person = await coll
      // *here it also type sensitive we can not provide like 'ID' it should be smaller
      // .findOne(where.match('first_name', 'R').and(where.gte('id', 40)));
      // * here we are doing javascript query
      .findOne(where
          .jsQuery('''return this.first_name.startsWith('B') && this.id > 4;
      '''));

  print(person);

  //TODO: Create person
  await coll.insertOne(
    {
      "id": 101,
      "first_name": "Rabiul ",
      "last_name": "Rahat",
      "email": "rabiulrahat@gmail.com",
      "gender": "Male",
      "ip_address": "193.10.97.78"
    },
  );
  print("Saved new person");
  //TODO: update person
  await coll.update(await coll.findOne(where.eq('id', 101)), {
    r'$set': {'email': "rabiulrahatt@gmail.com"}
  });
  print('Updated person');
  print(await coll.findOne(where.eq('id', 101)));
  //TODO: Delete person
  await coll.remove(await coll.findOne(where.eq('id', 101)));
  print(await coll.findOne(where.eq('id', 101)));

  await db.close();
}
