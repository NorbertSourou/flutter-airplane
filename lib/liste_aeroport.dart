import 'dart:convert';
import 'dart:math';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class AirportList extends StatefulWidget {
  const AirportList({Key? key}) : super(key: key);

  @override
  State<AirportList> createState() => _AirportListState();
}

class _AirportListState extends State<AirportList> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();

  List<String> getSuggestions(String query) {
    List<String> matches = <String>[];
    if (query.isNotEmpty) {
      matches.addAll(airports);
      matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    }
    return matches;
  }

  String? _selectedCity;
  Airports airport = Airports.departure;
  List<String> airports = [];
  late TextEditingController _controller2;
  String _valueChanged2 = '';
  String _valueToValidate2 = '';
  String _valueSaved2 = '';

  @override
  void initState() {
    loadJson();
    _controller2 = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SingleChildScrollView(
              child: Form(
                key: this._formKey,
                child: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Text('SKYTRACK',
                          style: GoogleFonts.montserrat(fontSize: 25)),
                      SizedBox(
                        height: 25,
                      ),
                      TypeAheadFormField(
                        hideOnEmpty: true,
                        suggestionsBoxDecoration:
                            const SuggestionsBoxDecoration(
                                elevation: 2,
                                constraints: BoxConstraints(maxHeight: 200)),
                        textFieldConfiguration: TextFieldConfiguration(
                          decoration: const InputDecoration(
                            hintText: "Liste des aéroports",
                            suffixIcon: Icon(Icons.airplanemode_on_outlined),
                            border: OutlineInputBorder(),
                          ),
                          controller: this._typeAheadController,
                        ),
                        suggestionsCallback: (pattern) {
                          // return CitiesService.getSuggestions(pattern);
                          return getSuggestions(pattern);
                        },
                        itemBuilder: (context, String suggestion) {
                          return ListTile(
                            minVerticalPadding: 0,
                            title: Text(suggestion),
                          );
                        },
                        transitionBuilder:
                            (context, suggestionsBox, controller) {
                          return suggestionsBox;
                        },
                        onSuggestionSelected: (String suggestion) {
                          this._typeAheadController.text = suggestion;
                        },
                        validator: (value) =>
                            value!.isEmpty ? 'Please select a city' : null,
                        onSaved: (value) => this._selectedCity = value,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: DateTimePicker(
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.date_range),
                                  hintText: 'Début',
                                  contentPadding: EdgeInsets.all(12),
                                  border: OutlineInputBorder()),

                              type: DateTimePickerType.dateTime,
                              dateMask: 'd MMMM, yyyy - hh:mm',
                              controller: _controller2,
                              //initialValue: _initialValue,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              //icon: Icon(Icons.event),
                              dateLabelText: 'Date Time',
                              use24HourFormat: false,
                              locale: Locale('fr', 'FR'),
                              onChanged: (val) =>
                                  setState(() => _valueChanged2 = val),
                              validator: (val) {
                                setState(() => _valueToValidate2 = val ?? '');
                                return null;
                              },
                              onSaved: (val) =>
                                  setState(() => _valueSaved2 = val ?? ''),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: DateTimePicker(
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.date_range),
                                  hintText: 'Fin',
                                  contentPadding: EdgeInsets.all(12),
                                  border: OutlineInputBorder()),

                              type: DateTimePickerType.dateTime,
                              dateMask: 'd MMMM, yyyy - hh:mm',
                              controller: _controller2,
                              //initialValue: _initialValue,
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                              //icon: Icon(Icons.event),
                              dateLabelText: 'Date Time',
                              use24HourFormat: false,
                              locale: Locale('fr', 'FR'),
                              onChanged: (val) =>
                                  setState(() => _valueChanged2 = val),
                              validator: (val) {
                                setState(() => _valueToValidate2 = val ?? '');
                                return null;
                              },
                              onSaved: (val) =>
                                  setState(() => _valueSaved2 = val ?? ''),
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 1,
                              child: Row(
                                children: [
                                  Radio(
                                      value: Airports.arrival,
                                      groupValue: airport,
                                      onChanged: (index) {
                                        setState(() {
                                          airport = index!;
                                        });
                                      }),
                                  Text(
                                    'Aéroport de départ',
                                    maxLines: 2,
                                  )
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 1,
                              child: Row(
                                children: [
                                  Radio(
                                      value: Airports.departure,
                                      groupValue: airport,
                                      onChanged: (index) {
                                        setState(() {
                                          airport = index!;
                                        });
                                      }),
                                  Text(
                                    'Aéroport de d\' arrivée',
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          child: Text('Rechercher'),
                          onPressed: () {
                            if (this._formKey.currentState!.validate()) {
                              this._formKey.currentState!.save();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Your Favorite City is ${this._selectedCity}'),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Divider(
                              endIndent: 10,
                              thickness: 1,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "Résultats",
                            style: GoogleFonts.montserrat(fontSize: 20),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 1,
                              indent: 10,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loadJson() async {
    final String response = await rootBundle.loadString('images/airports.json');
    final data = await json.decode(response);
    List<String> airportsName =
        List<String>.from(data.map((airport) => airport["name"]));
    setState(() {
      airports = airportsName;
    });
  }
}

enum Airports { departure, arrival }

class CitiesService {
  static final List<String> cities = [
    'Beirut',
    'Damascus',
    'San Fransisco',
    'Rome',
    'Los Angeles',
    'Madrid',
    'Bali',
    'Barcelona',
    'Paris',
    'Bucharest',
    'New York City',
    'Philadelphia',
    'Sydney',
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = <String>[];
    if (query.isNotEmpty) {
      matches.addAll(cities);
      matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    }
    return matches;
  }
}
