import 'package:hive_flutter/hive_flutter.dart';

import 'models.dart';
import 'database.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(Demo());
}

class Demo extends StatefulWidget {
  @override
  _DemoState createState() => _DemoState();
}

Estudiante editing;
EstudiantesDb _db = EstudiantesDb();

_goToPage(int page) {
  _mainController.animateToPage(page,
      duration: Duration(milliseconds: 800), curve: Curves.bounceInOut);
}

PageController _mainController = PageController();

class _DemoState extends State<Demo> {
  TextEditingController _nombreController = TextEditingController(),
      _carreraController = TextEditingController(),
      _semestreController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _db.initDb();
  }

  @override
  void dispose() {
    super.dispose();
    _db.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Box box = _db.getBox();
    return MaterialApp(
        title: 'DEMO Hive',
        home: Scaffold(
            appBar: AppBar(title: Text('CRUD Hive'), centerTitle: true),
            body: Padding(
              padding: EdgeInsets.all(20),
              child: PageView(
                  controller: _mainController,
                  onPageChanged: (_) => _reload(),
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    WatchBoxBuilder(
                      box: box,
                      builder: (BuildContext context, Box box) =>
                          ListView.builder(
                              itemCount: box?.length ?? 0,
                              itemBuilder: (BuildContext c, int i) {
                                Estudiante e = box.getAt(i);
                                return ExpansionTile(
                                    title: Text(e.nombre),
                                    subtitle: Text(e.carrera),
                                    trailing: Text(e.id.toString()),
                                    children: [
                                      Text(
                                          'Estudia ${e.carrera} y está en ${e.semestre} semestre'),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton.icon(
                                                onPressed: () {
                                                  editing = e;
                                                  _nombreController.text =
                                                      editing.nombre;
                                                  _carreraController.text =
                                                      editing.carrera;
                                                  _semestreController.text =
                                                      editing.semestre
                                                          .toString();
                                                  _goToPage(1);
                                                },
                                                icon: Icon(Icons.edit),
                                                label: Text('Editar'),
                                                style: ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)))),
                                            ElevatedButton.icon(
                                                onPressed: () {
                                                  _db.delete(e);
                                                  _reload();
                                                },
                                                icon: Icon(Icons.delete),
                                                style: ElevatedButton.styleFrom(
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                    primary: Colors.red[800]),
                                                label: Text('Eliminar'))
                                          ])
                                    ]);
                              }),
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextField(
                              controller: _nombreController,
                              decoration: textInputDecoration.copyWith(
                                  labelText: 'Nombre')),
                          TextField(
                              controller: _carreraController,
                              decoration: textInputDecoration.copyWith(
                                  labelText: 'Carrera')),
                          TextField(
                              controller: _semestreController,
                              decoration: textInputDecoration.copyWith(
                                  labelText: 'Semestre'),
                              keyboardType: TextInputType.number),
                          ElevatedButton.icon(
                              onPressed: () {
                                FocusManager.instance.primaryFocus.unfocus();
                                if (editing == null) {
                                  _db.create(Estudiante(
                                      nombre: _nombreController.text,
                                      carrera: _carreraController.text,
                                      semestre: int.tryParse(
                                          _semestreController.text)));
                                } else {
                                  editing.nombre = _nombreController.text;
                                  editing.carrera = _carreraController.text;
                                  editing.semestre =
                                      int.tryParse(_semestreController.text);
                                  _db.update(editing);
                                }
                                _nombreController.clear();
                                _carreraController.clear();
                                _semestreController.clear();
                                _goToPage(0);
                              },
                              icon: Icon(Icons.person_add),
                              label: Text(editing == null
                                  ? 'Añadir estudiante'
                                  : 'Editar estudiante')),
                          TextButton(
                              child: Text('Cancelar'),
                              onPressed: () {
                                FocusManager.instance.primaryFocus.unfocus();
                                editing = null;
                                _goToPage(0);
                              })
                        ])
                  ]),
            ),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.person_add), onPressed: () => _goToPage(1))),
        debugShowCheckedModeBanner: false);
  }

  void _reload() async {
    setState(() {});
  }
}

InputDecoration textInputDecoration = InputDecoration(
    enabledBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
    focusedBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.blue[800])));
