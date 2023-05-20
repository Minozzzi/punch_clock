import 'dart:async';
import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:punch_clock/listPunchesClock.dart';
import 'package:punch_clock/punchClockDao.dart';
import 'package:punch_clock/punchClockModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
  late Timer timer;
  late Position _currentPosition;

  @override
  void initState() {
    super.initState();
    _setCurrentPosition();

    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        currentTime = DateFormat('HH:mm:ss').format(DateTime.now());
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro de ponto remoto'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              currentTime,
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool hasServices = await _hasService();
                bool hasPermissions = await _hasPermissions();

                if (hasServices && hasPermissions) {
                  _registerPunchClock();
                } else {
                  return;
                }
              },
              child: Text('Registrar Ponto'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ListPunchesClock();
                }));
              },
              child: Text('Verificar Histórico'),
            ),
          ],
        ),
      ),
    );
  }

  void _registerPunchClock() async {
    _setCurrentPosition();

    final PunchClock punchClock = new PunchClock(
      id: Random().nextInt(999999),
      latitude: _currentPosition.latitude.toString(),
      longitude: _currentPosition.longitude.toString(),
      date: DateTime.now(),
    );

    await PunchClockDao().insert(punchClock);
  }

  Future<bool> _hasPermissions() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showMessage('Não será possível utilizar o recurso '
            'por falta de permissão');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      _showMessage('Para utilizar esse recurso, você deverá acessar '
          'as configurações do app para permitir a utilização do serviço de localização');
      Geolocator.openAppSettings();
      return false;
    }
    return true;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _setCurrentPosition() async {
    bool hasServivce = await _hasService();
    if (!hasServivce) {
      return;
    }
    bool hasPermissions = await _hasPermissions();
    if (!hasPermissions) {
      return;
    }
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });
  }

  Future<bool> _hasService() async {
    bool hasServices = await Geolocator.isLocationServiceEnabled();
    if (!hasServices) {
      await _showDialog(
          'Para utilizar esse recurso, você deverá habilitar o serviço'
          ' de localização');
      Geolocator.openLocationSettings();
      return false;
    }
    return true;
  }

  Future<void> _showDialog(String mensagem) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Atenção'),
        content: Text(mensagem),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(), child: Text('OK'))
        ],
      ),
    );
  }
}
