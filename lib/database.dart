import 'models.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class EstudiantesDb {
  Box box;
  Future<bool> initDb() async {
    Hive.init((await getApplicationDocumentsDirectory()).path);
    Hive.registerAdapter(EstudianteAdapter());
    box = await Hive.openBox('estudiantes');
    return true;
  }

  //CREATE
  void create(Estudiante element) {
    element.id = box.length;
    box.add(element);
  }

  //READ
  Box getBox() {
    return box;
  }

  //UPDATE
  void update(Estudiante element) {
    box.putAt(element.id, element);
  }

  //DELETE
  void delete(Estudiante element) {
    for (int i = 0; i < box.length; i++) {
      if (box.getAt(i).id == element.id) {
        box.deleteAt(i);
        break;
      }
    }
  }

  void dispose() {
    box.close();
  }
}
