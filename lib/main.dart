import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Delivery Distance Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: DeliveryForm(),
    );
  }
}

class DeliveryForm extends StatefulWidget {
  @override
  _DeliveryFormState createState() => _DeliveryFormState();
}

class _DeliveryFormState extends State<DeliveryForm> {
  final _buildingsController = TextEditingController();
  final _floorsController = TextEditingController();
  final _parcelsController = TextEditingController();
  final _parcelLocationsController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  int _numBuildings = 0;
  int _numFloors = 0;
  int _numParcels = 0;
  List<String> _parcels = [];

  void _calculateDistance() {
    int totalDistance = 0;
    int currentBuilding = 0;
    int currentFloor = 0;

    for (String parcel in _parcels) {
      List<String> parts = parcel.split('-');
      int building = int.parse(parts[0]);
      int floor = int.parse(parts[1]);

      int distanceToBuilding = (building - currentBuilding).abs();
      int distanceToFloor = (floor - currentFloor).abs();

      totalDistance += distanceToBuilding + distanceToFloor;

      currentBuilding = building;
      currentFloor = floor;
    }

    totalDistance += currentBuilding + currentFloor;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Total Distance'),
        content: Text(
            'Total distance to be travelled by the Delivery Boy: $totalDistance units'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetForm(); // Reset the form after showing the result
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _resetForm() {
    _formKey.currentState?.reset(); // Reset the form state
    _buildingsController.clear();
    _floorsController.clear();
    _parcelsController.clear();
    _parcelLocationsController.clear();
    setState(() {
      _numBuildings = 0;
      _numFloors = 0;
      _numParcels = 0;
      _parcels = [];
    });
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _numBuildings = int.parse(_buildingsController.text);
        _numFloors = int.parse(_floorsController.text);
        _numParcels = int.parse(_parcelsController.text);
        _parcels = _parcelLocationsController.text.split(',');
      });
      _calculateDistance();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delivery Distance Calculator'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Card(
          elevation: 5.0,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _buildingsController,
                    decoration: InputDecoration(
                      labelText: 'Number of buildings',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.apartment),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter number of buildings';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _floorsController,
                    decoration: InputDecoration(
                      labelText: 'Number of floors in a building',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.flood_rounded),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter number of floors';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _parcelsController,
                    decoration: InputDecoration(
                      labelText: 'Total number of parcels',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.mail),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter total number of parcels';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  TextFormField(
                    controller: _parcelLocationsController,
                    decoration: InputDecoration(
                      labelText: 'Delivery locations (format: a-b, a-b, ...)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter delivery locations';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _submit,
                    child: Text('Calculate Distance'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      primary: Colors.blue,
                      textStyle: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
