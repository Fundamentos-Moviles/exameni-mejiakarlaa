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
    _colores = [...base, ...base]..shuffle();
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
        // par correcto
        setState(() {
          _descubiertas[_seleccionadas[0]] = true;
          _descubiertas[_seleccionadas[1]] = true;
          _seleccionadas.clear();
        });
        _verificarFin();
      } else {
        // incorrecto → esconder de nuevo después de 800ms
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
        title: const Text("Memorama - Karla Mejía"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _iniciarJuego,
          )
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // 5x4 o 4x5
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: _colores.length,
        itemBuilder: (context, index) {
          final revelada =
              _descubiertas[index] || _seleccionadas.contains(index);
          return GestureDetector(
            onTap: () => _tocarCarta(index),
            child: Container(
              decoration: BoxDecoration(
                color: revelada ? _colores[index] : Colors.grey,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          );
        },
      ),
    );
  }
}
