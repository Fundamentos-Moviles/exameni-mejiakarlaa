import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(const MemoramaApp());
}

class MemoramaApp extends StatelessWidget {
  const MemoramaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memorama',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MemoramaPage(),
    );
  }
}

class MemoramaPage extends StatefulWidget {
  const MemoramaPage({super.key});

  @override
  State<MemoramaPage> createState() => _MemoramaPageState();
}

class _MemoramaPageState extends State<MemoramaPage> {
  late List<Color> _colores;
  late List<bool> _descubiertas;
  List<int> _seleccionadas = [];

  int _rows = 5;
  int _cols = 4;

  @override
  void initState() {
    super.initState();
    _iniciarJuego();
  }

  void _iniciarJuego() {
    final base = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.cyan,
      Colors.brown,
      Colors.pink,
      Colors.teal,
    ];

    final total = _rows * _cols;
    final lista = [...base, ...base]..shuffle();

    _colores = lista.take(total).toList();
    _descubiertas = List.generate(_colores.length, (_) => false);
    _seleccionadas.clear();
    setState(() {});
  }

  void _tocarCarta(int index) {
    if (_descubiertas[index] || _seleccionadas.contains(index)) return;

    setState(() {
      _seleccionadas.add(index);
    });

    if (_seleccionadas.length == 2) {
      if (_colores[_seleccionadas[0]] == _colores[_seleccionadas[1]]) {
        setState(() {
          _descubiertas[_seleccionadas[0]] = true;
          _descubiertas[_seleccionadas[1]] = true;
          _seleccionadas.clear();
        });
        _verificarFin();
      } else {
        Timer(const Duration(milliseconds: 800), () {
          setState(() {
            _seleccionadas.clear();
          });
        });
      }
    }
  }

  void _verificarFin() {
    if (_descubiertas.every((e) => e)) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text("🎉 Juego Terminado"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                _iniciarJuego();
              },
              child: const Text("Reiniciar"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Memorama - Karla Dayana Mejía Padron"),
      ),
      body: Column(
        children: [
          // Selector de tamaño
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: "${_rows}x$_cols",
              items: const [
                DropdownMenuItem(value: "5x4", child: Text("5 x 4")),
                DropdownMenuItem(value: "4x6", child: Text("4 x 6")),
                DropdownMenuItem(value: "5x8", child: Text("5 x 8")),
              ],
              onChanged: (value) {
                if (value != null) {
                  final parts = value.split("x");
                  _rows = int.parse(parts[0]);
                  _cols = int.parse(parts[1]);
                  _iniciarJuego();
                }
              },
            ),
          ),

          // Botón de reinicio
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text("Reiniciar"),
              onPressed: _iniciarJuego,
            ),
          ),

          // El tablero del memorama
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _cols,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: _colores.length,
              itemBuilder: (context, index) {
                final revelada =
                    _descubiertas[index] || _seleccionadas.contains(index);
                return GestureDetector(
                  onTap: () => _tocarCarta(index),
                  child: SizedBox(
                    width: 60,
                    height: 60,
                    child: Container(
                      decoration: BoxDecoration(
                        color: revelada ? _colores[index] : Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
