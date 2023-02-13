import 'dart:convert';
import 'dart:math';
import 'package:airplaine/model/arrival_departure.dart';
import 'package:airplaine/model/card_screen.dart';
import 'package:airplaine/urls.dart';
import 'package:http/http.dart' as http;
import 'package:date_time_picker/date_time_picker.dart';
import 'package:easy_autocomplete/easy_autocomplete.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class AirportList extends StatefulWidget {
  const AirportList({Key? key}) : super(key: key);

  @override
  State<AirportList> createState() => _AirportListState();
}

class _AirportListState extends State<AirportList> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  var tracksList;

  List<String> getSuggestions(String query) {
    List<String> matches = <String>[];
    if (query.isNotEmpty) {
      matches.addAll(airports);
      matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    }
    return matches;
  }

  List<Vol> flightsList = <Vol>[];
  String? _selectedCity;
  Airports airport = Airports.departure;
  States states = States.completed;

  List<String> airports = [];
  List<String> airportsIcao = [];
  late TextEditingController _controller2;
  late TextEditingController _controller1;
  String _valueChanged1 = '';
  String _valueToValidate1 = '';
  String _valueSaved1 = '';
  String _valueChanged2 = '';
  String _valueToValidate2 = '';
  String _valueSaved2 = '';

  @override
  void initState() {
    loadJson();
    _controller2 = TextEditingController();
    _controller1 = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Form(
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
                          controller: _typeAheadController,
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
                          // print(airportsIcao[airports.indexOf(suggestion)]);
                          //airportsIcao[airports.indexOf(suggestion)];
                          _typeAheadController.text = suggestion;
                        },
                        validator: (value) => value!.isEmpty
                            ? 'Veuillez choisir un aéroport'
                            : null,
                        onSaved: (value) => _selectedCity =
                            airportsIcao[airports.indexOf(value!)],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: DateTimePicker(
                                decoration: const InputDecoration(
                                    suffixIcon: Icon(Icons.date_range),
                                    hintText: 'Début',
                                    contentPadding: EdgeInsets.all(12),
                                    border: OutlineInputBorder()),
                                type: DateTimePickerType.dateTime,
                                dateMask: 'd MMMM, yyyy - hh:mm',
                                controller: _controller1,
                                //initialValue: _initialValue,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                                //icon: Icon(Icons.event),
                                dateLabelText: 'Date Time',
                                use24HourFormat: false,
                                locale: Locale('fr', 'FR'),
                                onChanged: (val) {
                                  setState(() => _valueChanged1 = val);
                                },
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Veuillez entrer une date';
                                  }
                                  setState(() {
                                    _valueToValidate1 = val ?? '';
                                  });
                                  return null;
                                },
                                onSaved: (val) {
                                  setState(() => _valueSaved1 = val ?? '');
                                }),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: DateTimePicker(
                              decoration: const InputDecoration(
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
                                if (val!.isEmpty) {
                                  return 'Veuillez entrer une date';
                                }
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
                                      value: Airports.departure,
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
                                      value: Airports.arrival,
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
                      const SizedBox(
                        height: 10.0,
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              disabledBackgroundColor: Colors.blue),
                          onPressed: states == States.loading
                              ? null
                              : () async {
                                  if (_formKey.currentState!.validate()) {
                                    // Convertion of dates
                                    var dateTime1 = _controller1.text
                                        .split(RegExp(r'(:)|(-)|( )'));
                                    var dateTime2 = _controller2.text
                                        .split(RegExp(r'(:)|(-)|( )'));

                                    final DateTime date1 = DateTime(
                                      int.parse(dateTime1[0].toString().trim()),
                                      int.parse(dateTime1[1].toString().trim()),
                                      int.parse(dateTime1[2].toString().trim()),
                                      int.parse(dateTime1[3].toString().trim()),
                                      int.parse(dateTime1[4].toString().trim()),
                                    );
                                    final DateTime date2 = DateTime(
                                      int.parse(dateTime2[0].toString().trim()),
                                      int.parse(dateTime2[1].toString().trim()),
                                      int.parse(dateTime2[2].toString().trim()),
                                      int.parse(dateTime2[3].toString().trim()),
                                      int.parse(dateTime2[4].toString().trim()),
                                    );

                                    final debut =
                                        (date1.millisecondsSinceEpoch / 1000)
                                            .round();
                                    final fin =
                                        (date2.millisecondsSinceEpoch / 1000)
                                            .round();
                                    _formKey.currentState!.save();
                                    setState(() {
                                      states = States.loading;
                                    });
                                    try {
                                      var response;
                                      var trackList;
                                      if (airport == Airports.departure) {
                                        response = await http.get(Uri.parse(
                                            "${AppUrls.baseUrl}${AppUrls.departure}airport=$_selectedCity&begin=$debut&end=$fin"));
                                      }
                                      if (airport == Airports.arrival) {
                                        response = await http.get(Uri.parse(
                                            "${AppUrls.baseUrl}${AppUrls.arrival}airport=$_selectedCity&begin=$debut&end=$fin"));
                                      }
                                      trackList = await http.get(Uri.parse(
                                          AppUrls.maps));

                                      tracksList=jsonDecode(trackList.body);
                                      print(jsonDecode(trackList.body));

                                      flightsList.clear();
                                      if (response.statusCode == 200) {
                                        jsonDecode(response.body).forEach((k) {
                                          flightsList.add(Vol.fromJson(k));
                                        });
                                      }
                                      states = States.completed;
                                      setState(() {
                                        flightsList;
                                      });

                                      //  print(jsonDecode(response.body));
                                      //                                       for (var volTemp
                                      //                                           in jsonDecode(response.body)) {
                                      //                                         flightsList
                                      //                                             .add(Vol.fromJson(volTemp));
                                      //                                       }

                                      // print(flightsList[0].icao24);

                                    } catch (e) {
                                      setState(() {
                                        states = States.error;
                                      });
                                      if (kDebugMode) {
                                        print(e);
                                      }
                                    }
                                  }
                                },
                          child: states == States.loading
                              ? const SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'Rechercher',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Expanded(
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
                          const Expanded(
                            child: Divider(
                              thickness: 1,
                              indent: 10,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      for (Vol currentFlight in flightsList)
                        flightsList.isEmpty
                            ? Text(
                                "Aucune donnée",
                                style: GoogleFonts.montserrat(fontSize: 45),
                              )
                            : GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CardScreen(trackList: tracksList,),
                                    ),
                                  );
                                },
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(Icons.flight),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(currentFlight.icao24,
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 21,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.flight_takeoff_outlined,
                                                  size: 30,
                                                ),
                                                SizedBox(
                                                  width: 6,
                                                ),
                                                Text(
                                                  currentFlight
                                                      .estDepartureAirport,
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.flight_land_outlined,
                                                  size: 30,
                                                ),
                                                const SizedBox(
                                                  width: 6,
                                                ),
                                                Text(
                                                  currentFlight
                                                      .estArrivalAirport,
                                                  style: GoogleFonts.montserrat(
                                                      fontSize: 30,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                  airportsIcao.contains(
                                                          currentFlight
                                                              .estDepartureAirport)
                                                      ? airports[airportsIcao
                                                          .indexOf(currentFlight
                                                              .estDepartureAirport)]
                                                      : "",
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 15,
                                                  )),
                                            ),
                                            Expanded(
                                              child: Align(
                                                alignment: Alignment.center,
                                                child: Text("O3h30mn",
                                                    style:
                                                        GoogleFonts.montserrat(
                                                            fontSize: 15,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                              ),
                                            ),
                                            Expanded(
                                              child: Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Text(
                                                  airportsIcao.contains(
                                                          currentFlight
                                                              .estArrivalAirport)
                                                      ? airports[airportsIcao
                                                          .indexOf(currentFlight
                                                              .estArrivalAirport)]
                                                      : "",
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 15,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                DateFormat('hh:mm').format(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        currentFlight
                                                                .firstSeen *
                                                            1000)),
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 21,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            Text(
                                                DateFormat('hh:mm').format(DateTime
                                                    .fromMillisecondsSinceEpoch(
                                                        currentFlight.lastSeen *
                                                            1000)),
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 21,
                                                    fontWeight:
                                                        FontWeight.w500)),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                DateFormat('dd/MM/yyyy').format(
                                                    DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            currentFlight
                                                                    .firstSeen *
                                                                1000)),
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 17)),
                                            Text(
                                                DateFormat('dd/MM/yyyy').format(
                                                    DateTime
                                                        .fromMillisecondsSinceEpoch(
                                                            currentFlight
                                                                    .lastSeen *
                                                                1000)),
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 17)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loadJson() async {
    final String response = await rootBundle.loadString('images/airports.json');
    final data = await json.decode(response);
    List<String> airportsName =
        List<String>.from(data.map((airport) => airport["name"]));
    List<String> airportsicao =
        List<String>.from(data.map((airport) => airport["icao"]));
    setState(() {
      airports = airportsName;
      airportsIcao = airportsicao;
    });
  }
}

enum Airports { departure, arrival }

enum States { loading, completed, error }
