import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:punch_clock/punchClockDao.dart';
import 'package:punch_clock/punchClockModel.dart';

class ListPunchesClock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Históricos de pontos'),
      ),
      body: FutureBuilder<List<PunchClock>>(
        future: PunchClockDao().getAll(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os registros'));
          } else if (snapshot.hasData) {
            List<PunchClock> punchesClock = snapshot.data!;
            return ListView.builder(
              itemCount: punchesClock.length,
              itemBuilder: (context, index) {
                PunchClock punchClock = punchesClock[index];
                String formattedDateTime =
                    DateFormat('dd/MM/yyyy HH:mm').format(punchClock.date);

                return GestureDetector(
                  onTap: () {
                    LatLng position = LatLng(double.parse(punchClock.latitude),
                        double.parse(punchClock.longitude));

                    _openMap(position);
                  },
                  child: ListTile(
                    title: Text('ID: ${punchClock.id}'),
                    subtitle: Text(formattedDateTime),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('Nenhum registro encontrado'));
          }
        },
      ),
    );
  }

  _openMap(LatLng position) {
    MapsLauncher.launchCoordinates(position.latitude, position.longitude);
  }
}
