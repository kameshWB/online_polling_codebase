import 'package:onlinre_polling/core/Models/event.dart';
import 'package:onlinre_polling/core/schemas/user-schemas.dart';
import 'package:intl/intl.dart';

class FirebaseService {
  static addEvent(Event event) async {
    print('updateDiver()');
    try {
      var data = await DataSchemas.eventCount.get();
      int currentCount = data.data()['count'];
      currentCount++;
      event.id = currentCount.toString();
      event.date = DateFormat.yMMMd().format(DateTime.now());
      await DataSchemas.events.doc('$currentCount').set(event.toMap());
      await DataSchemas.eventCount.set({
        'count': currentCount,
      });
    } catch (e) {
      print(e);
    }
  }
}
