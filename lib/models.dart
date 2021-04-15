import 'package:hive/hive.dart';
part 'models.g.dart';

@HiveType(typeId: 0)
class Estudiante {
  @HiveField(0)
  int id;
  @HiveField(1)
  String nombre;
  @HiveField(2)
  String carrera;
  @HiveField(3)
  int semestre;
  Estudiante({this.id, this.nombre, this.carrera, this.semestre});
}
